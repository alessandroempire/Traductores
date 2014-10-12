{
module Parser
    ( parseProgram
    ) 
    where

import          Control.Monad        (unless)
import          Data.Functor         ((<$>),(<$))
import          Data.Maybe           (fromJust, isJust)
import          Data.Foldable        (concatMap)
import          Data.Sequence hiding (length)
import          Prelude       hiding (concatMap, foldr, zip)

import          Lexer
import          Program

}

--Por hacer: Impresiones con tabulaciones correctas.

%name parse
%tokentype { Lexeme Token }
%monad { Alex }
%lexer { lexWrap } { Lex TkEOF _ } 
%error { parseError }

--------------------------------------------------------
-- Tokens Reconocibles
--------------------------------------------------------

%token

    --Lenguaje
    "program"             { Lex TkProgram      _ }
    "begin"               { Lex TkBegin        _ }
    "end"                 { Lex TkEnd          _ }
    "function"            { Lex TkFunction     _ } 
    "return"              { Lex TkReturn       _ }
    ";"                   { Lex TkSemicolon    _ }
    ","                   { Lex TkComma        _ }
    ":"                   { Lex TkDoublePoint  _ }

    --Tipos
    "boolean"             { Lex TkBooleanType  _ }
    "number"              { Lex TkNumberType   _ }
    "matrix"              { Lex TkMatrixType   _ }             
    "row"                 { Lex TkRowType      _ }
    "col"                 { Lex TkColType      _ }

    --Brackets
    "("                   { Lex TkLParen       _ }
    ")"                   { Lex TkRParen       _ }
    "{"                   { Lex TkLLlaves      _ }
    "}"                   { Lex TkRLlaves      _ }
    "["                   { Lex TkLCorche      _ }
    "]"                   { Lex TkRCorche      _ }        

    --Condicionales
    "if"                  { Lex TkIf           _ }
    "else"                { Lex TkElse         _ }
    "then"                { Lex TkThen         _ }

    --Loops
    "for"                 { Lex TkFor          _ }
    "do"                  { Lex TkDo           _ }
    "while"               { Lex TkWhile        _ }

    --Entrada/Salida
    "print"               { Lex TkPrint        _ }
    "read"                { Lex TkRead         _ }

    --Operadores Booleanos
    "&"                   { Lex TkAnd          _ }
    "|"                   { Lex TkOr           _ }
    "not"                 { Lex TkNot          _ }

    "=="                  { Lex TkEqual        _ }
    "/="                  { Lex TkUnequal      _ }
    "<="                  { Lex TkLessEq       _ }
    "<"                   { Lex TkLess         _ }
    ">="                  { Lex TkGreatEq      _ }
    ">"                   { Lex TkGreat        _ }

    --Operadores Aritmeticos
    "+"                   { Lex TkSum          _ }
    "-"                   { Lex TkDiff         _ }
    "*"                   { Lex TkMul          _ }
    "/"                   { Lex TkDivEnt       _ }
    "%"                   { Lex TkModEnt       _ }
    "div"                 { Lex TkDiv          _ }
    "mod"                 { Lex TkMod          _ }
    "'"                   { Lex TkTrans        _ }

    --Operadores Cruzados 
    ".+."                 { Lex TkCruzSum      _ }
    ".-."                 { Lex TkCruzDiff     _ }
    ".*."                 { Lex TkCruzMul      _ }
    "./."                 { Lex TkCruzDivEnt   _ }
    ".%."                 { Lex TkCruzModEnt   _ }
    ".div."               { Lex TkCruzDiv      _ }
    ".mod."               { Lex TkCruzMod      _ }

    --Declaraciones
    "="                   { Lex TkAssign       _ }
    "use"                 { Lex TkUse          _ }
    "in"                  { Lex TkIn           _ }
    "set"                 { Lex TkSet          _ }

    --Expresiones literales 
    num                   { Lex (TkNumber _)   _ }
    "true"                { Lex (TkBoolean _)  _ }
    "false"               { Lex (TkBoolean _)  _ }
    string                { Lex (TkString _)   _ }

    --Identificadores
    id                    { Lex (TkId     _)   _ }

--------------------------------------------------------
-- Reglas Precedencia y Asociatividad
--------------------------------------------------------

--Asociatividad
--(Menor Precedencia)
%left "|"
%left "&"
%right "not"

