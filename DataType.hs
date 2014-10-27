module DataType
    ( DataType(..)
    ) where

import          Lexeme

import          Data.Function (on)

data DataType 
    = Bool 
    | Double
    | Matrix (Lexeme Double) (Lexeme Double)
    | Row (Lexeme Double)
    | Col (Lexeme Double)
    | Void

instance Show DataType where
    show t = case t of
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
        (Matrix rowA colA, Matrix rowB colB)   -> (check rowA rowB) && (check colA colB)
        (Row sizeA, Row sizeB)                 -> check sizeA sizeB
        (Col sizeA, Col sizeB)                 -> check sizeA sizeB
        _                                      -> False
        where
            check :: Eq a => Lexeme a -> Lexeme a -> Bool
            check = (==) `on` lexInfo       

