{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE DoAndIfThenElse#-}

module Interpreter
    ( InterpreterState
    , Interpreter
    , processInterpreter
    , getFrame
    ) where

import            Error
import            Program
import            TrinityMonad
import            SymbolTable
import            Matriz
import            Operator

import qualified  Data.Map as M
import            Control.Arrow ((&&&))
import            Control.Monad.Cont (ContT)
import            Control.Monad (forever, guard, liftM, unless, void, when, (>=>))
import            Control.Monad.Reader (asks)
import            Control.Monad.RWS (RWS, RWST, evalRWS, execRWS, execRWST, lift)
import            Control.Monad.State (StateT,gets, modify)
import            Control.Monad.Trans (liftIO)
import            Control.Monad.Trans.Maybe (MaybeT, runMaybeT)
import            Control.Monad.Writer (WriterT, tell)
import            Data.Foldable (all, and, forM_, or, toList)
import            Data.Functor ((<$>))
import            Data.Maybe (fromJust, fromMaybe, isJust)
import            Data.Sequence (Seq, empty, length, zipWith, (<|))
import            Data.Traversable (forM, mapM)
import qualified  Data.List as L (and, length, transpose)
import            Prelude hiding (all, and, exp, length, lookup, mapM, 
                                  null, or, zipWith, mod, div)

type Interpreter = RWST TrinityReader TrinityWriter InterpreterState IO

data InterpreterState = InterpreterState
    { table :: SymbolTable
    , stack :: Stack Scope
    , scopeId :: Scope
    , ast :: Program
    , funcStack :: Stack (Identifier, DataType, Scope)
    , frames :: Stack (M.Map Identifier TypeValue)
    , fun :: (M.Map Identifier (Seq(Identifier)))
}

getFrame (InterpreterState a b c d f g h) = g

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
    , frames = push (M.empty) emptyStack
    , fun = M.empty
    }

---------------------------------------------------------------------

buildInterpreter :: TrinityWriter -> SymbolTable -> Program -> Interpreter ()
buildInterpreter w tab program@(Program fun block) = do
    modify $ \s -> s { table = tab, ast = program }
    tell w
    void $ runFunctions fun
    void $ runStatements block

---------------------------------------------------------------------
-- Using the Monad

processInterpreter :: TrinityReader -> TrinityWriter -> SymbolTable -> Program -> IO (InterpreterState, TrinityWriter)
processInterpreter r w tab = runInterpreter r . buildInterpreter w tab

runInterpreter :: TrinityReader -> Interpreter a -> IO (InterpreterState, TrinityWriter)
runInterpreter r = flip (flip execRWST r) initialState

--------------------------------------------------------------------------------
-- Monad handling

enterFrame map = do
    modify $ \s -> s { frames = push (map) (frames s) }

exitFrame = modify $ \s -> s { frames = pop $ frames s }

currentStack :: Interpreter(Stack (M.Map Identifier TypeValue))
currentStack = gets frames

currentFrame :: Interpreter(M.Map Identifier TypeValue)
currentFrame = gets (top . frames)

currentTable :: Interpreter(SymbolTable)
currentTable = gets table

currentFun :: Interpreter(M.Map Identifier (Seq(Identifier)))
currentFun = gets fun

modifyFun id idVal = do 
    fun <- currentFun
    if (M.member id fun)
    then do let s = fun M.! id
                newS = idVal <| s
            modify $ \s -> s {fun = M.insert id newS fun}
    else do let s    = empty 
                newS = idVal <| s 
            modify $ \s -> s {fun = M.insert id newS fun}

modifyFrame id value = do
    map <- currentFrame
    exitFrame
    let newMap = M.insert id value map
    enterFrame (newMap)

--modifyFun (id,val) = do 

lookupValue :: Identifier -> Interpreter TypeValue
lookupValue id = do
    stack <- currentStack
    let newStack = cloneStack stack
    lookupValueStacks id newStack

--lookupValueStacks :: Identifier -> Stack -> Interpreter TypeValue
lookupValueStacks id stack = do
    if (isEmptyStack stack )
    then error "Valor inesperado"
    else do
        let t = top stack
        case M.lookup id t of
            Just val -> return val
            Nothing -> lookupValueStacks id (pop stack)

enterFunction :: Identifier -> DataType -> Interpreter ()
enterFunction idL dt = do
    currentId <- currentScope
    modify $ \s -> s { funcStack = push (idL, dt, currentId) (funcStack s) }

exitFunction :: Interpreter ()
exitFunction = modify $ \s -> s { funcStack = pop $ funcStack s }

currentFunction :: Interpreter (Identifier, DataType, Scope)
currentFunction = gets (top . funcStack)

---------------------------------------------------------------------
-- Declarations

runDeclarations :: DeclarationSeq -> Lexeme Identifier -> Interpreter Returned
runDeclarations d idF = liftM or $ mapM (flip runDeclaration idF) d

