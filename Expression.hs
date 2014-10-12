module Expression
    ( Expression(..)
    , Access(..)
    , Binary(..)
    , Unary(..)
    ) where

import          Identifier
import          Lexeme

import          Data.Sequence (Seq)
import          Data.Foldable (concatMap)
import          Prelude       hiding (concatMap)

data Expression
    = LitNumber (Lexeme Double)
    | LitBool (Lexeme Bool)
    | LitString (Lexeme String)
    | VariableId (Lexeme Identifier)
    | LitMatrix [Seq (Lexeme Expression)]
    | Proy (Lexeme Expression) (Seq (Lexeme Expression))
    | ExpBinary (Lexeme Binary) (Lexeme Expression) (Lexeme Expression)
    | ExpUnary (Lexeme Unary) (Lexeme Expression)

instance Show Expression where
    show exp = case exp of
        LitNumber vL        -> "Literal numérico: " ++ show (lexInfo vL)
        LitBool vL          -> "Literal booleano: " ++ show (lexInfo vL)
        LitString strL      -> "Literal string: "   ++ show (lexInfo strL)
        VariableId accL     -> "Identificador de variable: " ++ show (lexInfo accL)
        LitMatrix expS      -> "Literal Matricial: { " ++ " }"
        Proy expL expLs     -> "Proyección: " ++ show (lexInfo expL) ++ "[" 
                                ++ concatMap ( show . lexInfo) expLs ++ "]"        
        ExpBinary opL lL rL -> "Operador Binario: " ++ show (lexInfo lL) ++ " " 
                                ++ show (lexInfo opL) ++ " " ++ show (lexInfo rL)
        ExpUnary opL expL   -> "Operador Unario: " ++ show (lexInfo opL) ++ " " 
                                ++ show (lexInfo expL)


data Access 
    = VariableAccess (Lexeme Identifier)
    | MatrixAccess (Lexeme Identifier) (Seq (Lexeme Expression))

instance Show Access where
    show acc = case acc of
        VariableAccess idnL     -> lexInfo idnL
        MatrixAccess idnL expLs -> lexInfo idnL ++ "[" ++ concatMap (show . lexInfo) expLs ++ "]"

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
