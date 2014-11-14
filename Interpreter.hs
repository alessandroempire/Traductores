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
import qualified  Data.List as L (and, length, transpose)
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
buildInterpreter w tab program@(Program _ block) = do
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

    StAssign accL expL ->  do
        expValue <- evalExpression expL
        id <- accessDataType accL
        -- Aqui modificamos el valor en la tabla de simbolos...
        return False

    StReturn expL -> do
        return False

    StFunctionCall idL expLs -> do
        return False

    StRead idL -> do
        return False

    StPrint exprL -> do
        return False   

    StIf expL trueBlock falseBlock -> do
        return False

    StFor idL expL block -> do
        return False

    StWhile expL block -> do
        return False

    StBlock dclS block -> do
        return False
       
    _ -> return False

--------------------------------------------------------------------------------
-- Expressions

evalExpression :: Lexeme Expression -> Interpreter TypeValue
evalExpression (Lex exp posn) = case exp of

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
        lValue <- lift $ evalExpression lExp
        rValue <- lift $ evalExpression rExp

        expValue <- lift $ runBinary op (lValue, rValue)

        return expValue

    ExpUnary (Lex op pos) exp -> liftM (fromMaybe DataEmpty) $ runMaybeT $ do
        val <- lift $ evalExpression exp

        expValue <- lift $ runUnary op val

        return expValue

--------------------------------------------------------------------------------
-- Operations

runBinary :: Binary -> (TypeValue, TypeValue) -> Interpreter TypeValue
runBinary op (lValue, rValue) = case op of
    OpSum        -> return (addOp lValue rValue)
    OpDiff       -> return (diffOp lValue rValue)
    OpMul        -> return (mulOp lValue rValue)
    OpLess       -> return (less lValue rValue)
    OpLessEq     -> return (lessEq lValue rValue)
    OpGreat      -> return (great lValue rValue)
    OpGreatEq    -> return (greatEq lValue rValue)
    OpOr         -> return (orOp lValue rValue)
    OpAnd        -> return (andOp lValue rValue)

addOp :: TypeValue -> TypeValue -> TypeValue
addOp (DataNumber n) (DataNumber m) = (DataNumber (n+m))
--add (DataMatrix lmatrix) (DataMatrix rmatrix) = (DataMatrix lmatrix)

diffOp :: TypeValue -> TypeValue -> TypeValue
diffOp (DataNumber n) (DataNumber m) = (DataNumber (n-m))

mulOp :: TypeValue -> TypeValue -> TypeValue
mulOp (DataNumber n) (DataNumber m) = (DataNumber (n*m))

less :: TypeValue -> TypeValue -> TypeValue
less (DataNumber n) (DataNumber m) = (DataBool (n < m))

lessEq :: TypeValue -> TypeValue -> TypeValue
lessEq (DataNumber n) (DataNumber m) = (DataBool (n <= m))

great :: TypeValue -> TypeValue -> TypeValue
great (DataNumber n) (DataNumber m) = (DataBool (n > m))

greatEq :: TypeValue -> TypeValue -> TypeValue
greatEq (DataNumber n) (DataNumber m) = (DataBool (n >= m))

orOp :: TypeValue -> TypeValue -> TypeValue
orOp (DataBool lbool) (DataBool rbool) = (DataBool (lbool || rbool))

andOp :: TypeValue -> TypeValue -> TypeValue
andOp (DataBool lbool) (DataBool rbool) = (DataBool (lbool && rbool))

--------------------------------------------------------------------------------

runUnary :: Unary -> TypeValue -> Interpreter TypeValue
runUnary op value = case op of
    OpNegative   -> return (negOp value) 
    OpNot        -> return (notOp value)
    OpTranspose  -> return (transposeOp value)

negOp :: TypeValue -> TypeValue
negOp (DataNumber n) = (DataNumber (-n))
negOp (DataMatrix matrix) = (DataMatrix (map (map (\ x -> -x)) matrix))

notOp :: TypeValue -> TypeValue
notOp (DataBool bool) = (DataBool (not bool))

transposeOp :: TypeValue -> TypeValue
transposeOp (DataMatrix matrix) = (DataMatrix (L.transpose matrix))

--------------------------------------------------------------------------------

accessDataType :: Lexeme Access -> Interpreter Identifier
accessDataType (Lex acc posn) = case acc of

    VariableAccess idL -> return (lexInfo idL)

    MatrixAccess idL explL exprL -> return (lexInfo idL)

    RCAccess idL expL -> return (lexInfo idL)

