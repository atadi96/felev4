module Types
    ( Year
    , PredicateOn
    , Name
    , mkName
    , unName
    , (+++)
    ) where

import Data.Char

type Year = Int
type PredicateOn a = a -> Bool

newtype Name = N String
    deriving (Eq, Show)

(+++) :: Name -> Name -> Name
(N s1) +++ (N s2) = N (s1 ++ " " ++ s2)

mkName :: String -> Name
mkName s@(c:_)
    | isUpper c && all isAlpha s = N s
    
unName :: Name -> String
unName (N s) = s

data Nat
    = Zero -- Zero :: Nat
    | Succ Nat --Succ :: Nat -> Nat
    deriving (Eq, Show)
    
toNat :: Integer -> Nat
toNat 0 = Zero
toNat n = Succ (toNat (n-1))

fromNat :: Nat -> Integer
fromNat Zero = 0
fromNat (Succ n) = 1 + fromNat n

fromNatS :: Nat -> String
fromNatS Zero = "0"
fromNatS (Succ n) = 'S' : fromNatS n
