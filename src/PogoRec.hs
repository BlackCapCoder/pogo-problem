module PogoRec where

import Problem
import Utils

{-

In PogoRec, every odd jump is a pogo problem. It is equivalent to BoolFuck loops with the following structure:
  [ [>>] >>> [>>>>] >> ]

-}

data PogoRec = PogoRec
  { c  :: Number   -- Circle circumference
  , d  :: Number   -- Initial distance to candy
  , ls :: [Number] -- Jump lengths
  , ps :: [Number] -- Pogo problems
  } deriving (Eq, Show)