runDeclaration :: Lexeme Declaration -> Lexeme Identifier -> Interpreter Returned
runDeclaration (Lex dcl posn) idF = case dcl of

    Dcl dtL idL -> do
        let id       = lexInfo idL
            defValue = defaultValue (lexInfo dtL)

        modifyFrame id defValue
        return False

    DclInit dtL idL expL -> do
        let id = lexInfo idL

        expValue <- evalExpression expL

        modifyFrame id expValue

        return False

    DclParam dtL idL -> do
        let id = lexInfo idL
        modifyFun (lexInfo idF) id
        return False

---------------------------------------------------------------------
runFunctions :: FunctionSeq -> Interpreter Returned
runFunctions = liftM or . mapM runFunction

runFunction :: Lexeme Function -> Interpreter Returned
runFunction (Lex st posn) = case st of

    Function idL decS dt staSeq ->  do        
        runDeclarations decS idL
        return False 

--------------------------------------------------------------------------------
-- Statements

--runStatements :: StatementSeq -> Interpreter Returned
runStatements s = mapM runStatement s

--runStatement :: Lexeme Statement -> Interpreter Returned
runStatement (Lex st posn) = case st of

    StAssign accL expL ->  do
        expValue <- evalExpression expL
        id <- accessDataType accL
        modifyFrame id expValue
        return DataEmpty
 
    StReturn expL -> do
        expVal <- evalExpression expL
        return expVal

    StRead idL -> do
        let id = lexInfo idL

        maySymI <- getsSymbol id (lexInfo . dataType)
        let dt = fromJust maySymI

        if (isNumber dt)
        then do
            line <- liftIO $ processLineNumber  
            let value = DataNumber line
           
            modifyFrame id value
  
            return DataEmpty
        else do
            line <- liftIO $ processLineBool  
            let value = DataBool line

            liftIO $ print value

            modifyFrame id value
  
            return DataEmpty
 
    StPrint expL -> do
        expValue <- evalExpression expL
      
        liftIO $ print expValue

        return DataEmpty   

    StIf expL trueBlock falseBlock -> do
        expValue <- evalExpression expL

        if (expValue == DataBool True)
        then void $ runStatements trueBlock
        else void $ runStatements falseBlock

        return DataEmpty

    StFor idL expL block -> do
        let id = lexInfo idL
        matrix <- evalExpression expL
        
        void $ iteraRows 1 1 id (getMatrix matrix) block

        return DataEmpty

    StWhile expL block -> loop
        where
        loop = do
          expValue <- evalExpression expL

          if (expValue == DataBool True)
          then do
            void $ runStatements block
            loop
          else return DataEmpty

    StBlock dclS block -> do
        enterFrame  (M.empty)
        runDeclarations dclS (fillLex "")
        void $ runStatements block
        exitFrame
        return DataEmpty
       
    _ -> return DataEmpty

--------------------------------------------------------------------------------
-- Expressions

evalExpression :: Lexeme Expression -> Interpreter TypeValue
evalExpression (Lex exp posn) = case exp of

    LitNumber vL -> return (DataNumber $ (lexInfo vL))

    LitBool vL   -> return (DataBool $ (lexInfo vL))

    LitString sL -> return (DataString $ (lexInfo sL))

    VariableId idL -> liftM (fromMaybe DataEmpty) $ runMaybeT $ do
        let id = lexInfo idL
        val <- lift $ lookupValue id 
        return val
    
    LitMatrix exps -> liftM (fromMaybe DataEmpty) $ runMaybeT $ do
        let arrays = map toList exps
        value <- lift $ mapM (mapM evalExpression) arrays
        let matriz = fromLists value

        return $ DataMatrix matriz

    FunctionCall idL expLs -> do  
        t <- currentTable
        let fun = SymbolTable.lookup (lexInfo idL) t
            sym = fromJust fun
            body = getBody sym
        enterFrame (M.empty)
        funciones <- currentFun
        val <- mapM evalExpression expLs
        let seqFun = toList $ funciones M.! (lexInfo idL)
            values = toList val
            newv   = zip seqFun values
       
        mapM (\x -> modifyFrame (fst x) (snd x)) newv

        re <- runStatements body
        let result = head $ toList re
        exitFrame
        return result

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

    ProyV expL indexL -> liftM (fromMaybe DataEmpty) $
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

--------------------------------------------------------------------------------

processLineNumber :: IO Double
processLineNumber = readLn

processLineBool :: IO Bool
processLineBool = readLn

--------------------------------------------------------------------------------


iteraRows i j id matrix block = do
    if (i <= (rowSize matrix ))
    then do
        iteraColumn i j id matrix block
    else return False

--iteraColumn ::  Int -> Int -> Identifier -> Matriz TypeValue 
            --        -> (StatementSeq) -> Interpreter Returned
iteraColumn i j id matrix block = do
    if (j <= (colSize matrix))
    then do modifyFrame id (matrix ! (i,j))
            void $ runStatements block
            iteraColumn i (j+1) id matrix block
    else iteraRows (i+1) 1 id matrix block

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

    VectorAccess idL expL -> return (lexInfo idL)

