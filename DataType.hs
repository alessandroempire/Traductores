{-# LANGUAGE LambdaCase #-}

module DataType
    ( DataType(..)
    , toIdentifier
    , isScalar
    , isMatrix
    , isRow
    , isCol
    , isValid
    ) where

import          Lexeme
import          Identifier

import          Data.Function (on)

data DataType 
    = Bool 
    | Double
    | String
    | Matrix (Lexeme Double) (Lexeme Double)
    | Row (Lexeme Double)
    | Col (Lexeme Double)
    | TypeError
    deriving (Ord)

instance Show DataType where
    show = \case
        Bool            -> "Bool"
        Double          -> "Number"
        String          -> "String"
        Matrix sizeR sizeC -> "Matrix(" ++ show (lexInfo sizeR) ++ "," ++ show (lexInfo sizeC) ++ ")"
        Row size        -> "Row(" ++ show (lexInfo size) ++ ")"
        Col size        -> "Col(" ++ show (lexInfo size) ++ ")"
        TypeError       -> error "DataType: TypeError"

instance Eq DataType where
    a == b = case (a,b) of
        (Bool, Bool)                           -> True
        (Double, Double)                       -> True
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
    Bool -> "Bool"
    Double -> "Double"
    String -> "String"
    Matrix _ _ -> "Matrix"
    Row _ -> "Row"
    Col _ -> "Col"
    TypeError -> "Error"

isScalar :: DataType -> Bool
isScalar = flip elem [Double, Bool]

isMatrix :: DataType -> Bool
isMatrix = \case
    Matrix _ _ -> True
    _ -> False

isRow :: DataType -> Bool
isRow = \case
    Row _ -> True
    _ -> False

isCol :: DataType -> Bool
isCol = \case
    Col _ -> True
    _ -> False

isValid :: DataType -> Bool
isValid = (/= TypeError)

