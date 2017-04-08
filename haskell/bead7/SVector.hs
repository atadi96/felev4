data SVector a = SV Int (Int -> a)

svLength :: SVector a -> Int
svLength (SV n _) = n

svIndexF :: SVector a -> (Int -> a)
svIndexF (SV _ f) = f

indexed :: Int -> (Int -> a) -> SVector a
indexed n f = SV n f

singleton :: a -> SVector a
singleton a = SV 1 (\0 -> a)

fromList :: [a] -> SVector a
fromList a = SV (length a) (a!!)

fromListBaguette :: [a] -> SVector a
fromListBaguette [x] = singleton x
fromListBaguette (x:xs) = SV (1 + n) newF
    where 
        vec = fromListBaguette xs
        n = svLength vec
        f = svIndexF vec
        newF i 
            | i == 0    = x
            | otherwise = f (i - 1) 

freeze :: SVector a -> [a]
freeze (SV n f) = map f [0..n-1]

(...) :: Enum a => a -> a -> SVector a
a...b = SV (fromEnum b - fromEnum a + 1) (\x -> toEnum (fromEnum a + x))

infixr 5 |++|
(|++|) :: SVector a -> SVector a -> SVector a
(SV l1 f1) |++| (SV l2 f2) = SV (l1 + l2) f
    where
        f n
         | n < l1    = f1 n
         | otherwise = f2 (n - l1)

svTake :: Int -> SVector a -> SVector a
svTake n (SV l f)
    | n > 0     = (SV (min n l) f)
    | otherwise = SV n f

svDrop :: Int -> SVector a -> SVector a
svDrop n sv@(SV l f)
    | n > 0     = SV (max 0 (l-n)) (\x -> f $ x+n)
    | otherwise = sv
    
svReverse :: SVector a -> SVector a
svReverse (SV n f) = SV n (\x -> f $ (n - 1) - x)

svReplicate :: Int -> a -> SVector a
svReplicate n e = SV n (\_ -> e)

svZip :: SVector a -> SVector b -> SVector (a,b)
svZip (SV la fa) (SV lb fb) = SV (min la lb) (\x -> (fa x, fb x))

svMap :: (a -> b) -> SVector a -> SVector b
svMap g (SV l f) = SV l (g . f)
