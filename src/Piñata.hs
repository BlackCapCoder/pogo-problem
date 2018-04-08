{-# LANGUAGE MultiWayIf, LambdaCase, TupleSections #-}
module Piñata where

import qualified Data.Map as M
import Math.NumberTheory.Primes

import System.Timeout
import Control.Monad
import Data.Maybe

import Problem


{-

  You are riding a piñata on the surface of a circle of some integer circumference (C).
  The piñata only jumps, and it only jumps some integer length (L).
  At every jump, the piñata drops a single candy at some point (P) during the jump. (P >= 0, P < L)
  If a candy lands on another candy they annihilate each other and emit a photon.
  Will you ever land on a candy, and if so, how many jumps (H) will it take?

0 <= P <= L <= C

Impossible problem: (C=10, L=2, P=1)

-}


data Piñata = Piñata { c :: Int, l :: Int, p :: Int }
            deriving (Eq, Ord, Show)


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


instance Enum Piñata where
  toEnum i
    | (c,l,p) <- [ (c,l,p) | c <- [1..], l <- [1..c-1], p <- [0..l-1] ] !! i
    = Piñata c l p

  fromEnum = undefined


pin x@(Piñata c l p) =
  let Just u = upperbound x
      bs = take u $ brute x
  in  if length bs == u then Nothing else Just $ mod (l + last bs) c

vertifyPin t a = do
  -- r <- timeout t . return $! pin a
  r <- pure . return $! pin a

  return $ case r of
    Just x -> (p a ==) <$> x
    _      -> Nothing

vertifyPins t n = do
  xs <- forM (toEnum <$> [0..n]) $ vertifyPin t
  return $ and $ catMaybes xs
