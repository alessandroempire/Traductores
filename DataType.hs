{-# LANGUAGE LambdaCase #-}

module DataType
    ( DataType(..)
    , toIdentifier
    ) where

import          Lexeme
import          Identifier

import          Data.Function (on)

data DataType 
    = Bool 
    | Double
    | Matrix (Lexeme Double) (Lexeme Double)
    | Row (Lexeme Double)
    | Col (Lexeme Double)
    | Void
    deriving (Ord)

instance Show DataType where
    show = \case
        Bool            -> "Bool"
        Double          -> "Number"
        Matrix sizeR sizeC -> "Matrix" ++ show (lexInfo sizeR) 
                            ++ show (lexInfo sizeC)
        Row size         -> "Row" ++ show (lexInfo size)
        Col size         -> "Col" ++ show (lexInfo size)
        Void             -> "Void"

instance Eq DataType where
    a == b = case (a,b) of
        (Bool, Bool)                           -> True
        (Double, Double)                       -> True
        (Matrix rowA colA, Matrix rowB colB)   -> (comp rowA rowB) && (comp colA colB)
        (Row sizeA, Row sizeB)                 -> comp sizeA sizeB
        (Col sizeA, Col sizeB)                 -> comp sizeA sizeB
--      (Row sizeR, Matrix sizeM _)            -> comp sizeR sizeM
        _                                      -> False
        where
            comp :: Eq a => Lexeme a -> Lexeme a -> Bool
            comp = (==) `on` lexInfo       

toIdentifier :: DataType -> Identifier
toIdentifier dt = case dt of
    Bool -> "Bool"
    Double -> "Double"
    Matrix _ _ -> "Matrix"
    Row _ -> "Row"
    Col _ -> "Col"
    Void -> "Void"

