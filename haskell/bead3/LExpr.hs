module LExpr where

import Data.Char
import Data.List

newtype Name = N String
    deriving (Eq, Show)

data LExpr
    = T
    | F
    | Var Name
    | Or LExpr LExpr
    | And LExpr LExpr
    | Not LExpr
    deriving (Show, Eq)
    
true = T
false = F
    
var :: String -> LExpr
var s@(x:xs)
    | not $ isDigit x = Var (N s)

infixr 3 `land`
land :: LExpr -> LExpr -> LExpr
land T T = T
land F _   = F
land _ F   = F
land T b    = b
land a    T = a
land a b       = And a b

infixr 2 `lor`
lor :: LExpr -> LExpr -> LExpr
lor F F = F
lor T _      = T
lor _ T      = T
lor F b     = b
lor a     F = a
lor a b         = Or a b

lnot :: LExpr -> LExpr
lnot T  = F
lnot F = T
lnot e     = Not e

implies :: LExpr -> LExpr -> LExpr
implies T F = F
implies F _    = T
implies _     T = T
implies T b     = b
implies a    b     = lnot a `lor` b

iff :: LExpr -> LExpr -> LExpr
iff T  T  = T
iff F F = T
iff F T  = F
iff T  F = F
iff T  b     = b
iff a     T  = a
iff F b     = lnot b
iff a     F = lnot a
iff a     b     = a `land` b `lor` lnot a `land` lnot b

render :: LExpr -> String
render T = "1"
render F = "0"
render (Var (N name)) = name
render (Or a b) = "(" ++ render a ++ ") || (" ++ render b ++ ")"
render (And a b) = "(" ++ render a ++ ") && (" ++ render b ++ ")"
render (Not a)   = "!(" ++ render a ++ ")"

compile :: String -> LExpr -> String
compile f expr = "char " ++ f ++ "(" ++ paramlist expr ++ "){\n  return " ++ render expr ++ ";\n}"
    where
        paramlist expr = intercalate ", " $ map (\var -> "char " ++ var) $ nub $ vars expr
        vars expr = 
            case expr of
            T         -> []
            F        -> []
            Var (N name) -> [name]
            Or a b       -> vars a ++ vars b
            And a b      -> vars a ++ vars b
            Not a        -> vars a
