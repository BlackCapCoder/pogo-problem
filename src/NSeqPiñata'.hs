module NSeqPiñata' where

import qualified Data.Set as S
import Math.NumberTheory.Primes
import Data.Maybe
import Data.List
import Control.Applicative

import Problem
import qualified Piñata as P


data NSeqPiñata' = NSeqPiñata'
  { c  :: Number   -- circumference
  , ls :: Number   -- Sum of jump lengths
  , ds :: [Number] -- List of drop points
  } deriving (Eq, Ord, Show)

instance Problem NSeqPiñata' where
  upperbound NSeqPiñata' {..}
    = Just $ c ^ length ds

  brute NSeqPiñata' {..}
    | any (>ls) ds = error "Invalid!"
    | otherwise
    = id
    . concatMap (:replicate (length ds-1) 0)
    . map fst
    . takeWhile (not . uncurry S.member)
    . flip iterate (0, mempty)
    $ \(i, m) ->
        let f ((i+) -> flip mod c -> x) acc
              | S.member x acc = S.delete x acc
              | otherwise      = S.insert x acc
        in (mod (i+ls) c, foldr f m ds)
