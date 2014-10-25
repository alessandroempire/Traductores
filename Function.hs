module Function
    ( Function(..)
    , FunctionSeq
    ) where

import          Declaration
import          Expression
import          Identifier
import          Lexeme
import          Statement
import          DataType

import          Data.Sequence (Seq)

type FunctionSeq = Seq (Lexeme Function)

data Function = Function (Lexeme Identifier) DeclarationSeq (Lexeme DataType) StatementSeq

instance Show Function where
    show (Function idnL _ _ _) = "function " ++ lexInfo idnL 

