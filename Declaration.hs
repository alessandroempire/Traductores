{-# LANGUAGE LambdaCase #-}

module Declaration
    ( Declaration(..)
    , DeclarationSeq
    , toDataType
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
    show = \case
         Dcl tL idL          -> "Declaraccion: tipo " ++ show (lexInfo tL)
                                 ++ " identificador " ++ lexInfo idL
         DclInit tL idL expL -> "Declaraccion: tipo " ++ show (lexInfo tL) 
                                 ++ " identificador " ++ lexInfo idL 
                                 ++ " inicializacion " ++ show (lexInfo expL)
         DclParam tL idL     -> "Parametro: tipo " ++ show (lexInfo tL)
                                 ++ " identificador " ++ lexInfo idL

toDataType :: Declaration -> Lexeme DataType
toDataType dcl = case dcl of
    Dcl tL idL -> tL
    DclInit tL idL expL -> tL
    DclParam tL idL -> tL  
