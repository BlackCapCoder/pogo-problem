module NSeqPiñata where

import qualified Data.Map as M
import Math.NumberTheory.Primes
import Data.Maybe
import Control.Lens

import Problem


data NSeqPiñata
  = NSeqPiñata { c :: Int, js :: [(Int, Int)] } -- (l, p)
  deriving (Eq, Ord, Show)


instance Problem NSeqPiñata where
  brute NSeqPiñata{..}
    = map (const 0)
    . takeWhile (\q -> not $ q^._1)
    . flip iterate (False, 0, M.empty, cycle js)
    $ \(b, x, m, (l,p):js) ->
      let x' = x+l % c
          p' = x+p % c
          m' = M.insert p' (fromMaybe True $ not <$> M.lookup p' m) m
      in (fromMaybe False $ M.lookup x' m', x', m', js)
