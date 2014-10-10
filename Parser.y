{
module Parser
    ( parseProgram
    ) 
    where

import          Control.Monad (unless)
import          Data.Functor ((<$>),(<$))
import          Data.Maybe (fromJust, isJust)
import          Data.Sequence hiding (length)
import          Data.Foldable (concatMap)
import          Prelude hiding (concatMap, foldr, zip)

import          Lexer

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
%left NEG
%nonassoc "["

%nonassoc MAX
--(Mayor Precedencia)

%%

--------------------------------------------------------
-- Gramatica
--------------------------------------------------------

Program :: { Program } --Tipo retornado.
  : StatementList ";" "program" StatementList ";" "end" ";"    { Program $1 $4 }
  | "program" StatementList ";" "end" ";"    { Program empty $2 }

StatementList :: { StatementSeq }
  : Statement    { expandStatement $1 }
  | StatementList ";" Statement    { $1 >< expandStatement $3 }

Statement :: { Lexeme Statement }
--  : { - empty - }    { pure StNoop }
  --Asignacion
  : "set" Access "=" Expression    { StAssign $2 $4 <$ $1 }
  --Funciones
--  | "function" Id "(" MaybeSignature ")" "return" TypeId "begin" StatementList ";" "end"    { StFunctionDef $2 $4 $7 $9 <$ $1 } 
  | Id "(" MaybeExpressionList ")"    { StFunctionCall $1 $3 <$ $1 }
  | "return" Expression    { StReturn $2 <$ $1 }
  --Condicionales
  | "if" Expression "then" StatementList ";" "else" StatementList ";" "end"    { StIf $2 $4 $7 <$ $1 }
  | "if" Expression "then" StatementList ";" "end"    { StIf $2 $4 empty <$ $1 }
  --Loops
  | "for" Id "in" Expression "do" StatementList ";" "end"    { StFor $2 $4 $6 <$ $1 }
  | "while" Expression "do" StatementList ";" "end"    { StWhile $2 $4 <$ $1 }
  --I/O
  | "read" Access    { StRead $2 <$ $1 }
  | "print" ExpressionList    { StPrintList $2 <$ $1 }
  --Bloques anidados
  | "use" DeclarationSeq "in" StatementList ";" "end"   { StBlock $2 $4 <$ $1 }

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

Id :: { Lexeme Identifier }
  : id    { unTkId `fmap` $1 }

TypeId :: { Lexeme TypeId }
  : "boolean"    { Bool <$ $1 }
  | "number"    { Double <$ $1 }
  | "matrix" "(" ExpressionList ")"    { Matrix $3 <$ $1 }             
  | "row" "(" Expression ")"    { Row $3 <$ $1 }
  | "col" "(" Expression ")"    { Col $3 <$ $1 }

Expression :: { Lexeme Expression }
  : Number    { LitNumber $1 <$ $1 }
  | Bool    { LitBool $1 <$ $1 }
  | String    { LitString $1 <$ $1 }
  | Access    { Variable $1 <$ $1 }
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

--------------------------------------------------------
-- Codigo Haskell
--------------------------------------------------------

{

data Program = Program StatementSeq StatementSeq

instance Show Program where
    show (Program funS stB) = concatMap ((++) "\n" . show . lexInfo) funS ++ "\nprogram\n\t" ++ concatMap ((++) "\n" . show . lexInfo) stB ++ "\nend"

type DeclarationSeq = Seq (Lexeme Declaration)    

data Declaration 
    = Dcl (Lexeme TypeId) (Lexeme Identifier)
    | DclInit (Lexeme TypeId) (Lexeme Identifier) (Lexeme Expression)

instance Show Declaration where
    show dcl = case dcl of
         Dcl tL idL -> show (lexInfo tL) ++ "  " ++ lexInfo idL
         DclInit tL idL expL -> show (lexInfo tL) ++ "  " ++ lexInfo idL ++ "= " ++ show (lexInfo expL) 

type Identifier = String

data TypeId 
    = Bool 
    | Double
    | Matrix (Seq (Lexeme Expression))
    | Row (Lexeme Expression)
    | Col (Lexeme Expression)

instance Show TypeId where
    show t = case t of
        Bool -> "Bool"
        Double -> "Number"
        Matrix expLs -> "Matrix("  ++ concatMap (show . lexInfo) expLs ++ ")"
        Row exp -> "Row(" ++ show (lexInfo exp) ++ ")"
        Col exp -> "Col(" ++ show (lexInfo exp) ++ ")"

type StatementSeq = Seq (Lexeme Statement)

data Statement
    = StNoop
    | StAssign (Lexeme Access) (Lexeme Expression)
    | StFunctionDef (Lexeme Identifier) DeclarationSeq (Lexeme TypeId) StatementSeq
    | StFunctionCall (Lexeme Identifier) (Seq (Lexeme Expression))
    | StReturn (Lexeme Expression)
    | StRead (Lexeme Access)
    | StPrint (Lexeme Expression)
    | StPrintList (Seq (Lexeme Expression))
    | StIf (Lexeme Expression) StatementSeq StatementSeq
    | StFor (Lexeme Identifier) (Lexeme Expression) StatementSeq
    | StWhile (Lexeme Expression) StatementSeq
    | StBlock DeclarationSeq StatementSeq

instance Show Statement where
    show st = case st of
        StAssign accL expL -> "set " ++ show (lexInfo accL) ++ " = " ++ show (lexInfo expL)
        StFunctionDef idnL _ _ _ -> "function " ++ lexInfo idnL
        StFunctionCall idnL expLs -> lexInfo idnL ++ "(" ++ concatMap (show . lexInfo) expLs ++ ")"
        StReturn expL -> "return " ++ show (lexInfo expL)
        StRead accL -> "read " ++ show (lexInfo accL)
        StPrint expL -> "print " ++ show (lexInfo expL)
        StIf expL _ _ -> "if " ++ show (lexInfo expL) ++ " then .. end"
        StFor idnL expL _ -> "for " ++ lexInfo idnL ++ " in " ++ show (lexInfo expL) ++ " do .. end"
        StWhile expL _ -> "while " ++ show (lexInfo expL) ++ "do .. end"
        StBlock dclLs stLs -> "\tuse\n\t" ++ concatMap ((++) "\n\t\t" . show . lexInfo) dclLs ++ 
                             "\n\tin\n\t " ++  concatMap ( (++) "\n\t\t" . show . lexInfo) stLs ++ "\n\tend"

data Expression
    = LitNumber (Lexeme Double)
    | LitBool (Lexeme Bool)
    | LitString (Lexeme String)
    | Variable (Lexeme Access)
    | LitMatrix [Seq (Lexeme Expression)]
    | Proy (Lexeme Expression) (Seq (Lexeme Expression))
    | ExpBinary (Lexeme Binary) (Lexeme Expression) (Lexeme Expression)
    | ExpUnary (Lexeme Unary) (Lexeme Expression)

instance Show Expression where
    show exp = case exp of
        LitNumber vL -> show (lexInfo vL)
        LitBool vL -> show (lexInfo vL)
        LitString strL -> show (lexInfo strL)
        Variable accL -> show (lexInfo accL)
        LitMatrix expS -> "{ Literal matricial }"
        Proy expL expLs -> show (lexInfo expL) ++ "[" ++ concatMap (show . lexInfo) expLs ++ "]"        
        ExpBinary opL lExpL rExpL -> show (lexInfo lExpL) ++ " " ++ show (lexInfo opL) ++ " " ++ show (lexInfo rExpL)
        ExpUnary opL expL -> show (lexInfo opL) ++ " " ++ show (lexInfo expL)

data Binary
    = OpSum | OpDiff | OpMul | OpDivEnt | OpModEnt | OpDiv | OpMod
    | OpCruzSum | OpCruzDiff | OpCruzMul | OpCruzDivEnt | OpCruzModEnt
    | OpCruzDiv | OpCruzMod
    | OpEqual | OpUnequal | OpLess | OpLessEq | OpGreat | OpGreatEq
    | OpOr | OpAnd

instance Show Binary where
    show bexp = case bexp of
        OpSum        -> "+"
        OpDiff       -> "-"
        OpMul        -> "*"
        OpDivEnt     -> "/"
        OpModEnt     -> "%"
        OpDiv        -> "div"
        OpMod        -> "mod"
        OpCruzSum    -> ".+."
        OpCruzDiff   -> ".-."
        OpCruzMul    -> ".*."
        OpCruzDivEnt -> "./."
        OpCruzModEnt -> ".%."
        OpCruzDiv    -> ".div."
        OpCruzMod    -> ".mod."
        OpEqual      -> "=="
        OpUnequal    -> "/="
        OpLess       -> "<"
        OpLessEq     -> "<="
        OpGreat      -> ">" 
        OpGreatEq    -> ">="
        OpOr         -> "|"
        OpAnd        -> "&"

data Unary 
    = OpNegative
    | OpNot
    | OpTranspose

instance Show Unary where
    show uexp = case uexp of
        OpNegative   -> "-"
        OpNot        -> "not"
        OpTranspose  -> "transpose"

data Access 
    = VariableAccess (Lexeme Identifier)

instance Show Access where
    show acc = case acc of
        VariableAccess idnL -> lexInfo idnL

expandStatement :: Lexeme Statement -> StatementSeq
expandStatement stL = case lexInfo stL of
    StNoop -> empty
    StPrintList exps -> fmap (\exp -> StPrint exp <$ stL) exps
    _ -> singleton stL

lexWrap :: (Lexeme Token -> Alex a) -> Alex a
lexWrap = (alexMonadScanTokens >>=)

parseError :: Lexeme Token -> Alex a
parseError (Lex t p) = fail $ "Error de Sintaxis, Token: " ++ show t ++ " " ++ showPosn p ++ "\n"

parseProgram :: String ->  (Seq LexicalError, Program)
parseProgram input = runAlex' input parse

}
