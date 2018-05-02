module PogoMult where

import Problem
import Utils
import qualified Pogo as P

import Data.Maybe (catMaybes)

-- PogoMult is regular pogo, but with any number of candies.

data PogoMult = PogoMult
  { c  :: Number   -- Circle circumference
  , l  :: Number   -- Jump length
  , ds :: [Number] -- Initial distance to candies
  } deriving (Eq, Show)


instance Problem PogoMult where
  brute = undefined

  -- O(N * log C)
  brute' PogoMult{..}
    | null ss = Nothing
    | otherwise = Just $ minimum ss
    where g  = gcd l c
          ss = catMaybes [ solve $ P.Pogo c d l | d <- ds, mod d g == 0 ]
