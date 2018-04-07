module NSeqPogo' where

import Problem
import Pogo (Pogo (..))
import Data.List


data NSeqPogo' = NSeqPogo' { c :: Int, d :: Int, ls :: [Int] }


instance Problem NSeqPogo' where
  upperbound (NSeqPogo' c d ls)
    = (* length ls) . upperbound . Pogo c d $ sum ls

  -- brute (NSeqPogo' c d ls)
  --   | q <- length ls
  --   = map snd
  --   . takeWhile (\(i, x) -> mod i q /= 0 || x/=d)
  --   . zip [0..]
  --   . flip scanl1 (0 : cycle ls)
  --   $ \a b -> mod (a+b) c

  brute (NSeqPogo' c d ls)
    = map (* length ls) . brute . Pogo c d $ sum ls

  clever (NSeqPogo' c d ls)
    = fmap (fmap (* length ls))
    . clever . Pogo c d $ sum ls
