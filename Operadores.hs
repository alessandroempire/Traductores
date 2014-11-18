module Operadores (
     (%)
    , div
    , mod
    ) where

import          Prelude         hiding (div, mod)

(%) :: (Fractional a, Real a) => a -> a -> a
m % n = reducer $ m - (fromIntegral (aux m n )) * n

aux :: (Fractional a, Integral b, Real a) => a -> a -> b
aux m n = floor $ toRational (m/n)

-- m div n
div :: (Fractional a, Real a) => a -> a -> a
div m n = fromIntegral (truncate (toRational(m / n)))

-- m mod n
mod :: (Fractional a, Real a) => a -> a -> a
mod m n = fromIntegral (truncate (toRational (m % n)))

--Auxiliar
reducer :: (Fractional a, Real a) => a -> a
reducer n = (fromInteger $ round $ (toRational n) * (10^2)) / (10.0^^2)
