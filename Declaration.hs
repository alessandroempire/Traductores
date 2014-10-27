module Declaration
    ( Declaration(..)
    , DeclarationSeq
    ) where

import          Expression
import          Identifier
import          Lexeme
import          DataType

import          Data.Sequence (Seq)

type DeclarationSeq = Seq (Lexeme Declaration)    

data Declaration 
    = Dcl (Lexeme DataType) (Lexeme Identifier)
    | DclInit (Lexeme DataType) (Lexeme Identifier) (Lexeme Expression)
    | DclParam (Lexeme DataType) (Lexeme Identifier)

instance Show Declaration where
    show dcl = case dcl of
         Dcl tL idL          -> "Declaracción: tipo " ++ show (lexInfo tL)
                                 ++ " identificador " ++ lexInfo idL
         DclInit tL idL expL -> "Declaracción: tipo " ++ show (lexInfo tL) 
                                 ++ " identificador " ++ lexInfo idL 
                                 ++ " inicialización " ++ show (lexInfo expL)

