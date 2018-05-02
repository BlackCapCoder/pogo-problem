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

instance Reducible NSeqPogo' Pogo where
  reduce' NSeqPogo'{..} = ((*n), Pogo c d s)

instance Problem NSeqPogo' where

