{-# LANGUAGE LambdaCase #-}

module Lexeme
    ( Lexeme(..)
    , Position(..)
    , defaultPosn
    , fillLex
    , pure
    ) where

import          Position

import          Control.Applicative        (Applicative, pure, (<*>))

data Lexeme a = Lex { lexInfo :: a
                    , lexPosn :: Position 
                    } deriving (Eq, Ord)
                 
instance Show a => Show (Lexeme a) where
    show (Lex a pos) = show a ++ " : " ++ show pos

instance Functor Lexeme where
    fmap f (Lex a p) = Lex (f a) p

instance Applicative Lexeme where
    pure = fillLex
    (Lex f p) <*> (Lex a _) = Lex (f a) p

---------------------------------------------------------------------

fillLex :: a -> Lexeme a
fillLex lex = Lex lex defaultPosn

--isLexeme :: a -> Bool
isLexeme (Lex a b) = True
isLexeme _ = False
