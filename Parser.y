{
module Parser
    ( parse
    ) 
    where

import          Lexer

import          Control.Monad (unless)
import          Data.Functor ((<$>),(<$))
import          Data.Maybe (fromJust, isJust)
import          Data.Sequence hiding (length)
import          Data.Foldable (concatMap)
import          Prelude hiding (concatMap, foldr, zip)

}

%name parse
%tokentype { Lexeme Token }
%monad { Alex }
-- %lexer { lexWrap } { Lex TkEOF }
-- %error { parsingError }
-- Hay que agregar la funcion de error, ademas de errores en gramatica...
-- Fijate en la definicion de lexWrap de Matteo. No nos sirve (al menos por ahora)
-- porque nosotros no definimos tokens de error. 

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

%left "+" "-"
%left "*" "/" "%" "div" "mod"
-- %right "'" REVISAR TRASPUESTA
--(Mayor Precedencia)

%%

--------------------------------------------------------
-- Gramatica
--------------------------------------------------------

Program :: { Program } --Tipo retornado.
  : FuncSeq "program" StBlock "end" ";"    { Program $1 $3 }

FuncSeq :: { FuncSeq }
  :    { empty }
  | FunctionList    { $1 }

FunctionList :: { FuncSeq }
  : FunctionDef    { singleton $1 }
  | FunctionList ; FuntionDef    { $1 |> $3 }

FunctionDef :: { Lexeme Function }
  : "function" Id "(" DeclarationList ")" "return" TypeId "begin" StatementList "end"    { Function $2 $4 $7 $9 <$ $1 } 

StBlock :: { StBlock }
  : "use" DeclarationList "in" StatementList "end" ";"    { StBlock $2 $4 <$ $1 }

--Puede ser vacia?
DeclarationList :: { DeclarationSeq }
  : Declaration    { singleton $1 }
  | DeclarationList ";" Declaration    { $1 |> $3 }

Declaration :: { Lexeme Declaration }
  : TypeId Id    { Declaration $1 $2 empty <$ $1 }
  | TypeId Id "=" Expression    {  Declaration $1 $2 $4 <$ $1 }

Id :: { Lexeme Identifier }
  : id    { unTkId `fmap` $1 }

TypeId :: { Lexeme TypeId }
  : "boolean"    { Bool <$ $1 }
  | "number"    { Double <$ $1 }
  | "matrix" "(" ExpressionList ")"    { Matrix $3 <$ $1 }             
  | "row" "(" Expression ")"    { Row $3 <$ $1 }
  | "col" "(" Expression ")"    { Col $3 <$ $1 }

StatementList :: { StatementSeq }
  : Statement    { expandStatement $1 }
  | StatementList ";" Statement    { $1 >< expandStatement $3 }

Statement :: { Lexeme Statement }
  : { -λ, no-op - }    { fillLex StNoop }
  --Asignacion
  | "set" Access "=" Expression    { StAssign $2 $4 <$ $1 }
  --Funciones
  | Id "(" MaybeExpressionList ")"    { StFunctionCall $1 $3 <$ $1 }
  | "return" Expression    { StReturn $2 <$ $1 }
  --Condicionales
  | "if" Expression "then" StatementList "else" StatementList "end"    { StIf $2 $4 $6 <$ $1 }
  | "if" Expression "then" StatementList "end"    { StIf $2 $4 empty <$ $1 }
  --Loops
  | "for" Id "in" Expression "do" StatementList "end"    { StFor $2 $4 $6 <$ $1 }
  | "while" Expression "do" StatementList "end"    { StWhile $2 $4 <$ $1 }
  --I/O
  | "read" Access    { StRead $2 <$ $1 }
  | "print" ExpressionList    { StPrintList $3 <$ $1 }
  
Access :: { Lexeme Access }
  : Id    { VariableAccess $1 <$ $1 }
  | Id "[" Expression "]"    { MatrixAccess $1 $3 <$ $1 }

ExpressionList :: { Seq (Lexeme Expression) }
  : Expression    { singleton $1 }
  | ExpressionList "," Expression    { $1 |> $3 }

MaybeExpressionList :: { Seq (Lexeme Expression) }
  :    { empty }
  | ExpressionList    { $1 }

Number :: { Lexeme Double }
  : num    { unTkNumber `fmap` $1 }

