module Matriz (
      Matriz(..)
    , zero
    , fromLists
    --Operaciones
    , transpose
    , sumarM 
    , restarM 
    , multStd
    , multStrassen
    , multStrassenMixed
    -- Operadores cruzados
    , sumMatriz
    , mulMatriz
    , divEntNM
    , divEntMN
    , modEntMatriz
    , divMatriz
    , modMatriz
    , minusMatriz
    --Comparacion de matrices
    , equalMatriz
    , unEqMatriz
    ) where        

import qualified        Operadores as O

import                  Data.Monoid
import                  Control.DeepSeq
import qualified        Data.Vector as V
import qualified        Data.Vector.Mutable as MV
import                  Control.Monad.Primitive (PrimMonad,PrimState)
import                  Data.List (maximumBy)
import                  Prelude

data Matriz a = M {
          nrows :: !Int
        , ncols :: !Int
        , mvect :: V.Vector (V.Vector a)
        } deriving Eq

instance Show a => Show (Matriz a) where
    show = prettyMatriz

instance Functor Matriz where
 fmap f (M n m v) = M n m $ fmap (fmap f) v

instance Num a => Num (Matriz a) where
 fromInteger = M 1 1 . V.singleton . V.singleton . fromInteger
 negate = fmap negate
 abs = fmap abs
 signum = fmap signum
 -- Addition of matrices.
 (M n m v) + (M n' m' v')
   -- Checking that sizes match...
   | n /= n' || m /= m' = error $ "Addition of " ++ sizeStr n m ++ " and "
                               ++ sizeStr n' m' ++ " matrices."
   -- Otherwise, trivial zip.
   | otherwise = M n m $ V.zipWith (V.zipWith (+)) v v'
 -- Multiplication of matrices.
 (*) = multStrassenMixed

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
zero :: Int -- ^ Rows
     -> Int -- ^ Columns
     -> a   -- Tipo de la matriz
     -> Matriz a
zero n m t = M n m $ V.replicate n $ V.replicate m t

zero' :: Num a =>
     Int -- ^ Rows
  -> Int -- ^ Columns
  -> Matriz a
zero' n m = M n m $ V.replicate n $ V.replicate m 0

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

-- Otro metodo
multStrassenMixed :: Num a => Matriz a -> Matriz a -> Matriz a
multStrassenMixed a1@(M n m _) a2@(M n' m' _)
   | m /= n' = error $ "Multiplication of " ++ sizeStr n m ++ " and "
                    ++ sizeStr n' m' ++ " matrices."
   | n < strmixFactor = multStd_ a1 a2
   | otherwise =
       let mx = maximum [n,m,n',m']
           n2 = if even mx then mx else mx+1
           b1 = extendTo n2 n2 a1
           b2 = extendTo n2 n2 a2
       in  submatrix 1 n 1 m' $ strassenMixed b1 b2

extendTo :: Num a
         => Int -- ^ Minimal number of rows.
         -> Int -- ^ Minimal number of columns.
         -> Matriz a -> Matriz a
extendTo n m a = a''
 where
  n'  = n - nrows a
  a'  = if n' <= 0 then a  else a  <-> zero' n' (ncols a)
  m'  = m - ncols a
  a'' = if m' <= 0 then a' else a' <|> zero' (nrows a') m'

submatrix :: Int    -- ^ Starting row /r1/
             -> Int -- ^ Ending row /r2/
          -> Int    -- ^ Starting column
             -> Int -- ^ Ending column
          -> Matriz a
          -> Matriz a
{-# INLINE submatrix #-}
submatrix r1 r2 c1 c2 (M _ _ vs) = M r' c' $ V.map (V.unsafeSlice (c1-1) c') $ V.unsafeSlice (r1-1) r' vs
  where
   r' = r2-r1+1
   c' = c2-c1+1

strmixFactor :: Int
strmixFactor = 75

-- | Strassen's mixed algorithm.
strassenMixed :: Num a => Matriz a -> Matriz a -> Matriz a
strassenMixed a@(M r _ _) b
 | r < strmixFactor = multStd_ a b
 | odd r = let r' = r + 1
               a' = extendTo r' r' a
               b' = extendTo r' r' b
           in  submatrix 1 r 1 r $ strassenMixed a' b'
 | otherwise = joinBlocks (c11,c12,c21,c22)
 where
  -- Size of the subproblem is halved.
  n = quot r 2
  -- Split of the original problem into smaller subproblems.
  (a11,a12,a21,a22) = splitBlocks n n a
  (b11,b12,b21,b22) = splitBlocks n n b
  -- The seven Strassen's products.
  p1 = strassenMixed (a11 + a22) (b11 + b22)
  p2 = strassenMixed (a21 + a22)  b11
  p3 = strassenMixed  a11        (b12 - b22)
  p4 = strassenMixed        a22  (b21 - b11)
  p5 = strassenMixed (a11 + a12)        b22
  p6 = strassenMixed (a21 - a11) (b11 + b12)
  p7 = strassenMixed (a12 - a22) (b21 + b22)
  -- Merging blocks
  c11 = p1 + p4 - p5 + p7
  c12 = p3 + p5
  c21 = p2 + p4
  c22 = p1 - p2 + p3 + p6

joinBlocks :: (Matriz a,Matriz a
              ,Matriz a,Matriz a)
           ->  Matriz a
{-# INLINE joinBlocks #-}
joinBlocks (tl,tr,bl,br) = (tl <|> tr)
                               <->
                           (bl <|> br)

splitBlocks :: Int      -- ^ Row of the splitting element.
            -> Int      -- ^ Column of the splitting element.
            -> Matriz a -- ^ Matriz to split.
            -> (Matriz a,Matriz a
               ,Matriz a,Matriz a) -- ^ (TL,TR,BL,BR)
{-# INLINE splitBlocks #-}
splitBlocks i j a@(M n m _) = ( submatrix    1  i 1 j a , submatrix    1  i (j+1) m a
                              , submatrix (i+1) n 1 j a , submatrix (i+1) n (j+1) m a )

(<->) :: Matriz a -> Matriz a -> Matriz a
{-# INLINE (<->) #-}
(M n m v) <-> (M n' m' v')
 | m /= m' = error $ "Vertical join of " ++ sizeStr n m ++ " and "
                  ++ sizeStr n' m' ++ " matrices."
 | otherwise = M (n+n') m $ v V.++ v'

(<|>) :: Matriz a -> Matriz a -> Matriz a
{-# INLINE (<|>) #-}
(M n m vs) <|> (M n' m' vs')
 | n /= n' = error $ "Horizontal join of " ++ sizeStr n m ++ " and "
                  ++ sizeStr n' m' ++ " matrices."
 | otherwise = M n (m+m') $ V.zipWith (V.++) vs vs'


--otro metodo
-- | Strassen's matrix multiplication.
multStrassen :: Num a => Matriz a -> Matriz a -> Matriz a
multStrassen a1@(M n m _) a2@(M n' m' _)
   | m /= n' = error $ "Multiplication of " ++ sizeStr n m ++ " and "
                    ++ sizeStr n' m' ++ " matrices."
   | otherwise =
       let mx = maximum [n,m,n',m']
           n2  = first (>= mx) $ fmap (2^) [(0 :: Int)..]
           b1 = extendTo n2 n2 a1
           b2 = extendTo n2 n2 a2
       in  submatrix 1 n 1 m' $ strassen b1 b2

first :: (a -> Bool) -> [a] -> a
first f = go
 where
  go (x:xs) = if f x then x else go xs
  go [] = error "first: no element match the condition."

-- | Strassen's algorithm over square matrices of order @2^n@.
strassen :: Num a => Matriz a -> Matriz a -> Matriz a
-- Trivial 1x1 multiplication.
strassen (M 1 1 v) (M 1  1  v') = M 1 1 $ V.zipWith (V.zipWith (*)) v v'
-- General case guesses that the input matrices are square matrices
-- whose order is a power of two.
strassen a b = joinBlocks (c11,c12,c21,c22)
 where
  -- Size of the subproblem is halved.
  n = div (nrows a) 2
  -- Split of the original problem into smaller subproblems.
  (a11,a12,a21,a22) = splitBlocks n n a
  (b11,b12,b21,b22) = splitBlocks n n b
  -- The seven Strassen's products.
  p1 = strassen (a11 + a22) (b11 + b22)
  p2 = strassen (a21 + a22)  b11
  p3 = strassen  a11        (b12 - b22)
  p4 = strassen        a22  (b21 - b11)
  p5 = strassen (a11 + a12)        b22
  p6 = strassen (a21 - a11) (b11 + b12)
  p7 = strassen (a12 - a22) (b21 + b22)
  -- Merging blocks
  c11 = p1 + p4 - p5 + p7
  c12 = p3 + p5
  c21 = p2 + p4
  c22 = p1 - p2 + p3 + p6

---------------------------------------------------------------------
--Operadores cruzados

sumMatriz :: Num a => a -> Matriz a -> Matriz a
sumMatriz = fmap . (+)

-- resta de matriz
-- 3 - m == 3 + minusMatriz m
-- m - 3 = m + (-3)

mulMatriz :: Num a => a -> Matriz a -> Matriz a
mulMatriz = fmap . (*)

-- Number / matrix
divEntNM ::  Double -> Matriz Double -> Matriz Double
divEntNM = fmap . (/)

-- matrix / Number
divEntMN :: Double -> Matriz Double -> Matriz Double
divEntMN num (M a b v1) =
    M a b $ V.imap (\i rx -> V.map (/num) rx) v1

-- Number % matrix
--modEntMatriz :: (Integral a) => a -> Matriz a -> Matriz a
--modEntMatriz :: Double -> Matriz Double -> Matriz Double
modEntMatriz = undefined --fmap . (%)

-- matrix % Number

--divMatriz :: Integral a => a -> Matriz a -> Matriz a
divMatriz :: Double -> Matriz Double -> Matriz Double
divMatriz = fmap . (O.div)

modMatriz :: Double -> Matriz Double -> Matriz Double
modMatriz = fmap . (O.mod)

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

---------------------------------------------------------------------

--Operaciones aux

