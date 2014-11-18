{-# LANGUAGE LambdaCase #-}

module DataType
    ( DataType(..)
    , Number
    , toIdentifier
    , isScalar
    , isNumber
    , isMatrix
    , isRow
    , isCol
    , isValid
    , TypeValue(..)
    , defaultValue
    ) where

import          Lexeme
import          Identifier
import          Matriz

import          Data.Function (on)

type Number = Double

data DataType 
    = Bool 
    | Number
    | String
    | Matrix (Lexeme Double) (Lexeme Double)
    | Row (Lexeme Double)
    | Col (Lexeme Double)
    | TypeError
    deriving (Ord)

instance Show DataType where
    show = \case
        Bool            -> "Bool"
        Number          -> "Number"
        String          -> "String"
        Matrix sizeR sizeC -> "Matrix(" ++ show (lexInfo sizeR) ++ "," ++ show (lexInfo sizeC) ++ ")"
        Row size        -> "Row(" ++ show (lexInfo size) ++ ")"
        Col size        -> "Col(" ++ show (lexInfo size) ++ ")"
        TypeError       -> error "DataType: TypeError"

instance Eq DataType where
    a == b = case (a,b) of
        (Bool, Bool)                           -> True
        (Number, Number)                       -> True
        (String, String)                       -> True
        (Matrix rowA colA, Matrix rowB colB)   -> (comp rowA rowB) && (comp colA colB)
        (Row sizeA, Row sizeB)                 -> comp sizeA sizeB
        (Col sizeA, Col sizeB)                 -> comp sizeA sizeB
        (Row sizeC, Matrix rowM colM)          -> (comp sizeC rowM) && ((lexInfo colM) == 1) 
        (Col sizeR, Matrix rowM colM)          -> (comp sizeR colM) && ((lexInfo rowM) == 1)
        (TypeError, TypeError)                 -> True
        _                                      -> False
        where
            comp :: Eq a => Lexeme a -> Lexeme a -> Bool
            comp = (==) `on` lexInfo

---------------------------------------------------------------------

toIdentifier :: DataType -> Identifier
toIdentifier dt = case dt of
    Bool       -> "Bool"
    Number     -> "Number"
    String     -> "String"
    Matrix _ _ -> "Matrix"
    Row _      -> "Row"
    Col _      -> "Col"
    TypeError  -> "Error"

isScalar :: DataType -> Bool
isScalar = flip elem [Number, Bool]

isNumber :: DataType -> Bool
isNumber = \case
    Number -> True
    _      -> False

isMatrix :: DataType -> Bool
isMatrix = \case
    Matrix _ _ -> True
    _          -> False

isRow :: DataType -> Bool
isRow = \case
    Row _ -> True
    _     -> False

isCol :: DataType -> Bool
isCol = \case
    Col _ -> True
    _     -> False

isValid :: DataType -> Bool
isValid = (/= TypeError)

---------------------------------------------------------------------

data TypeValue 
    = DataBool Bool 
    | DataNumber Number
    | DataMatrix (Matriz TypeValue)
    | DataString String
    | DataEmpty

instance Show TypeValue where
    show = \case
        DataBool b   -> "Bool " ++ show b
        DataNumber n -> "Number " ++ show n
        DataMatrix m -> "Matrix \n" ++ show m ++ "\n"
        DataString s -> "String " ++ show s
        DataEmpty    -> error "TypeValue: Empty"

instance Eq TypeValue where
    a == b = case (a,b) of
        (DataBool bl, DataBool br)             -> bl == br
        (DataNumber n, DataNumber m)           -> n == m
        (DataString ls, DataString rs)         -> ls == rs
        (DataEmpty, DataEmpty)                 -> True
        _                                      -> False


instance Num TypeValue  where
    a + b = case (a, b) of
        (DataNumber m, DataNumber n) -> DataNumber (m + n)
        (DataMatrix m, DataMatrix n) -> error "loco"--DataMatrix (sumarM m n)
        _ -> error "error: no se pueden sumar tipos distintos de numeros"
    a - b = case (a, b) of
        (DataNumber m, DataNumber n) -> DataNumber (m - n)
        (DataMatrix m, DataMatrix n) -> DataMatrix (restarM m n)
        _ -> error "error: no se pueden restar tipos distintos de numeros"
    a * b = case (a, b) of
        (DataNumber m, DataNumber n) -> DataNumber (m * n)
        (DataMatrix m, DataMatrix n) -> error "loco2" --DataMatrix (multStd m n)
        _ -> error "error: no se pueden multiplicar tipos distintos de numeros"
    negate a = case a of
        DataNumber m -> DataNumber (-m)
        DataMatrix m -> DataMatrix (negate m)
        _ -> error "error: no se pueden negar tipos distintos de numeros"
    abs a = case a of
        DataNumber m -> DataNumber (abs m)
        DataMatrix m -> error "error operacion no implementada abs de matriz"
        _ -> error "error: no se puede obtener el valor absoluto de tipos distintos de numeros"
    signum a = case a of
        DataNumber m -> DataNumber (signum m)
        DataMatrix m -> error "error operacion no implementada signum de matriz"
        _ -> error "error: no se pueden obtener el signum de tipos distintos de numeros"
    fromInteger a = case a of
        --DataNumber m -> error "Datanumber"
        _ -> error "error: operacion no soportada por los Number"


--------------------------------------------------------------------- 
defaultValue :: DataType -> TypeValue
defaultValue = \case
    Bool           -> DataBool False
    Number         -> DataNumber 0.0 
    Matrix row col -> DataMatrix $ zero (floor $ lexInfo row) (floor $ lexInfo col) (DataNumber 0.0)
    Row size -> DataMatrix $ zero 1 (floor $ lexInfo size) (DataNumber 0.0) 
    Col size -> DataMatrix $ zero (floor $ lexInfo size) 1 (DataNumber 0.0)
    _        -> DataEmpty

