module Definition
    ( DefState(..)
    , processDefinition
    ) where

import           Error
import           Program
import           SymbolTable
import           TrinityMonad

import           Control.Arrow                 ((&&&))
import           Control.Monad                 (liftM, unless, void, when)
import           Control.Monad.State           (StateT, runStateT, gets, modify)
import           Control.Monad.Trans.Maybe     (MaybeT, runMaybeT)
import           Control.Monad.RWS             (RWS, execRWS)
import           Control.Monad.Writer          (Writer, execWriter, listen, tell)
import           Data.Foldable                 (all, foldl', foldlM, forM_,
                                                mapM_, maximum)
import           Data.Functor                  ((<$))
import qualified Data.Map.Strict               as Map (toList)
import           Data.Maybe                    (fromJust, isJust)
import           Data.Sequence                 (Seq, empty, null)
import           Data.Traversable              (forM)
import           Prelude                       hiding (all, length, lookup,
                                                mapM_, maximum, null)

type Definition = RWS TrinityReader TrinityWriter DefState

data DefState = DefState
    { table   :: SymbolTable
    , stack   :: Stack Scope
    , scopeId :: Scope
    , ast     :: Program
    , loopLvl :: Int
    }

instance TrinityState DefState where
    getTable   = table
    getStack   = stack
    getScopeId = scopeId
    getAst     = ast
    putTable   tab s = s { table   = tab }
    putStack   stk s = s { stack   = stk }
    putScopeId sc  s = s { scopeId = sc  }
    putAst     as  s = s { ast     = as  }

instance Show DefState where
    show = showTrinityState

---------------------------------------------------------------------

initialState :: DefState
initialState = DefState
    { table     = emptyTable
    , stack     = globalStack
    , scopeId   = globalScope
    , ast       = Program empty empty
    , loopLvl   = 0
    }

---------------------------------------------------------------------

buildDefinition :: TrinityWriter -> Program -> Definition ()
buildDefinition w program@(Program fun block) = do
    modify $ \s -> s { ast = program }
    tell w
    definitionFunctions fun
    definitionStatements block

---------------------------------------------------------------------
-- Using the Monad

processDefinition :: TrinityReader -> TrinityWriter -> Program -> (DefState, TrinityWriter)
processDefinition r w = runDefinition r . buildDefinition w

runDefinition :: TrinityReader -> Definition a -> (DefState, TrinityWriter)
runDefinition r = flip (flip execRWS r) initialState

---------------------------------------------------------------------
-- Monad handling

enterLoop :: Definition ()
enterLoop = modify $ \s -> s { loopLvl = succ $ loopLvl s }

exitLoop :: Definition ()
exitLoop = modify $ \s -> s { loopLvl = pred $ loopLvl s }

---------------------------------------------------------------------
-- Declaration

definitionDeclaration :: DeclarationSeq -> Definition ()
definitionDeclaration = mapM_ processDeclaration

processDeclaration :: Lexeme Declaration -> Definition ()
processDeclaration (Lex dcl posn) = case dcl of

    Dcl dtL idL -> do
        stk <- gets stack
        let id = lexInfo idL
            info = emptySymInfo
                { dataType   = dtL
                , scopeStack = stk
                , defPosn    = posn 
                }
        maySymI <- getsSymbol id $ \sym -> (scopeStack sym, defPosn sym)
        case maySymI of
            Nothing -> addSymbol id info
            Just (symStk, symDefP)
                | symStk == stk         -> tellSError posn (AlreadyDeclared id symDefP)
                | otherwise             -> addSymbol id info

    DclInit dtL idL _ -> do
        stk <- gets stack
        let id = lexInfo idL
            info = emptySymInfo
                { dataType   = dtL
                , scopeStack = stk
                , defPosn    = posn 
                }
        maySymI <- getsSymbol id $ \sym -> (scopeStack sym, defPosn sym)
        case maySymI of
            Nothing -> addSymbol id info
            Just (symStk, symDefP)
                | symStk == stk         -> tellSError posn (AlreadyDeclared id symDefP)
                | otherwise             -> addSymbol id info

    DclParam dtL idL -> do
        stk <- gets stack
        let id = lexInfo idL
            info = emptySymInfo
                { dataType   = dtL
                , scopeStack = stk
                , defPosn    = posn 
                }
        maySymI <- getsSymbol id $ \sym -> (scopeStack sym, defPosn sym)
        case maySymI of
            Nothing -> addSymbol id info
            Just (symStk, symDefP)
                | symStk == stk         -> tellSError posn (AlreadyDeclared id symDefP)
                | otherwise             -> addSymbol id info

---------------------------------------------------------------------
-- Statements

definitionStatements :: StatementSeq -> Definition ()
definitionStatements = mapM_ definitionStatement

definitionStatement :: Lexeme Statement -> Definition ()
definitionStatement (Lex st posn) = case st of

    StIf _ trueBlock falseBlock -> do
        definitionStatements trueBlock

        definitionStatements falseBlock

    StFor idL _ block -> do
--        let dcl = Dcl (pure Number) idL <$ idL

--        processDeclaration dcl
        definitionStatements block

    StWhile _ block -> do
        definitionStatements block

    StBlock dclS stS -> do
        enterScope
        definitionDeclaration dclS
        definitionStatements stS
        exitScope

    _ -> return ()

---------------------------------------------------------------------
-- Functions

definitionFunctions :: FunctionSeq -> Definition ()
definitionFunctions = mapM_ definitionFunction

definitionFunction :: Lexeme Function -> Definition ()
definitionFunction (Lex st posn) = case st of

    Function idL prms dtL block -> do
        stk <- gets stack
        let id = lexInfo idL
            info = emptySymFunction
                { paramTypes = fmap (toDataType . lexInfo) prms
                , returnType = dtL
                , body       = block
                , scopeStack = stk
                , defPosn    = lexPosn idL
                }
        maySymI <- getsSymbol id (\sym -> (scopeStack sym, defPosn sym))
        case maySymI of
            Nothing -> addSymbol id info
            Just (symStk, symDefP)
                | symStk == stk         -> tellSError posn (AlreadyDeclared id symDefP)
                | otherwise             -> addSymbol id info

        enterScope
        mapM_ processDeclaration prms
        definitionStatements block
        exitScope

