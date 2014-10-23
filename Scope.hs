module Scope 
    (
    ) where


newtype Scope = Scope {serial :: ScopeNum }
    deriving(Eq)

instance Show Scope where
    show = show . serial

-- El alcane tope del programa tiene valor default 1
topScope :: Scope
topScope = Scope {serial = topScopeNum }

-- El alcanze con todas las definiciones del lenguaje
-- tiene valor default 0
langScope :: Scope
langScope = Scope {serial = langScopeNum}


-------------------------------------------------------------
type ScopeNum  = Int

topScopeNum :: ScopeNum
topScopeNum = 1

langScopeNum :: ScopeNum
langScopeNum = 0
