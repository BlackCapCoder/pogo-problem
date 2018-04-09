module NSeqPogo' where

import Problem
import Pogo (Pogo (Pogo))
import Data.List


data NSeqPogo' = NSeqPogo'
  { c :: Int -- Circle circumference
  , d :: Int -- Distance to candy
  , s :: Int -- Sum of jump lengths
  , n :: Int -- Number of jumps in the sequence
  }

instance Problem NSeqPogo' where
  upperbound NSeqPogo'{..}
    = (*n) <$> upperbound (Pogo c d s)

  brute NSeqPogo'{..}
    = (*n) <$> brute (Pogo c d s)

  clever NSeqPogo'{..}
    = fmap (*n) <$> clever (Pogo c d s)

  -- brute (NSeqPogo' c d ls)
  --   | q <- length ls
  --   = map snd
  --   . takeWhile (\(i, x) -> mod i q /= 0 || x/=d)
  --   . zip [0..]
  --   . flip scanl1 (0 : cycle ls)
  --   $ \a b -> mod (a+b) c
