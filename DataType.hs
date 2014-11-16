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
    | DataMatrix [[Number]]
    | DataEmpty

instance Show TypeValue where
    show = \case
        DataBool b          -> "Bool " ++ show b
        DataNumber n        -> "Number " ++ show n
        DataMatrix m        -> "Matrix " ++ show m
        DataEmpty           -> error "TypeValue: Empty"

defaultValue :: DataType -> TypeValue
defaultValue = \case
    Bool -> DataBool False
    Number -> DataNumber 0.0 
    Matrix row col -> DataMatrix $ replicate (floor $ lexInfo row) $ replicate (floor $ lexInfo col) 0.0
    Row size -> DataMatrix $ replicate (floor $ lexInfo size) [0.0]
    Col size -> DataMatrix $ [replicate (floor $ lexInfo size) 0.0]
    _ -> DataEmpty

