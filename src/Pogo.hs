module Pogo where

import Problem
import Debug.Trace
import Data.List (find)
import Data.Maybe


{-

  I am standing on a pogo stick at the surface of a circle with an integer circumference C.
  An integer distance away from me D is a piece of candy.
  My pogo stick can only jump in one direction, and only some specific integer length L.
  If I were to pogo forever, would I ever land on the candy, and if so, how many jumps would it take?

Examples:
  (C=10, D=1, L=2) -> impossible
  (C=23, D=3, L=5) -> 19 jumps

C = number of spots on the circle
L = distance of one hop
D = distance from starting point to the candy
H = number of hops (answer)
T = number of times passed all the way around the circle

H*L  how from spots the starting point on the Hth hop
T*C  how many spots take you back to the starting point
        on the Tth time around the circle

D = H*L - T*C       you land on the candy after H hops takes you T times around the circle
D = H*L (modulo C)  another way to express the same, without caring about specific T

-}

data Pogo = Pogo { c :: Number, d :: Number, l :: Number }
          deriving (Eq, Ord, Show)


instance Enum Pogo where
  toEnum i'
    | Just c <- pred <$> find ((>i).f) [0..]
    , Just l <- find ((>(i-f c)).g) [0..]
    = Pogo (c+2+1) (i - f c - g (l-1)+1) (l+1)
    where f n = div (n*(n+1)*(n+2)) 6
          g n = div (n*(n+1)      ) 2
          i   = fromIntegral i

  fromEnum Pogo{..}
    = fromIntegral $ f (c-2-1) + g (l-1-1) + d - 1
    where f n = div (n*(n+1)*(n+2)) 6
          g n = div (n*(n+1)      ) 2

-----


instance Problem Pogo where
  upperbound = Just . c

  brute Pogo{..}
    = takeWhile (/=d) $ iterate ((%c).(+l)) 0

  -- Worst case O(min(l,c))
  brute' p@Pogo{..}
    | l < 0 = brute' p { d=c-d, l = -l }
    | d < 0 = brute' p { d=c+d }
    | l > c = brute' p { l=l%c }

    | y  == 0     = Just x
    | cm == 0     = Nothing

    | (h:_) <- os = Just h
    | otherwise   = Nothing

    where (x,y)  = divMod d l
          (z,cm) = divMod c l

          -- How much i overshot the edge by
          o = l*z+l % c

          -- Exhaustively search all future overshots
          os = [ getH c d l t
               | t  <- [1..]
               , ot <- [o*t % l]
               , then takeWhile by ot/=0
               , d-ot % l == 0 ]


  clever Pogo{..}

    | d > l = Left ()

    -- Pogo is equivilant to finding integer solutions
    -- to the linear equation `lh - ct = d`

    -- Bézout's Identity
    | mod d g /= 0 = Right Nothing

    -- Factorize to get gcd 1
    | g > 1 = clever Pogo { c = c `div` g, d = d `div` g, l = l `div` g }

    -- Solve it!
    | (x,y) <- euc (l) (-c)
    , x' <- x*d
    , y' <- y*d
    , f <- \m -> (x' + m * c, y' - m * l)
    , mx <- div x' (-c)
    , my <- div y' l
    , mx' <- mx - signum (fst $ f mx)
    , my' <- my + signum (snd $ f my)
    , h1 <- abs . fst $ f mx
    , h2 <- abs . fst $ f mx'
    , t1 <- abs . snd $ f my
    , t2 <- abs . snd $ f my'
    = if getT c d l h1 `elem` [t1, t2]
        then Right $ Just h1
        else Right $ Just h2

    where g = gcd l c


----


-- euclidian algorithm
euc a 0 = (1, 0)
euc a b = (t, s - q * t)
  where (q, r) = quotRem a b
        (s, t) = euc b r


getT c d l h = div (h*l-d) c
getH c d l t = div (d+t*c) l