%nonassoc "==" "/=" "<" "<=" ">" ">="

%left ".+." ".-."
%left ".*." "./." ".%." ".div." ".mod."

%left "+" "-"
%left "*" "/" "%" "div" "mod"
%left "'"
%left "["
%left NEG

%nonassoc MAX
--(Mayor Precedencia)

%%

--------------------------------------------------------
-- Gramatica
--------------------------------------------------------

Program :: { Program }
  : "program" "end" ";"    { Program empty empty }
  | "program" StatementList ";" "end" ";"    { Program empty $2 }
  | FunctionList ";" "program" StatementList ";" "end" ";"    { Program $1 $4 }

FunctionList :: { FunctionSeq }
  : Function    { singleton $1 }
  | FunctionList ";" Function    { $1 |> $3 }

Function :: { Lexeme Function }
  : "function" Id "(" MaybeSignature ")" "return" TypeId "begin" StatementList ";" "end"    { Function $2 $4 $7 $9 <$ $1 } 

StatementList :: { StatementSeq }
  : Statement    { expandStatement $1 }
  | StatementList ";" Statement    { $1 >< expandStatement $3 }

Statement :: { Lexeme Statement }
  --Asignacion
  : "set" Access "=" Expression    { StAssign $2 $4 <$ $1 }
  
  --Instrucciones de funciones
  | Id "(" MaybeExpressionList ")"    { StFunctionCall $1 $3 <$ $1 }
  | "return" Expression    { StReturn $2 <$ $1 }
  
  --Condicionales
  | "if" Expression "then" StatementList ";" "else" StatementList ";" "end"    { StIf $2 $4 $7 <$ $1 }
  | "if" Expression "then" StatementList ";" "end"    { StIf $2 $4 empty <$ $1 }
  
  --Loops
  | "for" Id "in" Expression "do" StatementList ";" "end"    { StFor $2 $4 $6 <$ $1 }
  | "while" Expression "do" StatementList ";" "end"    { StWhile $2 $4 <$ $1 }
  
  --I/O
  | "read" Id    { StRead $2 <$ $1 }
  | "print" ExpressionList    { StPrintList $2 <$ $1 }
  
  --Bloques anidados
  | "use" DeclarationSeq "in" StatementList ";" "end"    { StBlock $2 $4 <$ $1 }

DeclarationSeq :: { DeclarationSeq }
  :    { empty }
  | DeclarationList ";"    { $1 }

DeclarationList :: { DeclarationSeq }
  : Declaration    { singleton $1 }
  | DeclarationList ";" Declaration    { $1 |> $3 }

MaybeSignature :: { DeclarationSeq }
  :    { empty }
  | Signature    { $1 }

Signature :: { DeclarationSeq }
  : Declaration    { singleton $1 }
  | Signature "," Declaration    { $1 |> $3 }

Declaration :: { Lexeme Declaration }
  : TypeId Id   { Dcl $1 $2 <$ $1 }
  | TypeId Id "=" Expression   { DclInit $1 $2 $4 <$ $1 }
  
MaybeExpressionList :: { Seq (Lexeme Expression) }
  :    { empty }
  | ExpressionList    { $1 }

ExpressionList :: { Seq (Lexeme Expression) }
  : Expression    { singleton $1 }
  | ExpressionList "," Expression    { $1 |> $3 }

MatrixList :: { [Seq (Lexeme Expression)] }
  : ExpressionList    { [$1] }
  | MatrixList ":" ExpressionList    { $1 ++ [$3] }

Number :: { Lexeme Double }
  : num    { unTkNumber `fmap` $1 }

Bool :: { Lexeme Bool } 
  : "true"    { unTkBoolean `fmap` $1 }
  | "false"    { unTkBoolean `fmap` $1 }

String :: { Lexeme String }
  : string    { unTkString `fmap` $1 }

Access :: { Lexeme Access }
  : Id    { VariableAccess $1 <$ $1 }
  | Id "[" ExpressionList "]"    { MatrixAccess $1 $3 <$ $1 }

Id :: { Lexeme Identifier }
  : id    { unTkId `fmap` $1 }

TypeId :: { Lexeme TypeId }
  : "boolean"    { Bool <$ $1 }
  | "number"    { Double <$ $1 }
  | "matrix" "(" Expression "," Expression ")"    { Matrix $3 $5 <$ $1 }             
  | "row" "(" Expression ")"    { Row $3 <$ $1 }
  | "col" "(" Expression ")"    { Col $3 <$ $1 }

