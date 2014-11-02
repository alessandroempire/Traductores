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
    void $ typeCheckFunctions fun
    void $ typeCheckStatements block

    syms <- liftM toSeq $ gets table
    checkTable syms

---------------------------------------------------------------------

checkTable :: Seq (Identifier, Symbol) -> TypeChecker ()
checkTable syms = forM_ syms $ \(id, sym) -> case symbolCategory sym of
    CatInfo -> unless (used sym) $ tellWarn (defPosn sym) (VariableDefinedNotUsed id)
    CatFunction -> unless (used sym) $ tellWarn (defPosn sym) (FunctionDefinedNotUsed id)

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

processAccessChecker :: TrinityState s => s -> Lexeme Access -> DataType
processAccessChecker st = evalAccessChecker . buildAccessChecker st

evalAccessChecker :: TypeChecker DataType -> DataType
evalAccessChecker = fst . flip (flip evalRWS initialReader) initialState

buildAccessChecker :: TrinityState s => s -> Lexeme Access -> TypeChecker DataType
buildAccessChecker st accL = do
    modify $ putTable   (getTable   st)
    modify $ putStack   (getStack   st)
    modify $ putScopeId (getScopeId st)
    modify $ putAst     (getAst     st)
    liftM (snd . fromJust) . runMaybeT $ accessDataType accL

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
-- Functions

typeCheckFunctions :: FunctionSeq -> TypeChecker Returned
typeCheckFunctions = liftM or . mapM typeCheckFunction

typeCheckFunction (Lex fun posn) = case fun of

    Function idL _ dtL block -> do
        let id = lexInfo idL
            dt = lexInfo dtL

        enterScope
        enterFunction id dt
        ret <- typeCheckStatements block
        exitFunction
        exitScope

        unless (ret) $ tellSError posn (NoReturn id)
        return False

---------------------------------------------------------------------
-- Declaration

typeCheckDeclarations :: DeclarationSeq -> TypeChecker Returned
typeCheckDeclarations = liftM or . mapM typeCheckDeclaration

typeCheckDeclaration :: Lexeme Declaration -> TypeChecker Returned
typeCheckDeclaration (Lex dcl posn) = case dcl of

    DclInit dtL idL expL -> flip (>>) (return False) . runMaybeT $ do
        let dt = lexInfo dtL
            id = lexInfo idL

        expDt <- lift $ typeCheckExpression expL

        guard (isValid expDt)
        unless (dt == expDt) $ tellSError posn (InvalidAssignType id dt expDt)

    _ -> return False


--------------------------------------------------------------------------------
-- Statements

typeCheckStatements :: StatementSeq -> TypeChecker Returned
typeCheckStatements = liftM or . mapM typeCheckStatement

typeCheckStatement :: Lexeme Statement -> TypeChecker Returned
typeCheckStatement (Lex st posn) = case st of

    StAssign accL expL -> flip (>>) (return False) . runMaybeT $ do
        expDt <- lift $ typeCheckExpression expL
        (accId, accDt) <- accessDataType accL

        guard (isValid accDt)
        guard (isValid expDt)
        unless (accDt == expDt) $ tellSError posn (InvalidAssignType accId accDt expDt)

    StReturn expL -> flip (>>) (return True) . runMaybeT $ do
        expDt <- lift $ typeCheckExpression expL
        (id, retDt, _) <- lift currentFunction
        
        guard (isValid expDt)
        unlessGuard (retDt == expDt) $ tellSError posn (ReturnType retDt expDt id)

    StFunctionCall idL expLs -> flip (>>) (return False) $ checkArguments idL expLs

    StRead idL -> flip (>>) (return False) . runMaybeT $ do
        let id = lexInfo idL
        maySymI <- getsSymbol  id ((lexInfo . dataType) &&& symbolCategory)
        let (dt, cat) = fromJust maySymI

        unlessGuard (isJust maySymI) $ tellSError (lexPosn idL) (NotDefined id)
        unlessGuard (cat == CatInfo) $ tellSError (lexPosn idL) (WrongCategory id CatInfo cat)
        guard (isValid dt)
        unless (isScalar dt) $ tellSError (lexPosn idL) (ReadNonReadable dt id)

    StPrint exprL -> flip (>>) (return False) . runMaybeT $ do
        dt <- lift $ typeCheckExpression exprL

        guard (isValid dt)
        unless (dt == String || isScalar dt) $ tellSError posn (PrintNonPrintable dt)

    StIf expL trueBlock falseBlock -> do
        expDt <- typeCheckExpression expL
        void . runMaybeT $ do
            guard (isValid expDt)
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
            guard (isValid expDt)
            when (expDt /= Bool) $ tellSError posn (ConditionDataType expDt)

        enterScope
        void $ typeCheckStatements block
        exitScope
        return False

    StBlock dclS block -> do
        typeCheckDeclarations dclS
        void $ typeCheckStatements block

        return False
        

    _ -> return False


