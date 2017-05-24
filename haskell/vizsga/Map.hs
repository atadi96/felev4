module Map where

import Data.Monoid

data Map k v
    = Empty
    | Node k v (Map k v) (Map k v)

empty :: Map k v
empty = Empty

fold :: (k -> v -> a -> a -> a) -> a -> Map k v -> a
fold _ a Empty = a
fold f a (Node k v m1 m2) = f k v (fold f a m1) (fold f a m2)

toList :: Map k v -> [(k,v)]
toList Empty = []
toList (Node k v left right) = (toList left) ++ [(k, v)] ++ (toList right)

keys :: Map k v -> [k]
keys = map (\(k, _) -> k) . toList

values :: Map k v -> [v]
values =  map (\(_, v) -> v) . toList

instance (Eq k, Eq v) => Eq (Map k v) where
    Empty == Empty = True
    Empty == _     = False
    _     == Empty = False
    left  == right = toList left `equal` toList right where
        equal [] [] = True
        equal _  [] = False
        equal [] _  = False
        equal (x:xs) ys =
            case x `elem` ys of
                True -> equal xs (filter (\y -> y /= x) ys)
                False -> False

instance (Show k, Show v) => Show (Map k v) where
    show Empty = ""
    show (Node k v Empty Empty) = show k ++ " => " ++ show v
    show (Node k v Empty right) = show k ++ " => " ++ show v ++ "\n" ++ show right
    show (Node k v left  Empty) = show left ++ "\n" ++ show k ++ " => " ++ show v
    show (Node k v left  right) = show left ++ "\n" ++ show k ++ " => " ++ show v ++ "\n" ++ show right

insert :: (Ord k, Monoid v) => k -> v -> Map k v -> Map k v
insert k v Empty = Node k v empty empty
insert k1 v1 (Node k2 v2 left right) = 
    case (compare k1 k2) of
        LT -> Node k2 v2 (insert k1 v1 left) right
        GT -> Node k2 v2 left (insert k1 v1 right)
        EQ -> Node k2 (mappend v1 v2) left right

fromList :: (Ord k, Monoid v) => [(k,v)] -> Map k v
fromList = foldl (\m (k, v) -> insert k v m) empty

dictionary :: Ord a => [a] -> Map a (Sum Integer)
dictionary [] = Empty
dictionary (x:xs) = insert x 1 (dictionary xs)

instance Functor (Map a) where
    f `fmap` Empty = Empty
    f `fmap` (Node k v left right) = Node k (f v) (f `fmap` left) (f `fmap` right)

distribution :: Ord a => [a] -> Map a Double
distribution [] = empty
distribution xs = let countingInsert (mmap, count) key = (insert key (Sum 1.0) mmap, count + 1) in
                  let (mmap, length) = foldl countingInsert (empty, 0) xs in
                  (\x -> getSum x / length) <$> mmap
