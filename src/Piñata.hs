{-# LANGUAGE MultiWayIf, LambdaCase, MultiParamTypeClasses #-}
module Piñata where

import qualified Data.Map as M
import Math.NumberTheory.Primes

import System.Timeout
import Control.Monad
import Data.Maybe

import Problem
import Pogo (Pogo (Pogo))
import Data.List (find)


{-

  You are riding a piñata on the surface of a circle of some integer circumference (C).
  The piñata only jumps, and it only jumps some integer length (L).
  At every jump, the piñata drops a single candy at some point (P) during the jump. (P >= 0, P < L)
  If a candy lands on another candy they annihilate each other and emit a photon.
  Will you ever land on a candy, and if so, how many jumps (H) will it take?

-}


data Piñata = Piñata { c :: Int, l :: Int, p :: Int }
            deriving (Eq, Ord, Show)

-- GHC optimizes away the find, woo!
instance Enum Piñata where
  toEnum i
    | Just c <- pred <$> find ((>i).f) [0..]
    , Just l <- find ((>(i-f c)).g) [0..]
    = Piñata (c+2) l (i - f c - g (l-1))
    where f n = div (n*(n+1)*(n+2)) 6
          g n = div (n*(n+1)      ) 2

  fromEnum (Piñata c l p)
    = f (c-2) + g (l-1) + p
    where f n = div (n*(n+1)*(n+2)) 6
          g n = div (n*(n+1)      ) 2

instance Reducible Piñata Pogo where
  reduce (Piñata c l p) = Pogo c p l
  -- vertifyIso' fails when p=0


instance Problem Piñata where
  upperbound = Just . c

  brute Piñata{c=c, l=l, p=p}
    = map (\(_,x,_) -> x)
    . takeWhile (\(b, _, _) -> not b)
    . flip iterate (False, 0, M.empty)
    $ \(b, x, m) ->
      let x' = mod (x+l) c
          p' = mod (x+p) c
          m' = if | Just _ <- M.lookup p' m -> M.update (pure . not) p' m
                  | otherwise -> M.insert p' True m

      in if | Just b' <- M.lookup x' m' -> (b', x', m')
            | otherwise -> (False, x', m')

  clever Piñata{c=c, l=l, p=p}
    | p == l = Right $ Just 1
    | l == 0 = Right Nothing
    | m == 0, p /= 0 = Right Nothing
    | x /= 1, p == 0 = Right . Just $ div c x
    | mod p o == 0, p >= o = Right . Just $ (d+1) * div (mod p c) o
    | otherwise = Left ()
    where x = gcd c l
          (d,m) = divMod c l
          o = l - m
