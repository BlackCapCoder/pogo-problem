module Piñata where

import qualified Data.Map as M
import Math.NumberTheory.Primes

import Control.Monad
import Data.Maybe

import Utils
import Problem
import Pogo (Pogo (Pogo))
import Data.List (find)


{-

  You are riding a piñata on the surface of a circle of some integer circumference (C).
  The piñata only jumps, and it only jumps some integer length (L).
  At every jump, the piñata drops a single candy at some point (P) during the jump. (P >= 0, P < L)
  If a candy lands on another candy they annihilate each other and emit a photon.
  Will you ever land on a candy, and if so, how many jumps (H) will it take?

-}


data Piñata = Piñata { c :: Number, l :: Number, p :: Number }
            deriving (Eq, Ord, Show)

-- vertifyIso' fails when p=0
instance Reducible Piñata Pogo where
  reduce Piñata{..} = Pogo c p l

instance Problem Piñata where
