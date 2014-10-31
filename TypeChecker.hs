module TypeChecker
    ( TypeState
    , TypeChecker
    , processTypeChecker
    , processExpressionChecker
    , processAccessChecker
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
import            Data.Foldable (all, and, forM_, or)
import            Data.Functor ((<$>))
import            Data.Maybe (fromJust, fromMaybe, isJust)
import            Data.Sequence (Seq, empty, length, zipWith)
import            Data.Traversable (forM, mapM)
import            Prelude hiding (all, and, exp, length, lookup, mapM, null, or, zipWith)

type TypeChecker = RWS TrinityReader TrinityWriter TypeState

data TypeState = TypeState
    { table :: SymbolTable
    , stack :: Stack Scope
    , scopeId :: Scope
    , ast :: Program
    , funcStack :: Stack (Identifier, DataType, Scope)
}

instance TrinityState TypeState where
    getTable = table
    getStack = stack
    getScopeId = scopeId
    getAst = ast
    putTable tab s = s { table = tab }
    putStack stk s = s { stack = stk }
    putScopeId sc s = s { scopeId = sc }
    putAst as s = s { ast = as }

instance Show TypeState where
    show = showTrinityState

---------------------------------------------------------------------

initialState :: TypeState
initialState = TypeState
    { table = emptyTable
    , stack = globalStack
    , scopeId = globalScope
    , ast = Program empty empty
    , funcStack = emptyStack
    }

---------------------------------------------------------------------

buildTypeChecker :: TrinityWriter -> SymbolTable -> Program -> TypeChecker ()
buildTypeChecker w tab program@(Program fun block) = do
    modify $ \s -> s { table = tab, ast = program }
    tell w
--    typeCheckFunctions fun
    void $ typeCheckStatements block

    syms <- liftM toSeq $ gets table
    checkTable syms

---------------------------------------------------------------------

checkTable :: Seq (Identifier, Symbol) -> TypeChecker ()
checkTable syms = forM_ syms $ \(idn, sym) -> case symbolCategory sym of
    CatInfo -> unless (used sym) $ tellWarn (defPosn sym) (VariableDefinedNotUsed idn)
    CatFunction -> unless (used sym) $ tellWarn (defPosn sym) (FunctionDefinedNotUsed idn)

---------------------------------------------------------------------
-- Using the Monad

processTypeChecker :: TrinityReader -> TrinityWriter -> SymbolTable -> Program -> (TypeState, TrinityWriter)
processTypeChecker r w tab = runTypeChecker r . buildTypeChecker w tab

runTypeChecker :: TrinityReader -> TypeChecker a -> (TypeState, TrinityWriter)
runTypeChecker r = flip (flip execRWS r) initialState

---------------------------------------------------------------------
-- Expression

processExpressionChecker :: TrinityState s => s -> Lexeme Expression -> DataType
processExpressionChecker st = evalExpressionChecker . buildExpressionChecker st

evalExpressionChecker :: TypeChecker DataType -> DataType
evalExpressionChecker = fst . flip (flip evalRWS initialReader) initialState

buildExpressionChecker :: TrinityState s => s -> Lexeme Expression -> TypeChecker DataType
buildExpressionChecker st expL = do
    modify $ putTable (getTable st)
    modify $ putStack (getStack st)
    modify $ putScopeId (getScopeId st)
    modify $ putAst (getAst st)
    typeCheckExpression expL

---------------------------------------------------------------------
-- Access

-- Falta agregar...

--------------------------------------------------------------------------------
-- Monad handling

enterFunction :: Identifier -> DataType -> TypeChecker ()
enterFunction idL dt = do
    currentId <- currentScope
    modify $ \s -> s { funcStack = push (idL, dt, currentId) (funcStack s) }

exitFunction :: TypeChecker ()
exitFunction = modify $ \s -> s { funcStack = pop $ funcStack s }

currentFunction :: TypeChecker (Identifier, DataType, Scope)
currentFunction = gets (top . funcStack)

--------------------------------------------------------------------------------
-- Statements

typeCheckStatements :: StatementSeq -> TypeChecker Returned
typeCheckStatements = liftM or . mapM typeCheckStatement

typeCheckStatement :: Lexeme Statement -> TypeChecker Returned
typeCheckStatement (Lex st posn) = case st of

    StAssign accL expL -> flip (>>) (return False) . runMaybeT $ do
        expDt <- lift $ typeCheckExpression expL
-- accessDataType: HAY QUE EDITARLA...
        (accId, accDt) <- accessDataType accL
        unless (accDt == expDt) $ tellSError posn (InvalidAssignType accId accDt expDt)

    StReturn expL -> flip (>>) (return True) . runMaybeT $ do
        expDt <- lift $ typeCheckExpression expL
        (id, retDt, _) <- lift currentFunction
        unlessGuard (retDt == expDt) $ tellSError posn (ReturnType retDt expDt id)

    StFunctionCall idL expLs -> flip (>>) (return False) $ checkArguments idL expLs False

-- Esto hay que moverlo a una nueva funcion: typeCheckFunctions. Similar a lo que hice en Definition.hs

--StFunctionDef (Lex idn _) _ block -> do
--dt <- liftM (lexInfo . fromJust) $ getsSymbol idn returnType
--enterScope
--enterFunction idn dt
--ret <- typeCheckStatements block
--exitFunction
--exitScope
-- When is a function and it wasn't properly returned
--unless (isVoid dt || ret) $ tellSError posn (NoReturn idn)
--return False

    StRead idL -> flip (>>) (return False) . runMaybeT $ do
        let id = lexInfo idL
        maySymI <- getsSymbol  id ((lexInfo . dataType) &&& symbolCategory)
        let (dt, cat) = fromJust maySymI
        unlessGuard (isJust maySymI) $ tellSError (lexPosn idL) (NotDefined id)
        unlessGuard (cat == CatInfo) $ tellSError (lexPosn idL) (WrongCategory id CatInfo cat)
        unless (isScalar dt) $ tellSError (lexPosn idL) (ReadNonReadable dt id)

    StPrint exprL -> flip (>>) (return False) . runMaybeT $ do
        dt <- lift $ typeCheckExpression exprL
        unless (dt ==String || isScalar dt) $ tellSError posn (PrintNonPrintable dt)

    StIf expL trueBlock falseBlock -> do
        expDt <- typeCheckExpression expL
        void . runMaybeT $ do
        when (expDt /= Bool) $ tellSError posn (ConditionDataType expDt)
        enterScope
        trueRet <- typeCheckStatements trueBlock
        exitScope
        enterScope
        falseRet <- typeCheckStatements falseBlock
        exitScope
        return $ trueRet && falseRet

    StFor _ expL block -> do
        expDt <- typeCheckExpression expL
        void . runMaybeT $ do
        unless (isMatrix expDt) $ tellSError posn (ForInDataType expDt)
        enterScope
        void $ typeCheckStatements block
        exitScope
        return False

    StWhile expL block -> do
        expDt <- typeCheckExpression expL
        void . runMaybeT $ do
        when (expDt /= Bool) $ tellSError posn (ConditionDataType expDt)
        enterScope
--Ojo, podria necesitarse el valor de retorno...
        void $ typeCheckStatements block
        exitScope
        return False

    _ -> return False

-- ESTO ES LO QUE HAY QUE EDITAR...
typeCheckExpression :: Lexeme Expression -> TypeChecker DataType
typeCheckExpression = undefined

--------------------------------------------------------------------------------
checkArguments :: Lexeme Identifier -> Seq (Lexeme Expression) -> Bool -> TypeChecker (Maybe DataType)
checkArguments = undefined



accessDataType :: Lexeme Access -> MaybeT TypeChecker (Identifier, DataType)
accessDataType (Lex acc posn) = case acc of

    VariableAccess idL -> do
        let id = lexInfo idL
        maySymI <- getsSymbol  id ((lexInfo . dataType) &&& symbolCategory)
        let (dt, cat) = fromJust maySymI
        unlessGuard (isJust maySymI) $ tellSError (lexPosn deepIdnL) (NotDefined deepIdn)
        unlessGuard (cat == CatInfo) $ tellSError (lexPosn accL) (WrongCategory deepIdn CatInfo cat)
        return (id, dt)

    -- Nota: Ellos usan esta funcion para calcular tipos de arreglos o structs (internos) ...
    -- Para nosotros, solo hay 3 casos: Variables id (ellos usan Variables access), MatrixAccess y RCAccess
    -- Es mas sencillo en nuestro caso, porque en cuanto a variables no debemos calcular accesos internos
    -- solo buscar el id en la tabla y devolver su tipo.

----------------------------------------
constructDataType :: Lexeme Identifier -> AccessZipper -> DataType -> MaybeT TypeChecker DataType
constructDataType = undefined

