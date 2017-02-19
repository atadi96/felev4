module ZList(fromList, toList, get, right, left, insert, update, delete) where

newtype ZList a = Z ([a],[a]) 
    deriving (Eq, Show)

fromList :: [a] -> ZList a
fromList xs = Z ([],xs)

get :: ZList a -> [a]
get (Z (_,xs)) = xs

toList :: ZList a -> [a]
toList (Z ([],xs))    = xs
toList (Z (x:xs, ys)) = toList (Z (xs, x:ys))

right :: ZList a -> ZList a
right self@(Z (_,[])) = self
right (Z (xs, y:ys))  = Z (y:xs, ys)

left :: ZList a -> ZList a
left self@(Z ([],_)) = self
left (Z (x:xs, ys))  = Z (xs, x:ys)

insert :: a -> ZList a -> ZList a
insert z (Z (xs,ys)) = Z (xs, z:ys)

update :: a -> ZList a -> ZList a
update z (Z (xs,y:ys)) = Z (xs, z:ys)
update _ self          = self

delete :: ZList a -> ZList a
delete (Z (xs, y:ys)) = Z (xs, ys)
delete self           = self

        