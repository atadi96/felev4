module AbstractParser where

import Prelude hiding ((<$>), (<*>), (<*), (*>), (<|>), pure)

type AbstractParser d a = [d] -> [(a, [d])]

runAbstractParser :: AbstractParser d a -> [d] -> Maybe a
runAbstractParser p s =
  case [ x | (x, []) <- p s ] of
    (x:_) -> Just x
    _     -> Nothing

    
matches :: (d -> Bool) -> AbstractParser d d
matches p (x:xs) | p x = [(x,xs)]
matches _ _            = []

char :: Eq a => a -> AbstractParser a a
char c = matches (== c)


infixl 4 <$>, <*>, <*, *>
infixl 3 <|>

(<$>) :: (a -> b) -> AbstractParser d a -> AbstractParser d b
f <$> p = \s -> [ (f x, s') | (x, s') <- p s ]

(<*>) :: AbstractParser d (a -> b) -> AbstractParser d a -> AbstractParser d b
p <*> q = \s -> [ (f x, s'') | (f, s') <- p s, (x, s'') <- q s' ]

(<*) :: AbstractParser d a -> AbstractParser d b -> AbstractParser d a
p <* q = (\x _ -> x) <$> p <*> q

(*>) :: AbstractParser d a -> AbstractParser d b -> AbstractParser d b
p *> q = (\_ x -> x) <$> p <*> q

pure :: a -> AbstractParser d a
pure x = \s -> [ (x,s) ]

token :: Eq d => [d] -> AbstractParser d [d]
token (x:xs) = (:) <$> char x <*> token xs
token []     = pure []

(<|>) :: AbstractParser d a -> AbstractParser d a -> AbstractParser d a
p <|> q = \s -> p s ++ q s

some :: AbstractParser d a -> AbstractParser d [a]
some p = (:) <$> p <*> many p

many :: AbstractParser d a -> AbstractParser d [a]
many p = some p <|> pure []

chainl :: AbstractParser d a -> AbstractParser d (a -> a -> a) -> a -> AbstractParser d a
chainl p q x = (p `chainl1` q) <|> pure x

chainl1 :: AbstractParser d a -> AbstractParser d (a -> a -> a) -> AbstractParser d a
chainl1 p q = foldl (\x f -> f x) <$> p <*> many ((\f x y -> f y x) <$> q <*> p)
