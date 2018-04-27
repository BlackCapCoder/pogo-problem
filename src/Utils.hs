module Utils where


type Number = Int


infixl 5 %
(%) = mod :: Number -> Number -> Number


groupBy' :: (a -> a -> Bool) -> [a] -> [[a]]
groupBy' f xs
  | (a:b:bs) <- xs
  , (c:cs) <- groupBy' f (b:bs)
  = if f a b
     then [a] : (c:cs)
     else (a : c) : cs
  | otherwise = [xs]

rising :: Ord a => [a] -> [[a]]
rising = groupBy' (>)

