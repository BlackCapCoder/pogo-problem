{-# LANGUAGE FunctionalDependencies, MultiWayIf #-}
module Problem where

import System.Timeout
import Control.Monad
import Data.Either


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

  -- Actually solve it using maths and stuff
  clever :: a -> Either () (Maybe Int)
  clever = const $ Left ()

  -- Solve cleverly, fallback to referance
  solve :: a -> Maybe Int
  solve a
    = case clever a of
        Right x -> x
        Left _  -> brute' a


-- Vertify that clever == brute, give up after t time
vertify :: (Problem a) => Int -> a -> IO (Either () Bool)
vertify t a = do
  r <- timeout t . return $! brute' a

  return $ case r of
    Just x -> (==x) <$> clever a
    _      -> Left ()

vertifys :: (Problem a, Traversable t) => Int -> t a -> IO Bool
vertifys t as = all (fromRight True) <$> forM as (vertify t)
