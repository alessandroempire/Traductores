module Program
    ( Program(..)

    -- Lexeme
    , Lexeme(..)
    , Position(..)
    , defaultPosn

    -- Token
    , Token(..)

    -- Identifier
    , Identifier

    -- TypeId
    , TypeId(..)

    -- Expression
    , Expression(..)
    , Access(..)
    , Binary(..)
    , Unary(..)

    -- Declaration
    , Declaration(..)
    , DeclarationSeq

    -- Statements
    , Statement(..)
    , StatementSeq

    -- Function
    , Function(..)
    , FunctionSeq
    ) where

import          Declaration
import          Expression
import          Function
import          Identifier
import          Lexeme
import          Position
import          Statement
import          TypeId
import          Token 

data Program = Program FunctionSeq StatementSeq

instance Show Program where
    show (Program funS stB) = "Programa correcto..."
