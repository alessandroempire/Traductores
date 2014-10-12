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
    
    -- From Function
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

import          Text.Show.Pretty

data Program = Program FunctionSeq StatementSeq

instance Show Program where
    show (Program fun block) = ppShow fun ++ ppShow block
