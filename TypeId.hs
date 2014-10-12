module TypeId
    ( TypeId(..)
    ) where

import          Expression
import          Lexeme

data TypeId 
    = Bool 
    | Double
    | Matrix (Lexeme Expression) (Lexeme Expression)
    | Row (Lexeme Expression)
    | Col (Lexeme Expression) 

instance Show TypeId where
    show t = case t of
        Bool            -> "Bool"
        Double          -> "Number"
        Matrix exp exp2 -> "Matrix" ++ show (lexInfo exp) 
                            ++ show (lexInfo exp2)
        Row exp         -> "Row" ++ show (lexInfo exp)
        Col exp         -> "Col" ++ show (lexInfo exp)
