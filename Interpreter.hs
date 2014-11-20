{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE DoAndIfThenElse#-}

module Interpreter
    ( InterpreterState
    , Interpreter
    , processInterpreter
    ) where

import            Error
import            Program
import            TrinityMonad
import            SymbolTable
import            Matriz
import            Operator

import qualified  Data.Map as M
import            Control.Arrow ((&&&))
import            Control.Monad (forever, guard, liftM, unless, void, when, (>=>))
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
import            Prelude hiding (all, and, exp, length, lookup, mapM, 
                                  null, or, zipWith, mod, div)

type Interpreter = RWS TrinityReader TrinityWriter InterpreterState

data InterpreterState = InterpreterState
    { marcoPila :: Stack (M.Map Identifier TypeValue)
    }
    
{-
    { table :: SymbolTable
    , stack :: Stack Scope
    , scopeId :: Scope
    , ast :: Program
    , funcStack :: Stack (Identifier, DataType, Scope)
}
-}

--instance TrinityState InterpreterState where
--    getAst = ast
    --getMarcoPila = marcoPila

{-
    getTable = table
    getStack = stack
    getScopeId = scopeId
    getAst = ast
    putTable tab s = s { table = tab }
    putStack stk s = s { stack = stk }
    putScopeId sc s = s { scopeId = sc }
    putAst as s = s { ast = as }
-}

instance Show InterpreterState where
    show (InterpreterState a) = show a

---------------------------------------------------------------------

initialState :: InterpreterState
initialState = InterpreterState 
    { marcoPila = push (M.empty) emptyStack
    }
{-
    { table = emptyTable
    , stack = globalStack
    , scopeId = globalScope
    , ast = Program empty empty
    , funcStack = emptyStack
    }
-}
---------------------------------------------------------------------

buildInterpreter :: TrinityWriter -> Program -> Interpreter ()
buildInterpreter w program@(Program fun block) = do
--    modify $ \s -> s { ast = program }
    tell w
    void $ runStatements block

---------------------------------------------------------------------
-- Using the Monad

processInterpreter :: TrinityReader -> TrinityWriter 
                      -> Program -> (InterpreterState, TrinityWriter)
processInterpreter r w = runInterpreter r . buildInterpreter w

runInterpreter :: TrinityReader -> Interpreter a -> (InterpreterState, TrinityWriter)
runInterpreter r = flip (flip execRWS r) initialState

--------------------------------------------------------------------------------
-- Monad handling

enterMarco :: (M.Map Identifier TypeValue) -> Interpreter ()
enterMarco map = do
    modify $ \s -> s { marcoPila = push (map) (marcoPila s)}
    --currentId <- currentScope
    --modify $ \s -> s { funcStack = push (idL, dt, currentId) (funcStack s) }

exitMarco :: Interpreter ()
exitMarco = modify $ \s -> s { marcoPila = pop $ marcoPila s }
--modify $ \s -> s { funcStack = pop $ funcStack s }

currentFunction :: Interpreter (M.Map Identifier TypeValue)
currentFunction = gets (top . marcoPila)
--gets (top . funcStack)

modifyMarco :: Identifier -> TypeValue -> Interpreter ()
modifyMarco id tv = do mapAct <- currentFunction
                       exitMarco
                       let newMap = M.insert id tv mapAct
                       enterMarco (newMap)

---------------------------------------------------------------------
-- Declarations

runDeclarations :: DeclarationSeq -> Interpreter Returned
runDeclarations = liftM or . mapM runDeclaration

runDeclaration :: Lexeme Declaration -> Interpreter Returned
runDeclaration (Lex dcl posn) = case dcl of

    Dcl dtL idL -> do
        let id       = lexInfo idL
            defaultV = defaultValue (lexInfo dtL)

        modifyMarco id defaultV
        return False

    DclInit dtL idL expL -> do
        let id = lexInfo idL
        expValue <- evalExpression expL

        modifyMarco id expValue

        return False

    _ -> return False

--------------------------------------------------------------------------------
-- Statements

runStatements :: StatementSeq -> Interpreter Returned
runStatements = liftM or . mapM runStatement

runStatement :: Lexeme Statement -> Interpreter Returned
runStatement (Lex st posn) = case st of

    StAssign accL expL ->  do
        expValue <- evalExpression expL
        id <- accessDataType accL
        modifyMarco id expValue
        return False
 
    StReturn expL -> do
        return False

    StFunctionCall idL expLs -> do
        return False

    StRead idL -> do
        return False

    StPrint expL -> do
        expValue <- evalExpression expL
        return False   

    StIf expL trueBlock falseBlock -> do
        expValue <- evalExpression expL

        if (expValue == DataBool True)
        then void $ runStatements trueBlock
        else void $ runStatements falseBlock

        return False

    StFor idL expL block -> do
        let id = lexInfo idL
        matrix <- evalExpression expL
        
        unless(isDataMatrix matrix )  $ tellDError NoEsMatriz
        void $ iteraRows 0 0 id (getMatrix matrix) block

        return False

    StWhile expL block -> loop
        where
        loop = do
          expValue <- evalExpression expL

          if (expValue == DataBool True)
          then do
            void $ runStatements block
            loop
          else return False

    StBlock dclS block -> do
        enterMarco M.empty
        runDeclarations dclS
        void $ runStatements block
        exitMarco
        return False
       
    _ -> return False

--------------------------------------------------------------------------------
-- Expressions

evalExpression :: Lexeme Expression -> Interpreter TypeValue
evalExpression (Lex exp posn) = case exp of

    LitNumber vL -> return (DataNumber $ (lexInfo vL))

    LitBool vL   -> return (DataBool $ (lexInfo vL))

    LitString sL -> return (DataString $ (lexInfo sL))

    VariableId idL -> return (DataNumber 0.0)
        --liftM (fromMaybe DataEmpty) $ runMaybeT $ do
        --let id = lexInfo idL
        --maySymI <- getsSymbol  id ((lexInfo . dataType) &&& value)
        --let (dt, val) = fromJust maySymI
        --return (DataNumber 0.0)
    
    LitMatrix exps -> liftM (fromMaybe DataEmpty) $ runMaybeT $ do
        let arrays = map toList exps
        value <- lift $ mapM (mapM evalExpression) arrays
        let matriz = fromLists value

        return $ DataMatrix matriz

    FunctionCall idL expLs -> liftM (fromMaybe DataEmpty) $ 
                                  runMaybeT $ do 
        return DataEmpty

    ProyM expL indexlL indexrL -> liftM (fromMaybe DataEmpty) $
                                  runMaybeT $ do
        expValue <- lift $ evalExpression expL
        
        let (i,j) = getSize expValue
        let m = getMatrix expValue

        rindex <- lift $ evalExpression indexlL
        let rsize = getNumber rindex

        if (rsize > i)
        then error "Error: Accesando a elemento inexistente en la matriz"
        else do
            cindex <- lift $ evalExpression indexrL
            let csize = getNumber cindex 
        
            if (csize > j)
            then error "Error: Accesando a elemento inexistente en la matriz"
            else return (m ! (rsize,csize))

    ProyRC expL indexL -> liftM (fromMaybe DataEmpty) $
                                  runMaybeT $ do
        expValue <- lift $ evalExpression expL
        
        let (i,j) = getSize expValue
        let m = getMatrix expValue

        index <- lift $ evalExpression indexL
        let size = getNumber index

        if (i == 1)
        then do
            if (size > j)
            then error "Error: Accesando a elemento inexistente del vector"
            else return (m ! (i, size))
        else do
            if (size > i)
            then error "Error: Accesando a elemento inexistente del vector"
            else return (m ! (size, j))

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

---------------------------------------
iteraRows :: Int -> Int -> Identifier -> Matriz TypeValue 
                 -> (StatementSeq) -> Interpreter Returned
iteraRows i j id matrix block = do
    if (i <= (rowSize matrix ))
    then do iteraColumn i j id matrix block
    else return False

iteraColumn ::  Int -> Int -> Identifier -> Matriz TypeValue 
                    -> (StatementSeq) -> Interpreter Returned
iteraColumn i j id matrix block = do
    if (j <= (colSize matrix))
    then do modifyMarco id (getElem i j matrix)
            void $ runStatements block
            iteraColumn i (j+1) id matrix block
    else iteraRows (i+1) 0 id matrix block

--------------------------------------------------------------------------------
-- Operations

runBinary :: Binary -> (TypeValue, TypeValue) -> Interpreter TypeValue
runBinary op (lValue, rValue) = case op of
    OpSum        -> return (addOp     lValue rValue)
    OpDiff       -> return (diffOp    lValue rValue)
    OpMul        -> return (mulOp     lValue rValue)
    OpLess       -> return (less      lValue rValue)
    OpLessEq     -> return (lessEq    lValue rValue)
    OpGreat      -> return (great     lValue rValue)
    OpGreatEq    -> return (greatEq   lValue rValue)
    OpEqual      -> return (DataBool (lValue == rValue))
    OpUnequal    -> return (DataBool (lValue /= rValue))
    OpOr         -> return (orOp      lValue rValue)
    OpAnd        -> return (andOp     lValue rValue)
    OpDiv        -> if (rValue == DataNumber 0.0) 
                    then error "Error: Division entre 0"
                    else return (divOp lValue rValue)
    OpMod        -> if (rValue == DataNumber 0.0) 
                    then error "Error: Division entre 0"
                    else return (modOp lValue rValue)
    OpDivEnt     -> if (rValue == DataNumber 0.0) 
                    then error "Error: Division entre 0"
                    else return (divEntOp lValue rValue)
    OpModEnt     -> if (rValue == DataNumber 0.0) 
                    then error "Error: Division entre 0"
                    else return (modEntOp lValue rValue)
    OpCruzSum    -> return (cruzSumOp    lValue rValue)
    OpCruzDiff   -> return (cruzDiffOp   lValue rValue)
    OpCruzMul    -> return (cruzMulOp    lValue rValue)
    OpCruzDivEnt -> return (cruzDivEntOp lValue rValue)
    OpCruzModEnt -> return (cruzModEntOp lValue rValue)
    OpCruzDiv    -> return (cruzDivOp    lValue rValue)
    OpCruzMod    -> return (cruzModOp    lValue rValue)


addOp :: TypeValue -> TypeValue -> TypeValue
addOp (DataNumber n) (DataNumber m) = (DataNumber (n+m))
addOp (DataMatrix lmatrix) (DataMatrix rmatrix) = (DataMatrix (lmatrix + rmatrix))

diffOp :: TypeValue -> TypeValue -> TypeValue
diffOp (DataNumber n) (DataNumber m) = (DataNumber (n-m))
diffOp (DataMatrix lmatrix) (DataMatrix rmatrix) = (DataMatrix (lmatrix - rmatrix))

mulOp :: TypeValue -> TypeValue -> TypeValue
mulOp (DataNumber n) (DataNumber m) = (DataNumber (n*m))
mulOp (DataMatrix lmatrix) (DataMatrix rmatrix) = (DataMatrix (lmatrix * rmatrix))

divOp :: TypeValue -> TypeValue -> TypeValue
divOp (DataNumber n) (DataNumber m) = (DataNumber (div m n))

modOp :: TypeValue -> TypeValue -> TypeValue
modOp (DataNumber n) (DataNumber m) = (DataNumber (mod m n))

divEntOp :: TypeValue -> TypeValue -> TypeValue
divEntOp (DataNumber n) (DataNumber m) = (DataNumber (n / m))

modEntOp :: TypeValue -> TypeValue -> TypeValue
modEntOp (DataNumber n) (DataNumber m) = (DataNumber (n % m))

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

cruzSumOp :: TypeValue -> TypeValue -> TypeValue
cruzSumOp j@(DataNumber n) (DataMatrix m) = (DataMatrix (sumMatriz j m))
cruzSumOp (DataMatrix m) j@(DataNumber n) = (DataMatrix (sumMatriz j m))

cruzDiffOp :: TypeValue -> TypeValue -> TypeValue
cruzDiffOp j@(DataNumber n) (DataMatrix m) = (DataMatrix (sumMatriz j (-m)))
cruzDiffOp (DataMatrix m) j@(DataNumber n) = (DataMatrix (sumMatriz (-j) m))

cruzMulOp :: TypeValue -> TypeValue -> TypeValue
cruzMulOp j@(DataNumber n) (DataMatrix m) = (DataMatrix (mulMatriz j m))
cruzMulOp (DataMatrix m) j@(DataNumber n) = (DataMatrix (mulMatriz j m))

cruzDivEntOp :: TypeValue -> TypeValue -> TypeValue
cruzDivEntOp j@(DataNumber n) (DataMatrix m) = (DataMatrix (divEntNM j m))
cruzDivEntOp (DataMatrix m) j@(DataNumber n) = (DataMatrix (divEntMN j m))

--este es el %
cruzModEntOp :: TypeValue -> TypeValue -> TypeValue
cruzModEntOp j@(DataNumber n) (DataMatrix m) = (DataMatrix (modEntNM j m))
cruzModEntOp (DataMatrix m) j@(DataNumber n) = (DataMatrix (modEntMN j m))

-- este es el div
cruzDivOp :: TypeValue -> TypeValue -> TypeValue
cruzDivOp j@(DataNumber n) (DataMatrix m) = (DataMatrix (divNM j m))
cruzDivOp (DataMatrix m) j@(DataNumber n) = (DataMatrix (divMN j m))

cruzModOp :: TypeValue -> TypeValue -> TypeValue
cruzModOp j@(DataNumber n) (DataMatrix m) = (DataMatrix (modNM j m))
cruzModOp (DataMatrix m) j@(DataNumber n) = (DataMatrix (modMN j m))

--------------------------------------------------------------------------------

runUnary :: Unary -> TypeValue -> Interpreter TypeValue
runUnary op value = case op of
    OpNegative   -> return (negOp value) 
    OpNot        -> return (notOp value)
    OpTranspose  -> return (transposeOp value)

negOp :: TypeValue -> TypeValue
negOp (DataNumber n) = (DataNumber (-n))
negOp (DataMatrix matrix) = (DataMatrix (-matrix))

notOp :: TypeValue -> TypeValue
notOp (DataBool bool) = (DataBool (not bool))

transposeOp :: TypeValue -> TypeValue
transposeOp (DataMatrix matrix) = (DataMatrix (transpose matrix))

--------------------------------------------------------------------------------

accessDataType :: Lexeme Access -> Interpreter Identifier
accessDataType (Lex acc posn) = case acc of

    VariableAccess idL -> return (lexInfo idL)

    MatrixAccess idL explL exprL -> return (lexInfo idL)

    RCAccess idL expL -> return (lexInfo idL)

