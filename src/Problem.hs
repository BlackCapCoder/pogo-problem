module Problem
  ( Problem   (..)
  , Reducible (..)
  , Iso       (..)

  , module Utils
  ) where

import Utils

import Control.Applicative
import Control.Monad
import Data.Either    (fromRight)
import Data.List      (transpose)
import System.Timeout (timeout)


class Problem a where
  upperbound :: a -> Maybe Number
  upperbound = const Nothing

  -- Slow referance implementation
  brute :: a -> [Number]

  -- Referance implementation, but limit to upperbound if set
  brute' :: a -> Maybe Number
  brute' a = do
    u <- upperbound a <|> pure (maxBound-1)
    let l = length . take (u+1) $ brute a
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

instance (Reducible a b, Problem a, Problem b) => Problem (Iso a b) where
  upperbound (Iso a)
    = minimum [ upperbound a, upperbound (reduce a) ]

  clever (Iso a)
    = fromRight (clever $ reduce a) $ pure <$> clever a

  brute  = brute  . reduce . unIso
  brute' = brute' . reduce . unIso


-----------


-- Vertify that clever == brute, give up after t time
vertifyClever :: (Problem a) => Number -> a -> IO (Either () Bool)
vertifyClever t a = do
  r <- timeout t . return $! brute' a

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

