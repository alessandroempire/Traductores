module Function
    ( Function(..)
    , FunctionSeq
    ) where


import          Lexeme
import          Identifier
import          Expression
import          Declaration
import          Statements

import          Data.Sequence (Seq)

type FunctionSeq = Seq (Lexeme Function)

data Function = Function (Lexeme Identifier) DeclarationSeq (Lexeme TypeId) StatementSeq

instance Show Function where
    show (Function idnL _ _ _) = "function " ++ lexInfo idnL 
