{-# LANGUAGE MultiWayIf, LambdaCase, TupleSections #-}
module Piñata where

import qualified Data.Map as M
import Data.Function
import Math.NumberTheory.Primes
import System.Timeout
import Control.Monad
import Data.Maybe

{-

  You are riding a piñata on the surface of a circle of some integer circumference (C).
  The piñata only jumps, and it only jumps some integer length (L).
  At every jump, the piñata drops a single candy at some point (P) during the jump. (P >= 0, P < L)
  If a candy lands on another candy they annihilate each other and emit a photon.
  Will you ever land on a candy, and if so, how many jumps (H) will it take?

0 <= P <= L <= C

Impossible problem: (C=10, L=2, P=1)

-}

brute c l p = flip fix (0,0, M.empty) $ \r (x,h,m) ->
  let x' = mod (x+l) c
      p' = mod (x+p) c
      m' = if | Just _ <- M.lookup p' m -> M.update (pure . not) p' m
              | otherwise -> M.insert p' True m

  in if | Just True <- M.lookup x' m' -> (x',h+1,m')
        | otherwise -> r (x',h+1,m')

bruteH c l p | (_,h,_) <- brute c l p = h


brute' c l p = flip fix (0,0, M.empty) $ \r (x,h,m) ->
  let x' = mod (x+l) c
      p' = mod (x+p) c
      m' = if | Just _ <- M.lookup p' m -> M.update (pure . not) p' m
              | otherwise -> M.insert p' True m

  in if | h > c -> Nothing
        | Just True <- M.lookup x' m' -> Just (x',h+1,m')
        | otherwise -> r (x',h+1,m')

bruteH' c l p = do (_,h,_) <- brute' c l p; return h


clever :: Int -> Int -> Int -> Either () (Maybe Int)
clever c l p
  | p == l = Right $ Just 1
  | l == 0 = Right Nothing
  | m == 0, p /= 0 = Right Nothing
  | x /= 1, p == 0 = Right . Just $ div c x
  | mod p o == 0, p >= o = Right . Just $ (d+1) * div (mod p c) o
  | otherwise = Left ()
 where x = gcd c l
       (d,m) = divMod c l
       o = l - m


check c l p = (bruteH c l p, clever c l p)

getO c l = l - mod c l

brutes n = fmap catMaybes
         . forM (take n [ (c,l,p) | c <- [1..], l <- [1..c-1], p <- [0..l-1] ])
         $ \(c,l,p) ->
  timeout 100 $ fmap (c<) . return $! bruteH c l p
