{-# LANGUAGE DeriveTraversable #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverlappingInstances #-}
{-# LANGUAGE TypeSynonymInstances #-}

module SymbolTable
    ( SymbolTable
    , emptyTable
    , member
    , insert
    , lookup
    , lookupWithScope
    , update
    , updateWithScope
    , toSeq
    , fromSeq
    , Symbol(..)
    , scope
    , emptySymInfo
    , emptySymFunction
    , Used
    , Returned
--    , Offset
--    , Width
    , SymbolCategory(..)
    , symbolCategory
    , getBody
    , module Stack
    , module Scope
    ) where

import          Program
import          Scope
import          Stack

import          Data.Foldable (concatMap, find, foldr, msum, toList)
import          Data.Function (on)
import          Data.List (groupBy, intercalate, sortBy)
import qualified Data.Map.Strict as Map (Map, adjust, elems, empty, insert, 
                                         lookup, member, singleton, toList)
import          Data.Maybe (isJust)
import          Data.Sequence (Seq, empty, fromList)
import          Prelude hiding (concatMap, foldr, lookup)
import qualified Prelude as P (fmap)

type SymbolTable = Map.Map Identifier (Map.Map Scope Symbol)

instance Show SymbolTable where
    show tb = showTable 0 tb

---------------------------------------------------------------------

showTable :: Int -> SymbolTable -> String
showTable t tab = tabs ++ "Tabla de Simbolos:\n" ++ concatMap (++ ("\n" ++ tabs)) showSymbols
    where
        allSyms :: [(Identifier, Symbol)]
        allSyms = toList $ toSeq tab
        sortIt :: [(Identifier, Symbol)]
        sortIt = sortBy (compareOn scope) allSyms
        groupIt :: [[(Identifier, Symbol)]]
        groupIt = groupBy (equalOn scope) sortIt
        groupItKey :: [(Scope, [(Identifier, Symbol)])]
        groupItKey = map (\ls@((_,s):_) -> (scope s,ls)) groupIt
        showSymbols :: [String]
        showSymbols = map (uncurry showScpInfs) groupItKey
        -----------------------------------------------
        tabs :: String
        tabs = replicate t '\t'
        equalOn :: Eq a => (Symbol -> a) -> (Identifier, Symbol) -> (Identifier, Symbol) -> Bool
        equalOn f = (==) `on` (f . snd)
        compareOn :: Ord a => (Symbol -> a) -> (Identifier, Symbol) -> (Identifier, Symbol) -> Ordering
        compareOn f = compare `on` (f . snd)
        showScpInfs :: Scope -> [(Identifier, Symbol)] -> String
        showScpInfs scp infs = tabs ++ "\t" ++ show scp ++ " -> " ++ concatMap (uncurry showInf) infs
        showInf :: Identifier -> Symbol -> String
        showInf idn sym = "\n\t\t" ++ tabs ++ "'" ++ idn ++ "':" ++ replicate (3 - div (length idn + 3) 4) '\t' ++ show sym

type Used = Bool
type Returned = Bool

---------------------------------------------------------------------

data Symbol = 
    SymInfo
        { dataType   :: Lexeme DataType
        , scopeStack :: Stack Scope
        , defPosn    :: Position
        , used       :: Used
        , value      :: TypeValue
        }
    | SymFunction
        { paramTypes :: Seq (Lexeme DataType)
        , returnType :: Lexeme DataType
        , returned   :: Returned
        , body       :: StatementSeq
        , scopeStack :: Stack Scope
        , defPosn    :: Position
        , used       :: Used
--        , value      :: TypeValue
        }

getBody :: Symbol -> StatementSeq
getBody (SymFunction a b c body d e f) = body

instance Show Symbol where
    show sym = case sym of
        SymInfo dt stk pos u val -> intercalate ", " [showP pos, showC, showDT, showU u, showStk stk, showVal]
            where
                showVal = show val
                showC = show CatInfo
                showDT  = show $ lexInfo dt

        SymFunction param rt _ _ stk pos u -> intercalate ", " [showP pos, showC, showSign, showU u, showStk stk]
            where
                showC = show CatFunction
                showSign = "(" ++ intercalate "," (map (show . lexInfo) $ toList param) ++ ") return " ++ show (lexInfo rt)
        where
            showP pos  = "(" ++ show pos ++ ")"
            showU u  = if u then "Usada" else "No usada"
            showStk  = ("stack: " ++) . show

---------------------------------------------------------------------

scope :: Symbol -> Scope
scope = top . scopeStack

---------------------------------------------------------------------

data SymbolCategory = CatInfo
                    | CatFunction
                    deriving (Eq)

instance Show SymbolCategory where
    show sc = case sc of
        CatInfo     -> "variable"
        CatFunction -> "function"

instance Ord SymbolCategory where
    compare x y = case (x, y) of
        (CatInfo    , CatInfo    ) -> EQ
        (CatFunction, CatFunction) -> EQ
        (CatInfo    , CatFunction) -> LT
        (CatFunction, CatInfo    ) -> GT

---------------------------------------------------------------------

emptyTable :: SymbolTable
emptyTable = Map.empty

emptySymInfo :: Symbol
emptySymInfo = SymInfo
    { dataType = pure Bool
    , scopeStack = globalStack
    , defPosn = defaultPosn
    , used = False
    , value = defaultValue Bool
    }

emptySymFunction :: Symbol
emptySymFunction = SymFunction
    { paramTypes = empty
    , returnType = pure Bool
    , returned = False
    , body = empty
    , scopeStack = globalStack
    , defPosn = defaultPosn
    , used = False
    }

---------------------------------------------------------------------

symbolCategory :: Symbol -> SymbolCategory
symbolCategory sym = case sym of
    SymInfo {}     -> CatInfo
    SymFunction {} -> CatFunction

member :: Identifier -> Stack Scope -> SymbolTable -> Bool
member id scps = isJust . lookupWithScope id scps

insert :: Identifier -> Symbol -> SymbolTable -> SymbolTable
insert id sym tab = if Map.member id tab
    then Map.adjust inner id tab
    else Map.insert id (Map.singleton scp sym) tab
    where
        inner scpTab = if Map.member scp scpTab
            then error "SymbolTable.insert: Simbolo previamente insertado en la Tabla de Simbolos"
            else Map.insert scp sym scpTab
        scp = scope sym

---------------------------------------------------------------------

lookup :: Identifier -> SymbolTable -> Maybe Symbol
lookup id tab = Map.lookup id tab >>= return . head . Map.elems

lookupWithScope :: Identifier -> Stack Scope -> SymbolTable -> Maybe Symbol
lookupWithScope id scps tab = do
    scpTab <- Map.lookup id tab
    msum $ P.fmap (flip Map.lookup scpTab) scps

---------------------------------------------------------------------

update :: Identifier -> (Symbol -> Symbol) -> SymbolTable -> SymbolTable
update id f tab = if Map.member id tab
    then Map.adjust (P.fmap f) id tab
    else error "SymbolTable.update: Actualizando un simbolo inexistente en la Tabla de Simbolos"

updateWithScope :: Identifier -> Stack Scope -> (Symbol -> Symbol) -> SymbolTable -> SymbolTable
updateWithScope id scps f tab = Map.adjust func id tab
    where
        func scpTab = maybe tellError updateSym $ find condition scps
            where
                updateSym scp = Map.adjust f scp scpTab
                condition scp = Map.member scp scpTab
                tellError = error "SymbolTable.updateWithScope: Actualizando un simbolo inexistente en la Tabla de Simbolos"

---------------------------------------------------------------------

toSeq :: SymbolTable -> Seq (Identifier, Symbol)
toSeq = fromList . expand . Map.toList
    where
        expand = concatMap (\(id, syms) -> zip (repeat id) (toList syms))
        sortIt = sortBy comp
        comp x y = case compOn symbolCategory x y of
          EQ -> compOn defPosn x y
          other -> other
        compOn f = compare `on` (f . snd)

fromSeq :: Seq (Identifier, Symbol) -> SymbolTable
fromSeq = foldr (uncurry insert) emptyTable