Bool :: { Lexeme Bool } 
  : "true"    { unTkBoolean `fmap` $1 }
  | "false"    { unTkBoolean `fmap` $1 }

String :: { Lexeme String }
  : string    { unTkString `fmap` $1 }

Expression :: { Lexeme Expression }
  : Num    { LitNumber $1 <$ $1 }
  | Bool    { LitBoolean $1 <$ $1 }
  | String    { LitString $1 <$ $1 }
  | Access    { Variable $1 <$ $1 }
  --Falta literales matriciales...Y proyeccion de componentes...
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
--  | Expression "'"    { }
  | "-" Expression { ExpUnary (OpNegative <$ $1) $2 <$ $1 }
  | "not" Expression    { ExpUnary (OpNot <$ $1) $2 <$ $1 }
  | "(" Expression ")"     { lexInfo $2 <$ $1 }

--------------------------------------------------------
-- Codigo Haskell
--------------------------------------------------------

{

newtype Program = Program FuncSeq StBlock

--instance Show Program where
--    show (Program sts) = --Hay que definirlo...

type FuncSeq = Seq (Lexeme Function)

data StBlock = StBlock DeclarationSeq StatementSeq

type DeclarationSeq = Seq (Lexeme Declaration)    

type StatementSeq = Seq (Lexeme Statement)

data Function 
    = Function (Lexeme Identifier) DeclarationSeq (Lexeme TypeId) StatementSeq
    deriving (Show)

data Declaration = Declaration
    { dclIdentifier :: Lexeme Identifier
    , dclType :: Lexeme TypeId
    , dclInit :: Lexeme Expression
    } 
    deriving (Show)

type Identifier = String

data TypeId 
    = Bool 
    | Double
    | Matrix (Seq (Lexeme Expression))
    | Row (Lexeme Expression)
    | Col (Lexeme Expression)
    deriving (Eq, Ord)

instance Show TypeId where
    show tid = case tid of
        Bool -> "Bool"
        Double -> "Number"
--        Matrix exp -> " " ++ concatMap (++) lexInfo idnL
        Row exp -> "Row" ++ lexInfo exp
        Col exp -> "Col" ++ lexInfo exp

data Statement
    = StNoop
    | StAssign (Lexeme Access) (Lexeme Expression)
    | StFunctionCall (Lexeme Identifier) (Seq (Lexeme Expression))
    | StReturn (Lexeme Expression)
    | StRead (Lexeme Access)
    | StPrint (Lexeme Expression)
    | StPrintList (Seq (Lexeme Expression))
    | StIf (Lexeme Expression) StatementSeq StatementSeq
    | StFor (Lexeme Identifier) (Lexeme Expression) StatementSeq
    | StWhile (Lexeme Expression) StBlock
    deriving (Show)

data Expression
    = LitNumber (Lexeme Double)
    | LitBool (Lexeme Bool)
    | LitString (Lexeme String)
    | Variable (Lexeme Access)
    | ExpBinary (Lexeme Binary) (Lexeme Expression) (Lexeme Expression)
    | ExpUnary (Lexeme Unary) (Lexeme Expression)
    deriving (Eq, Ord, Show)

data Binary
    = OpSum | OpDiff | OpMul | OpDivEnt | OpModEnt | OpDiv | OpMod |
    | OpCruzSum | OpCruzDiff | OpCruzMul | OpCruzDivEnt | OpCruzModEnt
    | OpCruzDiv | OpCruzMod
    | OpEqual | OpUnequal | OpLess | OpLessEq | OpGreat | OpGreatEq
    | OpOr | OpAnd
    deriving (Eq, Ord)

instance Show Binary where
    show op = case op of
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
    deriving (Eq, Ord)

instance Show Unary where
    show op = case op of
        OpNegative   -> "-"
        OpNot        -> "not"

data Access 
    = VariableAccess (Lexeme Identifier)
    | MatrixAccess (Lexeme Access) (Lexeme Expression)
    deriving (Eq, Ord)

instance Show Access where
    show acc = case acc of
        VariableAccess idnL -> lexInfo idnL
        MatrixAccess accL indL -> show (lexInfo accL) ++ "[" ++ show (lexInfo indL) ++ "]"


expandStatement :: Lexeme Statement -> StatementSeq
    expandStatement stL = case lexInfo stL of
        StNoop -> empty
        StPrintList exps -> fmap (\exp -> StPrint exp <$ stL) exps
        _ -> singleton stL

}