Expression :: { Lexeme Expression }
  : Number    { LitNumber $1 <$ $1 }
  | Bool    { LitBool $1 <$ $1 }
  | String    { LitString $1 <$ $1 }
  | Id  { VariableId $1 <$ $1 }
  | "{" MatrixList "}"    { LitMatrix $2 <$ $1 }
  | Expression "+" Expression    { ExpBinary (OpSum <$ $2) $1 $3 <$ $1 }
  | Expression "-" Expression    { ExpBinary (OpDiff <$ $2) $1 $3 <$ $1 }
  | Expression "*" Expression    { ExpBinary (OpMul <$ $2) $1 $3 <$ $1 }
  | Expression "/" Expression    { ExpBinary (OpDivEnt <$ $2) $1 $3 <$ $1 }
  | Expression "%" Expression    { ExpBinary (OpModEnt <$ $2) $1 $3 <$ $1 }
  | Expression "div" Expression    { ExpBinary (OpDiv <$ $2) $1 $3 <$ $1 }
  | Expression "mod" Expression    { ExpBinary (OpMod <$ $2) $1 $3 <$ $1 }
  | Expression ".+." Expression    { ExpBinary (OpCruzSum <$ $2) $1 $3 <$ $1 }
  | Expression ".-." Expression    { ExpBinary (OpCruzDiff <$ $2) $1 $3 <$ $1 }
  | Expression ".*." Expression    { ExpBinary (OpCruzMul <$ $2) $1 $3 <$ $1 }
  | Expression "./." Expression    { ExpBinary (OpCruzDivEnt <$ $2) $1 $3 <$ $1 }
  | Expression ".%." Expression    { ExpBinary (OpCruzModEnt <$ $2) $1 $3 <$ $1 }
  | Expression ".div." Expression    { ExpBinary (OpCruzDiv <$ $2) $1 $3 <$ $1 }
  | Expression ".mod." Expression    { ExpBinary (OpCruzMod <$ $2) $1 $3 <$ $1 }
  | Expression "|" Expression { ExpBinary (OpOr <$ $2) $1 $3 <$ $1 }
  | Expression "&" Expression { ExpBinary (OpAnd <$ $2) $1 $3 <$ $1 }
  | Expression "==" Expression { ExpBinary (OpEqual <$ $2) $1 $3 <$ $1 }
  | Expression "/=" Expression    { ExpBinary (OpUnequal <$ $2) $1 $3 <$ $1 }
  | Expression "<" Expression    { ExpBinary (OpLess <$ $2) $1 $3 <$ $1 }
  | Expression "<=" Expression    { ExpBinary (OpLessEq <$ $2) $1 $3 <$ $1 }
  | Expression ">" Expression    { ExpBinary (OpGreat <$ $2) $1 $3 <$ $1 }
  | Expression ">=" Expression    { ExpBinary (OpGreatEq <$ $2) $1 $3 <$ $1 } 
  | Expression "'"    { ExpUnary (OpTranspose <$ $2) $1 <$ $1 }
  | "-" Expression %prec NEG     { ExpUnary (OpNegative <$ $1) $2 <$ $1 }
  | Expression "[" ExpressionList "]" %prec MAX    { Proy $1 $3 <$ $1 }
  | "not" Expression    { ExpUnary (OpNot <$ $1) $2 <$ $1 }
  | "(" Expression ")"     { lexInfo $2 <$ $1 }

{
--------------------------------------------------------
-- Codigo Haskell
--------------------------------------------------------
expandStatement :: Lexeme Statement -> StatementSeq
expandStatement stL = case lexInfo stL of
    StPrintList exps -> fmap (\exp -> StPrint exp <$ stL) exps
    _ -> singleton stL

lexWrap :: (Lexeme Token -> Alex a) -> Alex a
lexWrap = (alexMonadScanTokens >>=)

parseError :: Lexeme Token -> Alex a
parseError (Lex t p) = fail $ "Error de Sintaxis, Token: " ++ 
                            show t ++ " " ++ show p ++ "\n"

parseProgram :: String ->  (Seq LexicalError, Program)
parseProgram input = runAlex' input parse
}
