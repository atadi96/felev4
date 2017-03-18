import Prelude hiding ((<$>), (<*>), (<*), (*>), (<|>), pure)
import Data.Char

type Parser a = String -> [(a, String)]

matches :: (Char -> Bool) -> Parser Char
matches p (x:xs) | p x = [(x,xs)]
matches _ _            = []

char :: Char -> Parser Char
char c = matches (== c)

runParser :: Parser a -> String -> Maybe a
runParser p s =
  case [ x | (x, "") <- p s ] of
    (x:_) -> Just x
    _     -> Nothing

infixl 4 <$>, <*>, <*, *>
infixl 3 <|>

(<$>) :: (a -> b) -> Parser a -> Parser b
f <$> p = \s -> [ (f x, s') | (x, s') <- p s ]

(<*>) :: Parser (a -> b) -> Parser a -> Parser b
p <*> q = \s -> [ (f x, s'') | (f, s') <- p s, (x, s'') <- q s' ]

(<*) :: Parser a -> Parser b -> Parser a
p <* q = (\x _ -> x) <$> p <*> q

(*>) :: Parser a -> Parser b -> Parser b
p *> q = (\_ x -> x) <$> p <*> q

pure :: a -> Parser a
pure x = \s -> [ (x,s) ]

token :: String -> Parser String
token (x:xs) = (:) <$> char x <*> token xs
token []     = pure ""

(<|>) :: Parser a -> Parser a -> Parser a
p <|> q = \s -> p s ++ q s

some :: Parser a -> Parser [a]
some p = (:) <$> p <*> many p

many :: Parser a -> Parser [a]
many p = some p <|> pure []

integer
    =   (token "0x" <|> token "0X") *> (toNumber 16 <$> (digitValList <$> some hexit))
    <|> (token "0o" <|> token "0O") *> (toNumber 8 <$> (digitValList <$> some oktit))
    <|>                                 toNumber 10 <$> (digitValList <$> some digit)
    where
        digit = matches isDigit
        oktit = matches (\c -> c `elem` "01234567")
        hexit = digit <|> matches (\c -> c`elem` "abcdefABCDEF")
        toNumber base = foldl (\a b -> a * base + b) 0
        digitValList = map charToInt
        charToInt c =
            case c of
                '0' -> 0
                '1' -> 1
                '2' -> 2
                '3' -> 3
                '4' -> 4
                '5' -> 5
                '6' -> 6
                '7' -> 7
                '8' -> 8
                '9' -> 9
                'A' -> 10
                'B' -> 11
                'C' -> 12
                'D' -> 13
                'E' -> 14
                'F' -> 15
                'a' -> 10
                'b' -> 11
                'c' -> 12
                'd' -> 13
                'e' -> 14
                'f' -> 15

