module Lexeme
    ( Lexeme(..)
    , Position(..)
    , defaultPosn
    , fillLex
    ) where

import          Position

data Lexeme a = Lex { lexInfo :: a
                    , lexPosn :: Position 
                    }
                 
instance Show a => Show (Lexeme a) where
    show (Lex a pos) = show a ++ " : " ++ show pos

instance Functor Lexeme where
    fmap f (Lex a p) = Lex (f a) p

fillLex :: a -> Lexeme a
fillLex lex = Lex lex defaultPosn

