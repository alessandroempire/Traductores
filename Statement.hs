{-# LANGUAGE LambdaCase #-}

module Statement
    ( Statement(..)
    , StatementSeq
    ) where

import          Declaration
import          Expression
import          Identifier
import          Lexeme

import          Data.Sequence (Seq)
import          Data.Foldable (concatMap)
import          Prelude       hiding(concatMap)

type StatementSeq = Seq (Lexeme Statement)

data Statement
    = StNoop
    | StAssign (Lexeme Access) (Lexeme Expression)
    | StExpression (Lexeme Expression)
    | StReturn (Lexeme Expression)
    | StRead (Lexeme Identifier)
    | StPrint (Lexeme Expression)
    | StPrintList (Seq (Lexeme Expression))
    | StIf (Lexeme Expression) StatementSeq StatementSeq
    | StFor (Lexeme Identifier) (Lexeme Expression) StatementSeq
    | StWhile (Lexeme Expression) StatementSeq
    | StBlock DeclarationSeq StatementSeq

instance Show Statement where
    show = \case
        StAssign accL expL        -> "set" ++ show (lexInfo accL) ++ " = " ++ show (lexInfo expL)
        StExpression expL         -> show (lexInfo expL)
        StReturn expL             -> "return " ++ show (lexInfo expL)
        StRead accL               -> "read " ++ show (lexInfo accL)
        StPrint expL              -> "print " ++ show (lexInfo expL)
        StIf expL _ _             -> "if " ++ show (lexInfo expL) ++ " then .. end"
        StFor idnL expL _         -> "for " ++ lexInfo idnL ++ " in " ++ show (lexInfo expL) ++ " do .. end"
        StWhile expL _            -> "while " ++ show (lexInfo expL) ++ "do .. end"
        StBlock dclLs stLs        -> "use" ++ concatMap (show . lexInfo) dclLs ++ 
                                      "in" ++  concatMap ( show . lexInfo) stLs ++ "end"
                                     
