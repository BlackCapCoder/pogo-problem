module NSeqPogo where

import Problem


data NSeqPogo = NSeqPogo { c :: Int, d :: Int, ls :: [Int] }


instance Problem NSeqPogo where
  brute (NSeqPogo c d ls)
    = takeWhile (/=d)
    . map fst
    . flip iterate ( 0, cycle ls )
    $ \(a, x:xs) -> (mod (a+x) c, xs)
