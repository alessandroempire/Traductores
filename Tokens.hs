module Tokens
    ( Token(..)
    ) where

data Token =

    --Lenguaje 
    TkProgram | TkBegin | TkEnd | TkFunction | TkReturn | TkSemicolon 
    | TkComma | TkDoublePoint

    --Tipos
    | TkBooleanType | TkNumberType | TkMatrixType | TkRowType | TkColType

    --Brackets
    | TkLParen | TkRParen | TkLLlaves | TkRLlaves | TkLCorche | TkRCorche

    --Condicionales
    | TkIf | TkElse | TkThen

    --Loops
    | TkFor | TkDo | TkWhile

    --E/S
    | TkPrint | TkRead

    --Operadores Booleanos
    | TkAnd | TkOr | TkNot | TkEqual | TkUnequal 
    | TkLess | TkLessEq | TkGreat | TkGreatEq

    --Operadores Aritméticos
    | TkSum | TkDiff | TkMul | TkDivEnt | TkModEnt | TkDiv | TkMod | TkTrans

    --Operadores Cruzados 
    | TkCruzSum | TkCruzDiff | TkCruzMul | TkCruzDivEnt | TkCruzModEnt 
    | TkCruzDiv | TkCruzMod

    --Declaraciones/Asignaciones
    | TkAssign | TkUse | TkIn | TkSet

    --Expresiones literales
    | TkNumber  { unTkNumber :: Double }
    | TkBoolean { unTkBoolean :: Bool } 
    | TkString  { unTkString :: String }

    --Identificadores
    | TkId { unTkId :: String }

    --Compilador
    | TkEOF

    deriving (Eq)

instance Show Token where
    show tk = case tk of 

        TkProgram       -> "'program'"
        TkBegin         -> "'begin'"
        TkEnd           -> "'end'"
        TkReturn        -> "'return'"
        TkFunction      -> "'function'"
        TkSemicolon     -> "';'"
        TkComma         -> "','"
        TkDoublePoint   -> "':'"
        TkAssign        -> "'='"
        TkUse           -> "'use'"
        TkIn            -> "'in'"
        TkSet           -> "'set'"       
        TkLParen        -> "'('"
        TkRParen        -> "')'"
        TkLLlaves       -> "'{'"
        TkRLlaves       -> "'}'"
        TkLCorche       -> "'['"
        TkRCorche       -> "']'"
        TkBooleanType   -> "type 'Bool'"
        TkNumberType    -> "type 'Number'"
        TkMatrixType    -> "type 'Matrix'"
        TkRowType       -> "type 'Row'"	
        TkColType       -> "type 'Col'"	
        TkIf            -> "'if'"
        TkElse          -> "'else'"
        TkThen          -> "'then'"
        TkFor           -> "'for'"
        TkDo            -> "'do'"
        TkWhile         -> "'while'"
        TkPrint         -> "'print'"
        TkRead          -> "'read'"
        TkAnd           -> "'&'"
        TkOr            -> "'|'"
        TkNot           -> "'not'"
        TkEqual         -> "'=='"
        TkUnequal       -> "'/='"
        TkLess          -> "'<'"
        TkLessEq        -> "'<='"
        TkGreat         -> "'>'"
        TkGreatEq       -> "'>='"
        TkSum           -> "'+'"
        TkDiff          -> "'-'"
        TkMul           -> "'*'"
        TkDivEnt        -> "'/'"
        TkModEnt        -> "'%'"
        TkDiv           -> "'div'"
        TkMod           -> "'mod'"
        TkTrans         -> "'''"
        TkCruzSum       -> "'.+.'"
        TkCruzDiff      -> "'.-.'"
        TkCruzMul       -> "'.*.'"
        TkCruzDivEnt    -> "'./.'"
        TkCruzModEnt    -> "'.%.'"
        TkCruzDiv       -> "'.div.'"
        TkCruzMod       -> "'.mod.'"
        TkEOF           -> "'EOF'"
        TkNumber n      -> "literal 'Number' " ++ show n
        TkBoolean b      -> "literal 'Bool' " ++ show b
        TkString s      -> "literal 'String' " ++ s
        TkId i          -> "identificador de variable " ++ i
