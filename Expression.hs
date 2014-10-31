{-# LANGUAGE LambdaCase #-}

module Expression
    ( Expression(..)
    , Access(..)
    , Binary(..)
    , Unary(..)
    , binaryOperation
    , unaryOperation
    , isComparable
    ) where

import          DataType
import          Identifier
import          Lexeme

import          Data.Sequence (Seq, fromList)
import          Data.Functor ((<$), (<$>))
import          Data.Foldable (concatMap, find)
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
    deriving (Eq, Ord)

instance Show Expression where
    show = \case
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

---------------------------------------------------------------------

data Access 
    = VariableAccess (Lexeme Identifier)
    | MatrixAccess (Lexeme Identifier) (Lexeme Expression) (Lexeme Expression)
    | RCAccess (Lexeme Identifier) (Lexeme Expression)
    deriving (Eq, Ord)

instance Show Access where
    show = \case
        VariableAccess idnL     -> lexInfo idnL
        MatrixAccess idnL sizeR sizeC -> lexInfo idnL ++ "[" ++ show (lexInfo sizeR) 
                                   ++ "," ++ show (lexInfo sizeC) ++ "]"
        RCAccess idnL expL -> lexInfo idnL ++ "[" ++ show (lexInfo expL) ++ "]"

---------------------------------------------------------------------

data Binary
    = OpSum | OpDiff | OpMul | OpDivEnt | OpModEnt | OpDiv | OpMod
    | OpCruzSum | OpCruzDiff | OpCruzMul | OpCruzDivEnt | OpCruzModEnt
    | OpCruzDiv | OpCruzMod
    | OpEqual | OpUnequal | OpLess | OpLessEq | OpGreat | OpGreatEq
    | OpOr | OpAnd
    deriving (Eq, Ord)

instance Show Binary where
    show = \case
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

--Comparacion de matrices? Rows? Cols?
binaryOperation :: Binary -> (DataType, DataType) -> Maybe DataType
binaryOperation op dts = snd <$> find ((dts==) . fst) (binaryOperator op)

binaryOperator :: Binary -> Seq ((DataType, DataType), DataType)
binaryOperator = fromList . \case
    OpSum -> arithmetic
    OpDiff -> arithmetic
    OpMul -> arithmetic
    OpDivEnt -> numeric
    OpModEnt -> numeric
    OpDiv -> numeric
    OpMod -> numeric
--    OpCruzSum ->
--    OpCruzDiff ->
--    OpCruzMul ->
--    OpCruzDivEnt -> 
--    OpCruzModEnt ->
--    OpCruzDiv ->
--    OpCruzMod ->
    OpEqual -> everythingCompare
    OpUnequal -> everythingCompare
    OpLess -> arithmeticCompare
    OpLessEq -> arithmeticCompare
    OpGreat -> arithmeticCompare
    OpGreatEq -> arithmeticCompare
    OpOr -> boolean
    OpAnd -> boolean
    where
      numeric = [((Double, Double), Double)]
      arithmetic = numeric -- ++ Rows, Cols, Matrix....
      boolean = [((Bool, Bool), Bool)]
      arithmeticCompare = [((Double, Double), Bool)] -- ++ Comparacion de rows, cols, matrix...
      everythingCompare = arithmeticCompare ++ boolean

---------------------------------------------------------------------

data Unary 
    = OpNegative
    | OpNot
    | OpTranspose
    deriving (Eq, Ord)

instance Show Unary where
    show = \case
        OpNegative   -> "-"
        OpNot        -> "not"
        OpTranspose  -> "transpose"

unaryOperation :: Unary -> DataType -> Maybe DataType
unaryOperation op dt = snd <$> find ((dt==) . fst) (unaryOperator op)

unaryOperator :: Unary -> Seq (DataType, DataType)
unaryOperator = fromList . \case
    OpNegative -> [(Double, Double)] -- ++ Row, Cols, Matrix
    OpNot -> [(Bool, Bool)]
 -- OpTranspose -> 

---------------------------------------------------------------------

isComparable :: Binary -> Bool
isComparable = flip elem [OpEqual,OpUnequal,OpLess,OpLessEq,OpGreat,OpGreatEq]

