module NSeqPogo where

import Problem
import Data.List


data NSeqPogo = NSeqPogo { c :: Int, d :: Int, ls :: [Int] }


instance Problem NSeqPogo where
  upperbound NSeqPogo{c=c, ls=ls}
    = Just $ c * length ls

  brute (NSeqPogo c d ls)
    = takeWhile (/=d)
    . flip scanl1 (0 : cycle ls)
    $ \a b -> mod (a+b) c

  clever NSeqPogo{c=c, d=d, ls=ls}
    | Just i <- findIndex (\x -> d == mod x c) ss = Right $ Just i
    | last ss == c = Right Nothing
    | otherwise = Left ()
   where ss = scanl (+) 0 ls

