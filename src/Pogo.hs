module Pogo where

import Problem


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


data Pogo = Pogo { c :: Int, d :: Int, l :: Int }

instance Problem Pogo where
  upperbound = Just . c

  brute Pogo{..}
    = takeWhile (/=d) $ iterate ((%c).(+l)) 0

  -- Worst case O(l % c)
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
               | t <- [1..]
               , x <- [o*t % l]
               , then takeWhile by x/=0
               , d-x % l == 0 ]


getT c d l h = div (h*l-d) c
getH c d l t = div (d+t*c) l

