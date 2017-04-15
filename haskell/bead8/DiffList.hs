module Submission where

newtype DiffList a = DFL ([a] -> [a])

fromList :: [a] -> DiffList a
fromList xs = DFL (\ys -> ys ++ xs)

toList :: DiffList a -> [a]
toList (DFL f) = f []

empty :: DiffList a
empty = fromList []

singleton :: a -> DiffList a
singleton x = fromList [x]

infixr 5 `cons`
cons :: a -> DiffList a -> DiffList a
cons x (DFL f) = DFL (\ys -> ys ++ (f $ [x]))

append :: DiffList a -> DiffList a -> DiffList a
append (DFL f) (DFL g) = DFL (g . f)

concat :: [DiffList a] -> DiffList a
concat = Prelude.foldr append empty

foldr :: (a -> b -> b) -> b -> DiffList a -> b
foldr f y dfl = Prelude.foldr f y (toList dfl)

map :: (a -> b) -> DiffList a -> DiffList b
map f (DFL g) = DFL (\ys -> ys ++ Prelude.map f (g []))
