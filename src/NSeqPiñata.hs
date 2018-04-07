{-# LANGUAGE MultiWayIf, LambdaCase #-}
module NSeqPiñata where

import qualified Data.Map as M
import Math.NumberTheory.Primes

import Problem


data NSeqPiñata
  = NSeqPiñata { c :: Int, js :: [(Int, Int)] } -- (l, p)
  deriving (Eq, Ord, Show)


instance Problem NSeqPiñata where
  brute NSeqPiñata{c=c, js=js}
    = map (const 0)
    . takeWhile (\(b, _, _, _) -> not b)
    . flip iterate (False, 0, M.empty, cycle js)
    $ \(b, x, m, (l,p):js) ->
      let x' = mod (x+l) c
          p' = mod (x+p) c
          m' = if | Just _ <- M.lookup p' m -> M.update (pure . not) p' m
                  | otherwise -> M.insert p' True m

      in if | Just b' <- M.lookup x' m' -> (b', x', m', js)
            | otherwise -> (False, x', m', js)
