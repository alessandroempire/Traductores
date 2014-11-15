module Matrix (
      Matrix(..)
    ) where

import qualified        Data.Vector as V
import                  Data.Monoid
import                  Control.DeepSeq

data Matrix a = M {
          nrows :: !Int
        , ncols :: !Int
        , mvect :: V.Vector (V.Vector a)
        } deriving Eq

instance Show a => Show (Matrix a) where
    show = prettyMatrix

instance Functor Matrix where
 fmap f (M n m v) = M n m $ fmap (fmap f) v

---------------------------------------------------------------------

-- Imprimir el tamanio de la matriz
sizeStr :: Int -> Int -> String
sizeStr n m = show n ++ "x" ++ show m

-- Imprimi la matriz
prettyMatrix :: Show a => Matrix a -> String
prettyMatrix m@(M _ _ v) = unlines
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
     -> Matrix a
zero n m = M n m $ V.replicate n $ V.replicate m 0

-- Generador de matriz
matrix :: Int -- ^ Rows
       -> Int -- ^ Columns
       -> ((Int,Int) -> a) -- ^ Generator function
       -> Matrix a
matrix n m f = M n m $ V.generate n $ \i -> V.generate m $ \j -> f (i+1,j+1)

-- Accesando la matriz
getElem :: Int      -- ^ Row
        -> Int      -- ^ Column
        -> Matrix a -- ^ Matrix
        -> a
getElem i j (M n m v)
    | i > n || j > m = error $ "Trying to get the " ++ show (i,j) ++ " element from a "
        ++ sizeStr n m ++ " matrix."
    | otherwise = (v V.! (i-1)) V.! (j-1)

-- Alias para getElem
(!) :: Matrix a -> (Int,Int) -> a
m ! (i,j) = getElem i j m

mapRow :: (Int -> a -> a) 
        -> Int            
        -> Matrix a -> Matrix a
mapRow f r (M n m v) =
    M n m $ V.imap (\i rx -> if i+1 == r then V.imap (f . succ) rx else rx) v

getRow :: Int -> Matrix a -> V.Vector a
getRow i (M _ _ vs) = vs V.! (i-1)
---------------------------------------------------------------------
-- Para llenar Matrices
fromList :: Int -- ^ Rows
         -> Int -- ^ Columns
         -> [a] -- ^ List of elements
         -> Matrix a
fromList n m xs = fromLists $ go 1 xs
    where
        go i ys = if i > n
                  then []
                  else let (r,zs) = splitAt m ys
                       in  r : go (succ i) zs

fromLists :: [[a]] -> Matrix a
fromLists xss = M (length xss) (length $ head xss) $ V.fromList $ fmap V.fromList xss

---------------------------------------------------------------------
-- Transponer matriz
transpose :: Matrix a -> Matrix a
transpose m = matrix (ncols m) (nrows m) $ \(i,j) -> m ! (j,i)

sumar :: Num a => Matrix a -> Matrix a -> Matrix a
sumar (M a b v1) m2@(M z x v2) =
    M a b $ V.imap (\i rx -> V.zipWith (+) rx (getRow (i+1) m2)) v1

restar :: Num a => Matrix a -> Matrix a -> Matrix a
restar (M a b v1) m2@(M z x v2) =
    M a b $ V.imap (\i rx -> V.zipWith (-) rx (getRow (i+1) m2)) v1

-- Multiplicacion de Matrices
multStd :: Num a => Matrix a -> Matrix a -> Matrix a
multStd a1@(M n m _) a2@(M n' m' _)
   | m /= n' = error $ "Multiplication de matrices AxB de tamanio distinto" 
                          ++ "A: " ++ sizeStr n m ++ "  "
                          ++ "B:" ++ sizeStr n' m'
   | otherwise = multStd_ a1 a2

multStd_ :: Num a => Matrix a -> Matrix a -> Matrix a
multStd_ a1@(M n m _) a2@(M _ m' _) = matrix n m' $ \(i,j) -> sum [ a1 ! (i,k) * a2 ! (k,j) | k <- [1 .. m] ]

---------------------------------------------------------------------
--Operadores cruzados

sumMatrix :: Num a => a -> Matrix a -> Matrix a
sumMatrix = fmap . (+)

resMatrix :: Num a => a -> Matrix a -> Matrix a
resMatrix = fmap . (-)

mulMatrix :: Num a => a -> Matrix a -> Matrix a
mulMatrix = fmap . (*)

--divEntMatrix :: Num a => a -> Matrix a -> Matrix a
--divEntMatrix = fmap . (/)

--modEntMatrix :: Num a => a -> Matrix a -> Matrix a
--modEntMatrix = fmap . (%)

--divMatrix :: Num a => a -> Matrix a -> Matrix a
--divMatrix = fmap . (div)

--modMatrix :: Num a => a -> Matrix a -> Matrix a
--modMatrix = fmap . (-)

--Operador unario (-)
--minusMatrix :: Num a => Matrix a -> Matrix a
--minusMatrix = fmap . (- 1)

---------------------------------------------------------------------

--
equalMatrix :: Num a => Matrix a -> Matrix a -> Bool
equalMatrix = undefined

unEqMatrix :: Num a => Matrix a -> Matrix a -> Bool
unEqMatrix = undefined
