module Problem
  ( Problem   (..)
  , Reducible (..)
  , Iso       (..)

  , module Utils
  , module Math.NumberTheory.Primes
  ) where

import Utils

import Math.NumberTheory.Primes
import Control.Applicative
import Control.Monad
import Data.Either    (fromRight)
import Data.List      (transpose)
import System.Timeout (timeout)

import Prelude hiding (id, (.))
import Control.Category
import Data.Semigroup


class Problem a where
  upperbound :: a -> Maybe Number
  upperbound = const Nothing

  -- Slow referance implementation
  brute :: a -> [Number]

  -- Referance implementation, but limit to upperbound if set
  brute' :: a -> Maybe Number
  brute' a = do
    u <- upperbound a <|> error "Upperbound not defined" -- pure (maxBound-1)
    let l = fromIntegral . length . take (fromIntegral u+1) $ brute a
    guard (l <= u) >> pure l

  -- Actually solve it using math and stuff
  clever :: a -> Either () (Maybe Number)
  clever = const $ Left ()

  -- Solve cleverly, fallback to referance
  solve :: a -> Maybe Number
  solve a = fromRight (brute' a) $ clever a


newtype Iso a b = Iso { unIso :: a }

class Reducible a b | a -> b where
  reduce :: a -> b
  reduce = snd . reduce'

  -- The reduction requires a transformation of the final answer
  reduce' :: a -> (Number -> Number, b)
  reduce' a = (id, reduce a)

instance (Reducible a b, Problem a, Problem b) => Problem (Iso a b) where
  upperbound (Iso a)
    = minimum [ upperbound a, upperbound $ reduce a ]

  clever (Iso a)
    = clever a <> if | (f,x) <- reduce' a -> fmap f <$> clever x

  brute  (unIso->reduce'->(f,x)) = f <$> brute  x
  brute' (unIso->reduce'->(f,x)) = f <$> brute' x

-----------


-- Vertify that clever == brute, give up after t time
vertifyClever :: (Problem a) => Number -> a -> IO (Either () Bool)
vertifyClever t a = do
  r <- timeout (fromIntegral t) . return $! brute' a

  return $ case r of
    Just x -> (==x) <$> clever a
    _      -> Left ()

vertifysClevers :: (Problem a, Traversable t) => Number -> t a -> IO Bool
vertifysClevers t as = all (fromRight True) <$> forM as (vertifyClever t)



-- Vertify that a problem is really isomorphic to another
vertifyIso :: (Problem a, Problem b, Reducible a b) => a -> Bool
vertifyIso a = solve a == solve (Iso a)

-- Vertify all possible problems, starting with a
vertifyIso' a
  = all vertifyIso . join $ transpose [[a, pred a ..], [succ a..]]

