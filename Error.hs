{-# LANGUAGE LambdaCase #-}

module Error
    ( Error(..)
    , LexerError(..)
    , ParseError(..)
    , StaticError(..)
    , Warning(..)
    , isError
    ) where

import           Program
import           SymbolTable

import           Data.Foldable                 (toList)
import           Data.Function                 (on)
import           Data.List                     (intercalate)

data Error
    = LError Position LexerError
    | PError Position ParseError
    | SError Position StaticError
    | Warn Position Warning

instance Show Error where
    show = \case
        LError p e -> "Lexical Error: " ++ show p 
                       ++ "\n\t" ++ show e ++ "\n" 
        PError p e -> "Parse Error: " ++ show p 
                       ++ "\n\t" ++ show e ++ "\n"
        SError p e -> "Static Error: "  ++ show p 
                       ++ "\n\t" ++ show e ++ "\n"
        Warn p w -> "Warning: " ++ show p 
                       ++ "\n\t" ++ show w ++ "\n"

instance Eq Error where
    (==) = (==) `on` errorPos

instance Ord Error where
    compare = compare `on` errorPos

---------------------------------------------------------------------

data LexerError  
   = LexerError     String
   | UnexpectedChar Char 
   | StringError    String

instance Show LexerError where
    show = \case
        LexerError msg   -> msg
        UnexpectedChar c -> "Caracter inesperado '" ++ [c] ++ "'"
        StringError str  -> "Falta de una comilla en el String " 
                             ++ show str

---------------------------------------------------------------------

data ParseError
    = ParseError String
    | UnexpectedToken String

instance Show ParseError where
    show = \case
        ParseError msg      -> msg
        UnexpectedToken tok -> "Token inesperado '" ++ show tok ++ "'"

---------------------------------------------------------------------

data StaticError 
    = StaticError String
    | AlreadyDeclared Identifier Position

instance Show StaticError where
    show = \case
        StaticError msg -> msg
        AlreadyDeclared var p  -> "Identificador '" ++ var ++ "' fue declarado previamente en la " ++ show p

---------------------------------------------------------------------

data Warning
    = Warning String
    | CaseOfBool
    | VariableDefinedNotUsed Identifier
    | FunctionDefinedNotUsed Identifier

instance Show Warning where
    show = \case
        Warning msg -> msg
        CaseOfBool -> "case expression is of type 'Bool', consider using an 'if-then-else' statement"
        VariableDefinedNotUsed         idn -> "identifier '" ++ idn ++ "' is defined but never used"
        FunctionDefinedNotUsed idn -> "function '"   ++ idn ++ "' is defined but never used"

---------------------------------------------------------------------

isError :: Error -> Bool
isError = \case
    Warn _ _ -> False
    _        -> True

errorPos :: Error -> Position
errorPos error = case error of
    LError p _ -> p
    PError p _ -> p
    SError p _ -> p
    Warn p _ -> p

