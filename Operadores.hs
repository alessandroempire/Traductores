module Operadores (
     (%)
    , div
    , mod
    ) where

import          Prelude         hiding (div, mod)

-- m / n
{-
--(%) :: Double -> Double -> Double
--(%) :: (Fractional a) => a -> a -> a
(%) :: (RealFrac a) => a -> a -> a
m % n = m - ((fromIntegral (d n m)) * n) 
 
      --d = toInteger (n / m)

d :: (Integral b, RealFrac a) => a -> a -> b
d m n = floor (n / m )

--d1 m n ::
d1 m n = fromIntegral (d m n) 
 -}

--aux :: (Fractional a ) => a -> a -> a
(%) :: (Fractional a, Real a) => a -> a -> a
m % n = m - (fromIntegral (ay m n )) * n

ay :: (Fractional a, Integral b, Real a) => a -> a -> b
ay m n = floor $ toRational (m/n)


-- m div n
div :: Double -> Double -> Double
div m n = undefined -- fromIntegral (truncate (m / n)) :: Double

-- m mod n
mod :: Double -> Double -> Double
mod m n = undefined --fromIntegral (truncate (m % n)) :: Double

--Auxiliar
reducer :: Double -> Double
reducer n = (fromInteger $ round $ n * (10^2) :: Double) / (10.0^^2)
