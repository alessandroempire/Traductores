module Stack
    ( Stack(..)
    , top 
    , pop
    , push 
    , modifyStack
    , emptyStack
    , singletonStack
    ) where 

import           Program

import           Data.Foldable (Foldable (..))
import           Prelude        hiding (concatMap, foldr)
import qualified Prelude        as P (foldr)

data Stack a = Stack [a]
    deriving (Eq)

instance Show a => Show (Stack a) where
    show (Stack s) = show s

instance Functor Stack where
    fmap f (Stack s) = Stack $ map f s

instance Foldable Stack where
    foldr f b (Stack s) = P.foldr f b s

top :: Stack a -> a
top (Stack [])       = error "SymbolTable.top: Empty stack"
top (Stack (x : _ )) = x

push :: a -> Stack a -> Stack a
push element (Stack s) = Stack $ element : s

pop :: Stack a -> Stack a
pop (Stack [])      = error "SymbolTable.pop: Empty stack"
pop (Stack (_ : s)) = Stack s

modifyStack :: (a -> a) -> Stack a -> Stack a
modifyStack _ (Stack [])       = Stack[]
modifyStack f (Stack (x : xs)) = Stack(f x : xs)

------------------------------------------------------

emptyStack :: Stack a
emptyStack = Stack [ ]

singletonStack :: a -> Stack a
singletonStack x = Stack [ x ] 