--------------------------------------------------------------------------------
-- Expressions
typeCheckExpression :: Lexeme Expression -> TypeChecker DataType
typeCheckExpression (Lex exp posn) = case exp of

    LitNumber _ -> return Number

    LitBool _   -> return Bool

    LitString _ -> return String

    VariableId idL -> liftM (fromMaybe TypeError) $ runMaybeT $ do
        let id = lexInfo idL
        maySymI <- getsSymbol  id ((lexInfo . dataType) &&& symbolCategory)
        let (dt, cat) = fromJust maySymI

        markUsed id
        return dt

    ProyM expL indexlL indexrL -> liftM (fromMaybe TypeError) $
                                  runMaybeT $ do
        -- Faltaria chequear el tipo de expL, que es un literal matricial xD
     
        lDt <- lift $ typeCheckExpression indexlL
        rDt <- lift $ typeCheckExpression indexrL

        guard (isValid lDt)
        guard (isValid rDt)
        unless (lDt == Number) $ tellSError posn (ProyIndexDataType lDt)
        unless (rDt == Number) $ tellSError posn (ProyIndexDataType rDt)

        return Number

    ProyRC expL indexL -> liftM (fromMaybe TypeError) $
                                  runMaybeT $ do
        -- Faltaria chequear el tipo de expL, que es un literal matricial xD
     
        dt <- lift $ typeCheckExpression indexL

        guard (isValid dt)
        unless (dt == Number) $ tellSError posn (ProyIndexDataType dt)

        return Number


    ExpBinary (Lex op pos) lExp rExp -> liftM (fromMaybe TypeError) $ 
                                      runMaybeT $ do
        lDt <- lift $ typeCheckExpression lExp
        rDt <- lift $ typeCheckExpression rExp
        let expDt = binaryOperation op (lDt, rDt)

        guard (isValid lDt)
        guard (isValid rDt)
        unlessGuard (isJust expDt) $ tellSError posn (BinaryTypes op (lDt, rDt))

        return (fromJust expDt)

    ExpUnary (Lex op pos) exp -> liftM (fromMaybe TypeError) $ runMaybeT $ do
        dt <- lift $ typeCheckExpression exp
        let expDt = unaryOperation op dt

        guard (isValid dt)
        unlessGuard (isJust expDt) $ tellSError posn (UnaryTypes op dt)

        return (fromJust expDt)

--------------------------------------------------------------------------------

checkArguments :: Lexeme Identifier -> Seq (Lexeme Expression) -> TypeChecker (Maybe DataType)
checkArguments (Lex id posn) args = runMaybeT $ do
    maySymI <- getsSymbol id (\sym -> (symbolCategory sym, lexInfo $ returnType sym, paramTypes sym))
    let (cat, dt, prms) = fromJust maySymI

    unlessGuard (isJust maySymI) $ tellSError posn (FunctionNotDefined id)
    unlessGuard (cat == CatFunction) $ tellSError posn (WrongCategory id CatFunction cat)
    markUsed id
    
    aDts <- lift $ mapM typeCheckExpression args
    let pDts = fmap lexInfo prms
    
    unlessGuard (length args == length pDts) $ tellSError posn (FunctionArguments id pDts aDts)
    guard (all isValid aDts)
    unlessGuard (and $ zipWith (==) pDts aDts) $ tellSError posn (FunctionArguments id pDts aDts)
    
    return dt

--------------------------------------------------------------------------------

accessDataType :: Lexeme Access -> MaybeT TypeChecker (Identifier, DataType)
accessDataType (Lex acc posn) = case acc of

    VariableAccess idL -> do
        let id = lexInfo idL
        maySymI <- getsSymbol id ((lexInfo . dataType) &&& symbolCategory)
        let (dt, cat) = fromJust maySymI

        unlessGuard (isJust maySymI) $ tellSError posn (NotDefined id)
        unlessGuard (cat == CatInfo) $ tellSError posn (WrongCategory id CatInfo cat)

        return (id, dt)

    MatrixAccess idL explL exprL -> do
        let id = lexInfo idL
        maySymI <- getsSymbol id ((lexInfo . dataType) &&& symbolCategory)
        let (dt, cat) = fromJust maySymI

        unlessGuard (isJust maySymI) $ tellSError posn (NotDefined id)
        unlessGuard (cat == CatInfo) $ tellSError posn (WrongCategory id CatInfo cat)
        unlessGuard (isMatrix dt) $ tellSError posn (InvalidAccess id dt)

        explDt <- lift $ typeCheckExpression explL
        exprDt <- lift $ typeCheckExpression exprL
    
        guard (isValid explDt)
        guard (isValid exprDt)
        unless (explDt == Number) $ tellSError posn (IndexAssignType explDt id)
        unless (exprDt == Number) $ tellSError posn (IndexAssignType exprDt id)

        return (id, Number)

    RCAccess idL expL -> do
        let id = lexInfo idL
        maySymI <- getsSymbol id ((lexInfo . dataType) &&& symbolCategory)
        let (dt, cat) = fromJust maySymI

        unlessGuard (isJust maySymI) $ tellSError posn (NotDefined id)
        unlessGuard (cat == CatInfo) $ tellSError posn (WrongCategory id CatInfo cat)
        unlessGuard (isRow dt || isCol dt) $ tellSError posn (InvalidAccess id dt)

        expDt <- lift $ typeCheckExpression expL
    
        guard (isValid expDt)
        unless (expDt == Number) $ tellSError posn (IndexAssignType expDt id)

        return (id, Number)

