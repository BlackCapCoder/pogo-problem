module NSeqPiñata' where

import qualified Data.Map as M
import Math.NumberTheory.Primes
import Data.Maybe
import Control.Lens

import Problem


data NSeqPiñata
  = NSeqPiñata' { c :: Int, js :: [(Int, Int)] } -- (l, p)
  deriving (Eq, Ord, Show)

instance Problem NSeqPiñata where
  brute NSeqPiñata'{..}
    | l <- length js
    = map (\x -> snd x^._2)
    . takeWhile (\(i, b) -> not $ b^._1 && i%l == 0 )
    . zip (cycle [0..l])
    . flip iterate (False, 0, M.empty, cycle js)
    $ \(b, x, m, (l,p):js) ->
      let x' = x+l % c
          p' = x+p % c
          m' = M.insert p' (fromMaybe True $ not <$> M.lookup p' m) m
      in (fromMaybe False $ M.lookup x' m', x', m', js)

  clever NSeqPiñata'{..}
    | c % sl == 0, 0 `notElem` p = Right Nothing
    | otherwise = Left ()
    where l = map fst js
          p = map snd js
          sl = sum l

bruteNSP' NSeqPiñata'{..}
  | l <- length js
  = last
  . map (\x -> snd x^._3)
  . takeWhile (\(i, b) -> not $ b^._1 && i%l == 0 )
  . zip (cycle [0..l])
  . flip iterate (False, 0, M.empty, cycle js)
  $ \(b, x, m, (l,p):js) ->
    let x' = x+l % c
        p' = x+p % c
        m' = M.insert p' (fromMaybe True $ not <$> M.lookup p' m) m
    in (fromMaybe False $ M.lookup x' m', x', m', js)
