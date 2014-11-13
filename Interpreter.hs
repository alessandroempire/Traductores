{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE DoAndIfThenElse#-}

module Interpreter
    ( InterpreterState
    , Interpreter
    , runInterpreter
    ) where

import            Error
import            Program
import            TrinityMonad
import            SymbolTable

import            Control.Arrow ((&&&))
import            Control.Monad (guard, liftM, unless, void, when, (>=>))
import            Control.Monad.Reader (asks)
import            Control.Monad.RWS (RWS, evalRWS, execRWS, lift)
import            Control.Monad.State (gets, modify)
import            Control.Monad.Trans.Maybe (MaybeT, runMaybeT)
import            Control.Monad.Writer (tell)
import            Data.Foldable (all, and, forM_, or, toList)
import            Data.Functor ((<$>))
import            Data.Maybe (fromJust, fromMaybe, isJust)
import            Data.Sequence (Seq, empty, length, zipWith)
import            Data.Traversable (forM, mapM)
import qualified  Data.List as L (and, length)
import            Prelude hiding (all, and, exp, length, lookup, mapM, null, or, zipWith)

type Interpreter = RWS TrinityReader TrinityWriter InterpreterState

data InterpreterState = InterpreterState
    { table :: SymbolTable
    , stack :: Stack Scope
    , scopeId :: Scope
    , ast :: Program
    , funcStack :: Stack (Identifier, DataType, Scope)
}

instance TrinityState InterpreterState where
    getTable = table
    getStack = stack
    getScopeId = scopeId
    getAst = ast
    putTable tab s = s { table = tab }
    putStack stk s = s { stack = stk }
    putScopeId sc s = s { scopeId = sc }
    putAst as s = s { ast = as }

instance Show InterpreterState where
    show = showTrinityState

evalExpression :: Expression -> TypeValue
evalExpression = \case
    LitNumber vL             -> DataNumber (lexInfo vL)
    LitBool vL               -> DataBool (lexInfo vL)
    _ -> DataEmpty

---------------------------------------------------------------------

initialState :: InterpreterState
initialState = InterpreterState
    { table = emptyTable
    , stack = globalStack
    , scopeId = globalScope
    , ast = Program empty empty
    , funcStack = emptyStack
    }

---------------------------------------------------------------------

buildInterpreter :: TrinityWriter -> SymbolTable -> Program -> Interpreter ()
buildInterpreter w tab program@(Program fun block) = do
    modify $ \s -> s { table = tab, ast = program }
    tell w
    void $ runStatements block

---------------------------------------------------------------------
-- Using the Monad

processInterpreter :: TrinityReader -> TrinityWriter -> SymbolTable -> Program -> (InterpreterState, TrinityWriter)
processInterpreter r w tab = runInterpreter r . buildInterpreter w tab

runInterpreter :: TrinityReader -> Interpreter a -> (InterpreterState, TrinityWriter)
runInterpreter r = flip (flip execRWS r) initialState

--------------------------------------------------------------------------------
-- Monad handling

enterFunction :: Identifier -> DataType -> Interpreter ()
enterFunction idL dt = do
    currentId <- currentScope
    modify $ \s -> s { funcStack = push (idL, dt, currentId) (funcStack s) }

exitFunction :: Interpreter ()
exitFunction = modify $ \s -> s { funcStack = pop $ funcStack s }

currentFunction :: Interpreter (Identifier, DataType, Scope)
currentFunction = gets (top . funcStack)

--------------------------------------------------------------------------------
-- Statements

runStatements :: StatementSeq -> Interpreter Returned
runStatements = liftM or . mapM runStatement

runStatement :: Lexeme Statement -> Interpreter Returned
runStatement (Lex st posn) = case st of

    _ -> return False


--------------------------------------------------------------------------------
-- Expressions

runExpression :: Lexeme Expression -> Interpreter TypeValue
runExpression (Lex exp posn) = case exp of

    LitNumber vL -> return (DataNumber $ (lexInfo vL))

    LitBool vL   -> return (DataBool $ (lexInfo vL))

    LitString _ -> return DataEmpty

    VariableId idL -> liftM (fromMaybe DataEmpty) $ runMaybeT $ do
        let id = lexInfo idL
        maySymI <- getsSymbol  id ((lexInfo . dataType) &&& value)
        let (dt, val) = fromJust maySymI

        return val
    
    LitMatrix exps -> liftM (fromMaybe DataEmpty) $ runMaybeT $ do
        return DataEmpty

    FunctionCall idL expLs -> liftM (fromMaybe DataEmpty) $ 
                                  runMaybeT $ do 
        return DataEmpty

    ProyM expL indexlL indexrL -> liftM (fromMaybe DataEmpty) $
                                  runMaybeT $ do
        
        return DataEmpty

    ProyRC expL indexL -> liftM (fromMaybe DataEmpty) $
                                  runMaybeT $ do

        return DataEmpty

    ExpBinary (Lex op pos) lExp rExp -> liftM (fromMaybe DataEmpty) $ 
                                      runMaybeT $ do
        lValue <- lift $ runExpression lExp
        rValue <- lift $ runExpression rExp

        expValue <- lift $ runBinary op (lValue, rValue)

        return expValue

    ExpUnary (Lex op pos) exp -> liftM (fromMaybe DataEmpty) $ runMaybeT $ do
        val <- lift $ runExpression exp

        expValue <- lift $ runUnary op val

        return expValue

--------------------------------------------------------------------------------
-- Operations

runBinary :: Binary -> (TypeValue, TypeValue) -> Interpreter TypeValue
runBinary = undefined

runUnary :: Unary -> TypeValue -> Interpreter TypeValue
runUnary = undefined

