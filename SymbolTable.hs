module SymbolTable
    (
    ) where

import          Program
import          Scope
import          Position
import          Stack

import qualified Data.Map.Strict as Map (Map, alter, empty,
                                         lookup, toList)
import           Data.Sequence (Seq)

newtype SymbolTable' a = SymTable
    { getMap :: Map.Map Identifier a
    } 

type SymbolTable = SymbolTable' (Seq Symbol)

--instance Show SymbolTable where
--    show = showTable 0

data Symbol = 
    SymInfo
        { dataType   :: Lexeme TypeId
        , scopeStack :: Stack Scope
        , defPosn    :: Position
        }
    | SymType
        { dataType   :: Lexeme TypeId
        , scopeStack :: Stack Scope
        , defPosn    :: Position
        }
    | SymFunction
        { paramTypes :: Seq (Lexeme TypeId)
        , returnType :: Lexeme TypeId
        , body       :: Function
        , scopeStack :: Stack Scope
        , defPosn    :: Position
        }

scopeNum :: Symbol -> ScopeNum
scopeNum = serial . top . scopeStack

----------------------------------------------------------
emptyTable :: SymbolTable
emptyTable = SymTable Map.empty

emptySymInfo :: Symbol
emptySymInfo = undefined

emptySymType :: Symbol
emptySymType = undefined

emptySymFunction :: Symbol
emptySymFunction= undefined

-----------------------------------------------------------

-- Insertar un symbol
insert :: Identifier -> SymbolTable -> SymbolTable
insert = undefined

-- Buscar el simbolo
lookup :: Identifier -> SymbolTable -> Maybe Symbol
lookup = undefined

-- Buscar el simbolo con un alcance especificado
lookupWithScope :: Identifier -> Stack Scope -> SymbolTable -> Maybe Symbol
lookupWithScope = undefined

-- Retorna todos los simbolos
allSymbols :: SymbolTable -> Seq (Identifier, Symbol)
allSymbols = undefined
