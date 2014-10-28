{-# LANGUAGE LambdaCase #-}

module Error
    ( Error(..)
    , LexerError(..)
    , ParseError(..)
    , StaticError(..)
    ) where

import          Program
import          SymbolTable

import           Data.Foldable                 (toList)
import           Data.Function                 (on)
import           Data.List                     (intercalate)
import           Data.Sequence                 (Seq)

data Error
    = LError Position LexerError
    | PError Position ParseError
    | SError Position StaticError

instance Show Error where
    show = \case
        LError p e -> "Lexer Error: "   ++ show e ++ "\n\t" ++ show p ++ "\n"
        PError p e -> "Parse Error: " ++ show e ++ "\n\t" ++ show p ++ "\n"
        SError p e -> "Static Error: "  ++ show e ++ "\n\t" ++ show p ++ "\n"

instance Eq Error where
    (==) = (==) `on` errorPos

instance Ord Error where
    compare = compare `on` errorPos

data LexerError = LexerError String

instance Show LexerError where
    show = \case
        LexerError msg -> msg

data ParseError
    = ParseError String
    | UnexpectedToken String

instance Show ParseError where
    show = \case
        ParseError msg      -> msg
        UnexpectedToken tok -> "Token inesperado '" ++ show tok ++ "'"

data StaticError
    = StaticError String

instance Show StaticError where
    show = \case
        StaticError msg -> msg

errorPos :: Error -> Position
errorPos error = case error of
    LError p _ -> p
    PError p _ -> p
    SError p _ -> p

