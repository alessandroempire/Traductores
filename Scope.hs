module Scope 
    ( Scope
    , topScope
    , globalScope
    ) where

type Scope = Int

topScope :: Scope
topScope = 1

globalScope :: Scope
globalScope = 0
