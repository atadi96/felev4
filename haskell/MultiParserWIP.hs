module Parser where

import Prelude hiding ((<$>), (<*>), (<*), (*>), (<|>), pure)

type Parser d a = [d] -> [(a, [d])]

runParser :: Parser d a -> [d] -> Maybe a
runParser p s =
  case [ x | (x, []) <- p s ] of
    (x:_) -> Just x
    _     -> Nothing

    
matches :: (d -> Bool) -> Parser d d
matches p (x:xs) | p x = [(x,xs)]
matches _ _            = []

char :: Eq a => a -> Parser a a
char c = matches (== c)


infixl 4 <$>, <*>, <*, *>
infixl 3 <|>

(<$>) :: (a -> b) -> Parser d a -> Parser d b
f <$> p = \s -> [ (f x, s') | (x, s') <- p s ]

(<*>) :: Parser d (a -> b) -> Parser d a -> Parser d b
p <*> q = \s -> [ (f x, s'') | (f, s') <- p s, (x, s'') <- q s' ]

(<*) :: Parser d a -> Parser d b -> Parser d a
p <* q = (\x _ -> x) <$> p <*> q

(*>) :: Parser d a -> Parser d b -> Parser d b
p *> q = (\_ x -> x) <$> p <*> q

pure :: a -> Parser d a
pure x = \s -> [ (x,s) ]

token :: Eq d => [d] -> Parser d [d]
token (x:xs) = (:) <$> char x <*> token xs
token []     = pure []

(<|>) :: Parser d a -> Parser d a -> Parser d a
p <|> q = \s -> p s ++ q s

some :: Parser d a -> Parser d [a]
some p = (:) <$> p <*> many p

many :: Parser d a -> Parser d [a]
many p = some p <|> pure []

chainl :: Parser d a -> Parser d (a -> a -> a) -> a -> Parser d a
chainl p q x = (p `chainl1` q) <|> pure x

chainl1 :: Parser d a -> Parser d (a -> a -> a) -> Parser d a
chainl1 p q = foldl (\x f -> f x) <$> p <*> many ((\f x y -> f y x) <$> q <*> p)
