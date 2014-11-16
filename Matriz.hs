module Matriz (
      Matriz(..)
    , zero
    , fromLists
    --Operaciones
    , transpose
    , sumarM 
    , restarM 
    , multStd
    -- Operadores cruzados
    , sumMatriz
    , resMatriz
    , mulMatriz
    , divEntMatriz
    , modEntMatriz
    , divMatriz
    , modMatriz
    , minusMatriz
    --Comparacion de matrices
    , equalMatriz
    , unEqMatriz
    ) where

import qualified        Data.Vector as V
import                  Data.Monoid
import                  Control.DeepSeq

data Matriz a = M {
          nrows :: !Int
        , ncols :: !Int
        , mvect :: V.Vector (V.Vector a)
        } deriving Eq

instance Show a => Show (Matriz a) where
    show = prettyMatriz

instance Functor Matriz where
 fmap f (M n m v) = M n m $ fmap (fmap f) v

---------------------------------------------------------------------

-- Imprimir el tamanio de la matriz
sizeStr :: Int -> Int -> String
sizeStr n m = show n ++ "x" ++ show m

-- Imprimi la matriz
prettyMatriz :: Show a => Matriz a -> String
prettyMatriz m@(M _ _ v) = unlines
    [ "( " <> unwords (fmap (\j -> 
        fill mx $ show $ m ! (i,j)) [1..ncols m]) <> " )" | i <- [1..nrows m] ]
    where
        mx = V.maximum $ fmap (V.maximum . fmap (length . show)) v
        fill k str = replicate (k - length str) ' ' ++ str

---------------------------------------------------------------------
-- Llenar la matriz de 0
zero :: Num a =>
        Int -- ^ Rows
     -> Int -- ^ Columns
     -> Matriz a
zero n m = M n m $ V.replicate n $ V.replicate m 0

-- Generador de matriz
matrix :: Int -- ^ Rows
       -> Int -- ^ Columns
       -> ((Int,Int) -> a) -- ^ Generator function
       -> Matriz a
matrix n m f = M n m $ V.generate n $ \i -> V.generate m $ \j -> f (i+1,j+1)

-- Accesando la matriz
getElem :: Int      -- ^ Row
        -> Int      -- ^ Column
        -> Matriz a -- ^ Matriz
        -> a
getElem i j (M n m v)
    | i > n || j > m = error $ "Trying to get the " ++ show (i,j) ++ " element from a "
        ++ sizeStr n m ++ " matrix."
    | otherwise = (v V.! (i-1)) V.! (j-1)

-- Alias para getElem
(!) :: Matriz a -> (Int,Int) -> a
m ! (i,j) = getElem i j m

mapRow :: (Int -> a -> a) 
        -> Int            
        -> Matriz a -> Matriz a
mapRow f r (M n m v) =
    M n m $ V.imap (\i rx -> if i+1 == r then V.imap (f . succ) rx else rx) v

getRow :: Int -> Matriz a -> V.Vector a
getRow i (M _ _ vs) = vs V.! (i-1)
---------------------------------------------------------------------
-- Para llenar Matrices
fromList :: Int -- ^ Rows
         -> Int -- ^ Columns
         -> [a] -- ^ List of elements
         -> Matriz a
fromList n m xs = fromLists $ go 1 xs
    where
        go i ys = if i > n
                  then []
                  else let (r,zs) = splitAt m ys
                       in  r : go (succ i) zs

fromLists :: [[a]] -> Matriz a
fromLists xss = M (length xss) (length $ head xss) $ V.fromList $ fmap V.fromList xss

---------------------------------------------------------------------
-- Transponer matriz
transpose :: Matriz a -> Matriz a
transpose m = matrix (ncols m) (nrows m) $ \(i,j) -> m ! (j,i)

sumarM :: Num a => Matriz a -> Matriz a -> Matriz a
sumarM (M a b v1) m2@(M z x v2) =
    M a b $ V.imap (\i rx -> V.zipWith (+) rx (getRow (i+1) m2)) v1

restarM :: Num a => Matriz a -> Matriz a -> Matriz a
restarM (M a b v1) m2@(M z x v2) =
    M a b $ V.imap (\i rx -> V.zipWith (-) rx (getRow (i+1) m2)) v1

-- Multiplicacion de Matrices
multStd :: Num a => Matriz a -> Matriz a -> Matriz a
multStd a1@(M n m _) a2@(M n' m' _)
   | m /= n' = error $ "Multiplication de matrices AxB de tamanio distinto" 
                          ++ "A: " ++ sizeStr n m ++ "  "
                          ++ "B:" ++ sizeStr n' m'
   | otherwise = multStd_ a1 a2

multStd_ :: Num a => Matriz a -> Matriz a -> Matriz a
multStd_ a1@(M n m _) a2@(M _ m' _) = matrix n m' $ \(i,j) -> sum [ a1 ! (i,k) * a2 ! (k,j) | k <- [1 .. m] ]

---------------------------------------------------------------------
--Operadores cruzados

sumMatriz :: Num a => a -> Matriz a -> Matriz a
sumMatriz = fmap . (+)

resMatriz :: Num a => a -> Matriz a -> Matriz a
resMatriz n m = undefined --fmap (- n) m  -- lo hace mal

mulMatriz :: Num a => a -> Matriz a -> Matriz a
mulMatriz = fmap . (*)

--divEntMatriz :: Num a => a -> Matriz a -> Matriz a
divEntMatriz = undefined -- fmap . (/)

modEntMatriz :: Num a => a -> Matriz a -> Matriz a
modEntMatriz = undefined -- fmap . (%)

divMatriz :: Integral a => a -> Matriz a -> Matriz a
divMatriz = undefined --fmap . (div)

modMatriz :: Integral a => a -> Matriz a -> Matriz a
modMatriz = undefined --fmap . (mod)

--Operador unario (-)
minusMatriz :: Num a => Matriz a -> Matriz a
minusMatriz matriz = fmap (* (-1)) matriz

---------------------------------------------------------------------
--Comparacion de matrices
equalMatriz :: Eq a => Matriz a -> Matriz a -> Bool
equalMatriz (M a b v) m2@(M z x v2) = 
    V.and $ V.map V.and $ V.imap (\i rx -> V.zipWith (==) rx (getRow (i+1) m2)) v

unEqMatriz :: Eq a => Matriz a -> Matriz a -> Bool
unEqMatriz (M a b v) m2@(M z x v2) = 
    V.and $ V.map V.and $ V.imap (\i rx -> V.zipWith (/=) rx (getRow (i+1) m2)) v

