module Heap
    ( rank
    , mkT
    , empty
    , singleton
    , isEmpty
    , findMin
    , merge
    , insert
    , deleteMin
    ) where

data Heap a
    = E
    | T Int a (Heap a) (Heap a)
    deriving (Eq, Show)

rank :: Heap a -> Int
rank E            =  0
rank (T r _ _ _)  =  r   

mkT :: Ord a => a -> Heap a -> Heap a -> Heap a
mkT a E E = T 1 a E E
mkT a left right
    | r2 > r1   = T (r1+1) a right left
    | otherwise = T (r2+1) a left right 
        where
            r1 = rank left
            r2 = rank right

empty :: Heap a
empty = E

singleton :: Ord a => a -> Heap a
singleton a = T 1 a empty empty

isEmpty :: Heap a -> Bool
isEmpty E = True
isEmpty _ = False

findMin :: Heap a -> Maybe a
findMin E           = Nothing
findMin (T _ a _ _) = Just a

merge :: Ord a => Heap a -> Heap a -> Heap a
merge E E                 = empty
merge E right             = right
merge left E              = left
merge l@(T r1 v1 ll lr) r@(T r2 v2 rl rr)
    | v1 < v2   = mkT v1 ll (merge lr r)
    | otherwise = mkT v2 rl (merge rr l)

insert :: Ord a => a -> Heap a -> Heap a
insert a h = merge (singleton a) h

deleteMin :: Ord a => Heap a -> Heap a
deleteMin E = E
deleteMin (T _ _ l r) = merge l r
