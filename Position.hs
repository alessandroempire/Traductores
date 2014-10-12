module Position
    ( Position(..)
    , defaultPosn
    ) where

-- Position(Row, Column)
newtype Position = Posn (Int, Int)
    deriving (Bounded, Eq)

instance Ord Position where
    compare (Posn (r1, c1)) (Posn (r2, c2)) =
        case compare r1 r2 of
            EQ    -> compare c1 c2
            other -> other

instance Show Position where
    show (Posn tuple) = case tuple of
        (r,0) -> "línea " ++ show r
        (r,c) -> "línea " ++ show r ++ ", columna " ++ show c

defaultPosn :: Position
defaultPosn = Posn (0,0)

row :: Position -> Int
row (Posn (r,_)) = r

col :: Position -> Int
col (Posn (_,c)) = c

