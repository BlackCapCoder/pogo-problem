{-# LANGUAGE FunctionalDependencies, MultiWayIf #-}
module Problem where

import System.Timeout
import Control.Monad
import Data.Either
import Data.List (transpose)


class Problem a where
  upperbound :: a -> Maybe Int
  upperbound = const Nothing

  -- Slow referance implementation
  brute :: a -> [Int]

  -- Referance implementation, but limit to upperbound if set
  brute' :: a -> Maybe Int
  brute' a
    | Just u <- upperbound a
    , l      <- length . take (u+1) $ brute a
    = if l > u then Nothing else Just l
    | otherwise = Just . length $ brute a

  -- Actually solve it using math and stuff
  clever :: a -> Either () (Maybe Int)
  clever = const $ Left ()

  -- Solve cleverly, fallback to referance
  solve :: a -> Maybe Int
  solve a
    = case clever a of
        Right x -> x
        Left _  -> brute' a


-----------


-- Vertify that clever == brute, give up after t time
vertifyClever :: (Problem a) => Int -> a -> IO (Either () Bool)
vertifyClever t a = do
  r <- timeout t . return $! brute' a

  return $ case r of
    Just x -> (==x) <$> clever a
    _      -> Left ()

vertifysClevers :: (Problem a, Traversable t) => Int -> t a -> IO Bool
vertifysClevers t as = all (fromRight True) <$> forM as (vertifyClever t)


------------


newtype Iso a b = Iso { unIso :: a }

class Reducible a b | a -> b where
  reduce :: a -> b

instance (Reducible a b, Problem a, Problem b) => Problem (Iso a b) where
  upperbound (Iso a)
    = foldr1 min [ upperbound a
                 , upperbound (reduce a) ]

  clever (Iso a)
    = fromRight (clever $ reduce a) $ pure <$> clever a

  brute = brute . reduce . unIso


-- Vertify that the problem is really isomorphic
vertifyIso :: (Problem a, Problem b, Reducible a b) => a -> Bool
vertifyIso a = solve a == solve (Iso a)

-- Vertify all possible problems, starting with a
vertifyIso' a
  = all vertifyIso . join $ transpose [[a, pred a ..], [succ a..]]

