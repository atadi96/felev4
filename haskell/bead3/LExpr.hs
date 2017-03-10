module LExpr where

import Data.Char
import Data.List

newtype Name = N String
    deriving (Eq, Show)

data LExpr
    = TRUE
    | FALSE
    | VAR Name
    | OR LExpr LExpr
    | AND LExpr LExpr
    | NOT LExpr
    deriving (Show, Eq)
    
true = TRUE
false = FALSE
    
var :: String -> LExpr
var s@(x:xs)
    | not $ isDigit x = VAR (N s)

infixr 3 `land`
land :: LExpr -> LExpr -> LExpr
land TRUE TRUE = TRUE
land FALSE _   = FALSE
land _ FALSE   = FALSE
land TRUE b    = b
land a    TRUE = a
land a b       = AND a b

infixr 2 `lor`
lor :: LExpr -> LExpr -> LExpr
lor FALSE FALSE = FALSE
lor TRUE _      = TRUE
lor _ TRUE      = TRUE
lor FALSE b     = b
lor a     FALSE = a
lor a b         = OR a b

lnot :: LExpr -> LExpr
lnot TRUE  = FALSE
lnot FALSE = TRUE
lnot e     = NOT e

implies :: LExpr -> LExpr -> LExpr
implies TRUE FALSE = FALSE
implies FALSE _    = TRUE
implies _     TRUE = TRUE
implies TRUE b     = b
implies a    b     = lnot a `lor` b

iff :: LExpr -> LExpr -> LExpr
iff TRUE  TRUE  = TRUE
iff FALSE FALSE = TRUE
iff FALSE TRUE  = FALSE
iff TRUE  FALSE = FALSE
iff TRUE  b     = b
iff a     TRUE  = a
iff FALSE b     = lnot b
iff a     FALSE = lnot a
iff a     b     = a `land` b `lor` lnot a `land` lnot b

render :: LExpr -> String
render TRUE = "1"
render FALSE = "0"
render (VAR (N name)) = name
render (OR a b) = "(" ++ render a ++ ") || (" ++ render b ++ ")"
render (AND a b) = "(" ++ render a ++ ") && (" ++ render b ++ ")"
render (NOT a)   = "!(" ++ render a ++ ")"

compile :: String -> LExpr -> String
compile f expr = "char " ++ f ++ "(" ++ paramlist expr ++ "){\n  return " ++ render expr ++ ";\n}"
    where
        paramlist expr = intercalate ", " $ map (\var -> "char " ++ var) $ vars expr
        vars expr = 
            case expr of
            TRUE         -> []
            FALSE        -> []
            VAR (N name) -> [name]
            OR a b       -> vars a ++ vars b
            AND a b      -> vars a ++ vars b
            NOT a        -> vars a
