{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE LambdaCase #-}

module TrinityMonad where

import          Error
import          Program
import          SymbolTable

import           Control.Monad        (MonadPlus, when, liftM, unless, guard)
import           Control.Monad.State  (MonadState, gets, modify)
import           Control.Monad.Writer (MonadWriter, tell)
import           Data.Function        (on)
import qualified Data.Map.Strict      as Map (Map, fromList)
import           Data.Maybe           (isJust)
import           Data.Sequence        (Seq, singleton, empty, filter)
import           Prelude              hiding (filter)

unlessGuard :: MonadPlus m => Bool -> m () -> m ()
unlessGuard cond actn = unless cond actn >> guard cond

type TrinityWriter = Seq Error

initialWriter :: TrinityWriter
initialWriter = empty

class Show s => TrinityState s where
    getTable   :: s -> SymbolTable
    getStack   :: s -> Stack Scope
    getScopeId :: s -> Scope
    getAst     :: s -> Program
    putTable   :: SymbolTable -> s -> s
    putStack   :: Stack Scope -> s -> s
    putScopeId :: Scope    -> s -> s
    putAst     :: Program     -> s -> s

showTrinityState :: TrinityState s => s -> String
showTrinityState st = showT ++ showS ++ showA
    where
        showT = show (getTable st) ++ "\n"
        showS = "Scope Stack:\n"  ++ show (getStack st) ++ "\n"
        showA = show (getAst st) ++ "\n"

------------------------------------------------------------------------

tellLError :: MonadWriter TrinityWriter m => Position -> LexerError -> m ()
tellLError posn = tell . singleton . LError posn

tellPError :: MonadWriter TrinityWriter m => Position -> ParseError -> m ()
tellPError posn = tell . singleton . PError posn

tellSError :: MonadWriter TrinityWriter m => Position -> StaticError -> m ()
tellSError posn = tell . singleton . SError posn

------------------------------------------------------------------------

enterScope :: (TrinityState s, MonadState s m) => m ()
enterScope = do
    scp <- liftM succ $ gets getScopeId
    modify $ \s -> putStack (push scp (getStack s)) $ putScopeId scp s

exitScope :: (TrinityState s, MonadState s m) => m ()
exitScope = modify $ \s -> putStack (pop $ getStack s) s

currentScope :: (TrinityState s, MonadState s m) => m Scope
currentScope = gets (top . getStack)

------------------------------------------------------------------------

addSymbol :: (TrinityState s, MonadState s m) 
          => Identifier -> Symbol -> m ()
addSymbol idn sym = do
    tab <- gets getTable
    modify $ \s -> putTable (insert idn sym tab) s

getSymbol :: (TrinityState s, MonadState s m) 
          => Identifier -> m (Maybe Symbol)
getSymbol = flip getsSymbol id

getsSymbol :: (TrinityState s, MonadState s m) 
           => Identifier -> (Symbol -> a) -> m (Maybe a)
getsSymbol idn f = do
    stk <- gets getStack
    getsSymbolWithStack idn stk f

getsSymbolWithStack :: (TrinityState s, MonadState s m) 
                    => Identifier -> Stack Scope -> (Symbol -> a) -> m (Maybe a)
getsSymbolWithStack idn stk f = gets getTable >>= return . fmap f . lookupWithScope idn stk

------------------------------------------------------------------------

modifySymbolWithScope :: (TrinityState s, MonadState s m)
                      => Identifier -> Stack Scope -> (Symbol -> Symbol) -> m ()
modifySymbolWithScope idn stk f = do
    tab <- gets getTable
    exists <- liftM isJust $ getsSymbolWithStack idn stk f
    when exists $ modify $ \s -> putTable (updateWithScope idn stk f tab) s

modifySymbol :: (TrinityState s, MonadState s m)
             => Identifier -> (Symbol -> Symbol) -> m ()
modifySymbol idn f = getsSymbol idn scopeStack >>= \case
    Nothing  -> return ()
    Just stk -> modifySymbolWithScope idn stk f

------------------------------------------------------------------------

markUsed :: (TrinityState s, MonadState s m)
         => Identifier -> m ()
markUsed idn = modifySymbol idn $ \sym -> sym { used = True }
