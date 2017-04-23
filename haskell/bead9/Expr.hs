import Prelude hiding (gcd)
-- Expr :: * -> *
newtype Expr a = E (Env -> a)
type Env = [(Name, Integer)]
type Name = String

eval :: Expr a -> Env -> a
eval (E f) env = f env

getExpr:: Expr a -> (Env -> a)
getExpr (E f) = f

var :: Name -> Expr Integer
var name = E varval
    where
        varval [] = error "Variable not found"
        varval ((varname,val):xs)
            | varname == name = val
            | otherwise       = varval xs

val :: a -> Expr a
val x = E $ \env -> x

if' :: Expr Bool -> Expr a -> Expr a -> Expr a
if' cond a b = E $ \env ->  if eval cond env then
                                eval a env
                            else
                                eval b env

bind :: Name -> Expr Integer -> Expr a -> Expr a
bind name valExp scope = E $ \env -> eval scope ((name, eval valExp env):env)

instance Functor Expr where
  --fmap :: (a -> b) -> f a -> f b
    fmap f (E expr) = E $ f . expr
    
instance Applicative Expr where
    pure = val
    (E f) <*> (E a) = E $ \env -> (f env) (a env)

gcd :: Expr Integer
gcd =
  if' ((==) <$> var a <*> var b)
    (var a)
    (if' ((>) <$> var a <*> var b)
      (bind a ((-) <$> var a <*> var b) gcd)
      (bind b ((-) <$> var b <*> var a) gcd))
  where
    [a,b] = ["a","b"]