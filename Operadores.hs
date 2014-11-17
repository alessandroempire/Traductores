module Operadores (
    ) where

import          Prelude hiding (div, mod)


-- m / n
(%) :: Double -> Double -> Double
m % n = reducer $ m - d * n
    where 
        d = fromIntegral (floor (m / n)) :: Double

-- m div n
div :: Double -> Double -> Double
div m n = fromIntegral (truncate (m / n)) :: Double

-- m mod n
mod :: Double -> Double -> Double
mod m n = fromIntegral (truncate (m % n)) :: Double

--Auxiliar
reducer :: Double -> Double
reducer n = (fromInteger $ round $ n * (10^2) :: Double) / (10.0^^2)
