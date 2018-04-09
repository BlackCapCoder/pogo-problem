module NSeqPogo where

import Problem
import Data.List


data NSeqPogo = NSeqPogo { c :: Int, d :: Int, ls :: [Int] }


instance Problem NSeqPogo where
  upperbound NSeqPogo{c, ls}
    = Just $ c * length ls

  brute NSeqPogo{..}
    = takeWhile (/=d)
    . flip scanl1 (0 : cycle ls)
    $ \a b -> a+b % c

  clever NSeqPogo{..}
    | Just i <- findIndex (\x -> d == x%c) ss = Right $ Just i
    | last ss == c = Right Nothing
    | otherwise = Left ()
   where ss = scanl (+) 0 ls

