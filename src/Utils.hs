module Utils where

type Number = Int


infixl 5 %
(%) = mod :: Number -> Number -> Number

