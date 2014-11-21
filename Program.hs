{-# LANGUAGE LambdaCase #-}

module Program
    ( Program(..)
    , module Lexeme
    , module Identifier
    , module DataType
    , module Expression
    , module Declaration
    , module Statement
    , module Function
    ) where

import          Declaration
import          Expression
import          Function
import          Identifier
import          Lexeme
import          Statement
import          DataType

import          Control.Monad.State  (StateT, runStateT, modify, get)
import          Control.Monad.Writer (Writer, execWriter, tell)
import          Data.Char            (toLower)
import          Data.Sequence        (Seq, singleton)
import          Data.Foldable        (concat, mapM_, forM_)
import          Prelude              hiding (concat, mapM_, exp)

data Program = Program FunctionSeq StatementSeq

instance Show Program where
    show = processPrinter

---------------------------------------------------------------------

type Printer a = StateT Tabs (Writer (Seq String)) a

---------------------------------------------------------------------
-- State

type Tabs = Int

---------------------------------------------------------------------
-- Initial
   
initialState :: Tabs
initialState =  0

---------------------------------------------------------------------
-- Adding tabs

tabs :: Int -> String
tabs n = replicate n '\t'

---------------------------------------------------------------------
-- Using the Monad

processPrinter :: Program -> String
processPrinter = runPrinter . buildPrinter

runPrinter :: Printer () -> String
runPrinter = concat . execWriter . flip runStateT initialState

---------------------------------------------------------------------
-- Monad handling

printString :: String -> Printer ()
printString str = get >>= \t -> tell . singleton $ tabs t ++ str ++ "\n"

---------------------------------------------------------------------
-- Tabs

raiseTabs :: Printer ()
raiseTabs = modify succ

lowerTabs :: Printer ()
lowerTabs = modify pred

---------------------------------------------------------------------

buildPrinter :: Program -> Printer ()
buildPrinter (Program fun block) = printProgram "Program" fun block

printProgram :: String -> Seq (Lexeme Function) -> Seq (Lexeme Statement)  -> Printer ()
printProgram str fun block = do
    printString str
    raiseTabs
    mapM_ printFunction fun
    mapM_ printStatement block
    lowerTabs

printStatement :: Lexeme Statement -> Printer ()
printStatement (Lex st posn) = case st of
--    StNoop ->

    StAssign acc exp -> do
        printString $ "Asignacion "
        raiseTabs
        printAccess acc
        printExpression exp
        lowerTabs

    StReturn exp -> do
        printString $ "Return "
        raiseTabs
        printExpression exp
        lowerTabs

    StRead id -> do
        printString $ "Read "
        raiseTabs
        printString $ "Identificador " ++ show id
        lowerTabs

    StPrint exp -> do
        printString $ "Print "
        raiseTabs
        printExpression exp
        lowerTabs

    StPrintList exp -> do
        printString $ "Print (Seq) "
        raiseTabs
        mapM_ printExpression exp
        lowerTabs

    StIf exp st1 st2 -> do
        printString $ "Condicional If "
        raiseTabs
        printExpression exp
        mapM_ printStatement st1
        mapM_ printStatement st2
        lowerTabs

    StFor id exp st -> do
        printString $ "Ciclo determinado "
        raiseTabs
        printString $ "identificador " ++ show id
        printExpression exp
        mapM_ printStatement st
        lowerTabs

    StWhile exp st -> do
        printString $ "Ciclo indeterminado "
        raiseTabs
        printExpression exp
        mapM_ printStatement st
        lowerTabs

    StBlock st1 st2 -> do
        printString $ "Bloque "
        raiseTabs
        mapM_ printDeclaration st1
        mapM_ printStatement st2
        lowerTabs

printFunction :: Lexeme Function -> Printer ()
printFunction (Lex st posn) = case st of 

    Function iden dec typ st -> do
        printString $ "Definicion de Funcion " 
        raiseTabs
        printString $ "Identificador: " ++ show iden
        mapM_ printDeclaration dec
        printString $ "Tipo " ++ show typ
        mapM_ printStatement st
        lowerTabs

printDeclaration :: Lexeme Declaration -> Printer ()
printDeclaration (Lex st posn) = case st of 
    Dcl ty id -> do
        printString $ "Declaracion "
        raiseTabs
        printDataType ty
        printString $ "Identificador " ++ show id
        lowerTabs

    DclInit ty id exp -> do
        printString $ "Declaracion "
        raiseTabs
        printDataType ty
        printString $ "Identificador " ++ show id
        printExpressionTag "valor inicial " exp
        lowerTabs

    DclParam ty id -> do
        printString $ "Declaracion de Parametro "
        raiseTabs
        printDataType ty
        printString $ "Identificador " ++ show id
        lowerTabs
 
printExpression :: Lexeme Expression -> Printer ()
printExpression (Lex st posn )= case st of

    LitNumber   i -> printString $ "Literal Number " ++ show (lexInfo i)
    LitBool     c -> printString $ "Literal Char " ++ show (lexInfo c)
    LitString   s -> printString $ "Literal String " ++ show (lexInfo s)
    VariableId  d -> printString $ "Id Variable " ++ show (lexInfo d)
    
    LitMatrix exp -> do
        printString $ "Literal Matricial "
        raiseTabs
        mapM_ (mapM_ printExpression) exp
        lowerTabs

    FunctionCall id exp -> do
        printString $ "LLamada a Funcion "
        raiseTabs
        printString $ "Identificador " ++ show id
        mapM_ printExpression exp
        lowerTabs

    ProyM exp indexL indexR -> do
        printString $ "Proyeccion de componentes "
        raiseTabs
        printExpression exp
        printExpression indexL
        printExpression indexR
        lowerTabs

    ProyV exp index -> do
        printString $ "Proyeccion de componentes "
        raiseTabs
        printExpression exp
        printExpression index
        lowerTabs

    ExpBinary op e1 e2 -> do
        printString $ "Operacion Binaria "
        raiseTabs
        printString $ "Operador " ++ show (lexInfo op)
        printExpressionTag "Operador izquierdo " e1
        printExpressionTag "Operador derecho " e2
        lowerTabs

    ExpUnary op e1 -> do
        printString $ "Operacion Unaria"
        raiseTabs
        printString $ "Operador " ++ show (lexInfo op)
        printExpressionTag "Operador" e1
        lowerTabs
       
printExpressionTag :: String -> Lexeme Expression -> Printer ()
printExpressionTag tag exp = do
    printString tag
    raiseTabs
    printExpression exp
    lowerTabs 
   
printAccess :: Lexeme Access -> Printer ()
printAccess (Lex st posn )= case st of
    VariableAccess id -> printString $ "Variable asignada " ++ show (lexInfo id)
    
    MatrixAccess id sizeR sizeC -> do
        printString $ "Variable asignada (matriz) "
        raiseTabs
        printString $ "Identificador " ++ show id
        printExpression sizeR
        printExpression sizeC
        lowerTabs

    VectorAccess id size -> do
        printString $ "Variable asignada (row-col) "
        raiseTabs
        printString $ "Identificador " ++ show id
        printExpression size
        lowerTabs

printDataType :: Lexeme DataType -> Printer ()
printDataType (Lex st posn) = case st of
    Bool   -> printString $ "Tipo Bool "
    Number -> printString $ "Tipo Number "

    Matrix sizeR sizeC -> do
        printString $ "Tipo Matrix "
        raiseTabs
        printString $ "Tipo Double " ++ show sizeR
        printString $ "Tipo Double " ++ show sizeC
        lowerTabs

    Row exp1 -> do
        printString $ "Tipo Row "
        raiseTabs
        printString $ "Tipo Double " ++ show exp1
        lowerTabs

    Col exp1 -> do
        printString $ "Tipo Col "
        raiseTabs
        printString $ "Tipo Double " ++ show exp1
        lowerTabs
