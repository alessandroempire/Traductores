{-# LANGUAGE LambdaCase #-}

module DataType
    ( DataType(..)
    , Number
    , toIdentifier
    , isScalar
    , isNumber
    , isMatrix
    , isRow
    , isCol
    , isValid
    , TypeValue(..)
    , defaultValue
    , getSize
    , getNumber
    , getMatrix
    , modEntNM
    , modEntMN
    , divMN
    , divNM
    , modMN
    , modNM
    ) where

import          Lexeme
import          Identifier
import          Matriz
import          Operator

import              Data.Function (on)
import qualified    Data.Vector         as V

type Number = Double

data DataType 
    = Bool 
    | Number
    | String
    | Matrix (Lexeme Double) (Lexeme Double)
    | Row (Lexeme Double)
    | Col (Lexeme Double)
    | TypeError
    deriving (Ord)

instance Show DataType where
    show = \case
        Bool            -> "Bool"
        Number          -> "Number"
        String          -> "String"
        Matrix sizeR sizeC -> "Matrix(" ++ show (lexInfo sizeR) ++ "," ++ show (lexInfo sizeC) ++ ")"
        Row size        -> "Row(" ++ show (lexInfo size) ++ ")"
        Col size        -> "Col(" ++ show (lexInfo size) ++ ")"
        TypeError       -> error "DataType: TypeError"

instance Eq DataType where
    a == b = case (a,b) of
        (Bool, Bool)                           -> True
        (Number, Number)                       -> True
        (String, String)                       -> True
        (Matrix rowA colA, Matrix rowB colB)   -> (comp rowA rowB) && (comp colA colB)
        (Row sizeA, Row sizeB)                 -> comp sizeA sizeB
        (Col sizeA, Col sizeB)                 -> comp sizeA sizeB
        (Row sizeC, Matrix rowM colM)          -> (comp sizeC rowM) && ((lexInfo colM) == 1) 
        (Col sizeR, Matrix rowM colM)          -> (comp sizeR colM) && ((lexInfo rowM) == 1)
        (TypeError, TypeError)                 -> True
        _                                      -> False
        where
            comp :: Eq a => Lexeme a -> Lexeme a -> Bool
            comp = (==) `on` lexInfo

---------------------------------------------------------------------

toIdentifier :: DataType -> Identifier
toIdentifier dt = case dt of
    Bool       -> "Bool"
    Number     -> "Number"
    String     -> "String"
    Matrix _ _ -> "Matrix"
    Row _      -> "Row"
    Col _      -> "Col"
    TypeError  -> "Error"

isScalar :: DataType -> Bool
isScalar = flip elem [Number, Bool]

isNumber :: DataType -> Bool
isNumber = \case
    Number -> True
    _      -> False

isMatrix :: DataType -> Bool
isMatrix = \case
    Matrix _ _ -> True
    _          -> False

isRow :: DataType -> Bool
isRow = \case
    Row _ -> True
    _     -> False

isCol :: DataType -> Bool
isCol = \case
    Col _ -> True
    _     -> False

isValid :: DataType -> Bool
isValid = (/= TypeError)

---------------------------------------------------------------------

data TypeValue 
    = DataBool Bool 
    | DataNumber Number
    | DataMatrix (Matriz TypeValue)
    | DataString String
    | DataEmpty

instance Show TypeValue where
    show = \case
        DataBool b   -> show b
        DataNumber n -> show n
        DataMatrix m -> show m
        DataString s -> show s
        DataEmpty    -> error "TypeValue: Empty"

instance Eq TypeValue where
    a == b = case (a,b) of
        (DataBool bl, DataBool br)             -> bl == br
        (DataNumber n, DataNumber m)           -> n == m
        (DataMatrix m, DataMatrix n)           -> equalMatriz m n
        (DataString ls, DataString rs)         -> ls == rs
        (DataEmpty, DataEmpty)                 -> True
        _                                      -> False

instance Num TypeValue  where
    DataNumber m + DataNumber n = DataNumber (m + n)
    DataNumber m - DataNumber n = DataNumber (m - n)
    DataNumber m * DataNumber n = DataNumber (m * n)
    negate (DataNumber m) = DataNumber (-m)
    abs (DataNumber m)    = DataNumber (abs m)
    signum (DataNumber m) = DataNumber (signum m)
    fromInteger a = (DataNumber 0)

instance Fractional TypeValue where
    DataNumber m / DataNumber n = (DataNumber (m / n))
    recip (DataNumber m)        = (DataNumber (recip m))
    fromRational a              = (DataNumber 0)

instance Ord TypeValue where
    compare (DataNumber m) (DataNumber n) = (compare m n)
    (DataNumber m) < (DataNumber n)       = m < n
    (DataNumber m) >= (DataNumber n)      = m >= n
    (DataNumber m) >(DataNumber n)        = m > n
    (DataNumber m) <= (DataNumber n)      = m <= n
    max (DataNumber m) (DataNumber n)     = (DataNumber (max m n))
    min (DataNumber m) (DataNumber n)     = (DataNumber (min m n))

instance Real TypeValue where
    toRational (DataNumber m) = toRational m
        
--------------------------------------------------------------------- 
defaultValue :: DataType -> TypeValue
defaultValue = \case
    Bool           -> DataBool False
    Number         -> DataNumber 0.0 
    Matrix row col -> DataMatrix $ zero' (round $ lexInfo row) (round $ lexInfo col) (DataNumber 0.0)
    Row size -> DataMatrix $ zero' 1 (round $ lexInfo size) (DataNumber 0.0) 
    Col size -> DataMatrix $ zero' (round $ lexInfo size) 1 (DataNumber 0.0)
    _        -> DataEmpty

getSize :: TypeValue -> (Int,Int)
getSize (DataMatrix m) = (rowSize m, colSize m)

getNumber :: TypeValue -> Int
getNumber (DataNumber n) = round n

getMatrix :: TypeValue -> Matriz TypeValue
getMatrix (DataMatrix m) = m

---------------------------------------------------------------------
--Simular un fuctor
--prueba :: (DataNumber m) -> (DataNumber n) -> DataNumber 
funcP (DataNumber m) (DataNumber n) = DataNumber( m Operator.% n)

-- Number % matrix
modEntNM :: TypeValue -> Matriz TypeValue -> Matriz TypeValue
modEntNM = fmap . (funcP)

-- matrix % Number
modEntMN :: TypeValue -> Matriz TypeValue -> Matriz TypeValue
modEntMN = fmap . flip funcP

----------------------------------
-- Functor para el div
funcDiv (DataNumber m) (DataNumber n) = DataNumber(Operator.div m n)

-- Number div matriz
divNM :: TypeValue -> Matriz TypeValue -> Matriz TypeValue
divNM = fmap . (funcDiv)

-- matriz div number
divMN :: TypeValue -> Matriz TypeValue -> Matriz TypeValue
divMN = fmap . flip funcDiv

----------------------------------
-- Functor para el mod
funcMod (DataNumber m) (DataNumber n) = DataNumber(Operator.mod m n)

-- number mod matriz
modNM :: TypeValue -> Matriz TypeValue -> Matriz TypeValue
modNM = fmap . (funcMod)

-- matriz mod number
modMN :: TypeValue -> Matriz TypeValue -> Matriz TypeValue
modMN = fmap . flip funcMod

