module Declaration
    ( Declaration(..)
    , DeclarationSeq
    ) where

import          Lexeme
import          Identifier
import          Expression

import          Data.Sequence (Seq)

type DeclarationSeq = Seq (Lexeme Declaration)    

data Declaration 
    = Dcl (Lexeme TypeId) (Lexeme Identifier)
    | DclInit (Lexeme TypeId) (Lexeme Identifier) (Lexeme Expression)

instance Show Declaration where
    show dcl = case dcl of
         Dcl tL idL          -> "Declaracción: tipo " ++ show (lexInfo tL)
                                 ++ " identificador " ++ lexInfo idL
         DclInit tL idL expL -> "Declaracción: tipo " ++ show (lexInfo tL) 
                                 ++ " identificador " ++ lexInfo idL 
                                 ++ " inicialización " ++ show (lexInfo expL)
