module Printer 
    (
    ) where

import          Control.Monad.State  (StateT, runStateT, modify, get)
import          Control.Monad.Writer (Writer, execWriter, tell)
import          Data.Sequence        (Seq, singleton)
import          Parser
import          Lexer


type Printer a = StateT Tabs (Writer (Seq String)) a

--------------------------------------------------------------------------------
-- State

type Tabs = Int

----------------------------------------
-- Initial
   
initialState :: Tabs
initialState =  0

----------------------------------------
-- Adding tabs

tabs :: Int -> String
tabs n = replicate n '\t'

--------------------------------------------------------------------------------
-- Using the Monad

--processPrinter :: Program -> String
processPrinter = runPrinter . buildPrinter

--runPrinter :: Printer () -> String
runPrinter = concat . execWriter . flip runStateT initialState

--------------------------------------------------------------------------------
-- Monad handling

--printString :: String -> Printer ()
printString str = get >>= \t -> tell . singleton $ tabs t ++ str ++ "\n"

----------------------------------------
-- Tabs

raiseTabs :: Printer ()
raiseTabs = modify succ

lowerTabs :: Printer ()
lowerTabs = modify pred

-------------------------------------------------------------------------

instance Show Program where
    show = processPrinter

--buildPrinter :: Program -> Printer ()
buildPrinter (Program fun block) = printStatements "PROGRAM" fun block

--printStatements :: String -> StBlock -> Printer ()
printStatements str fun block = do
    printString str

    raiseTabs
    mapM_ printStatement fun
    mapM_ printStatement block
    lowerTabs

--printStatement :: Lexeme Statement -> Printer ()
printStatement (Lex st posn) = undefined

