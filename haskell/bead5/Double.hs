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

double =
    simple <$> number <*> (exponent <|> pure 0)
    <|> mkDouble <$> (number <* token ".") <*> fractioned <*> (exponent <|> pure 0)
    where
        simple num exp = fromIntegral(num) * (10 ^^ exp)
        mkDouble intPart (fracPart,len) exp = fromIntegral (intPart * 10^len + fracPart) * 10 ^^ (exp - len)
        exponent = (token "e" <|> token "E") *> ((*) <$> (sign <$> (token "+" <|> token "-" <|> pure "+")) <*> number)
            where
                sign "+" = 1
                sign "-" = -1
        digits = some (matches isDigit)
        number = base10 <$> ((map digitToInt) <$> digits)
            where
                base10 = foldl (\a b -> a * 10 + b) 0
        fractioned = (foldl (\(a,n) b -> (a * 10 + b,n+1)) (0,0)) <$> ((map digitToInt) <$> digits)

--(<+>) :: Parser [a] -> Parser [a] -> Parser [a]
--p <+> q = \s -> [(x ++ x', s'') | (x, s')<-p s, (x', s'')<-q s']
{-
digits = some (matches isDigit)
number = base10 <$> ((map digitToInt) <$> digits)
    where
        base10 = foldl (\a b -> a * 10 + b) 0
-}
--double :: Parser Double        

--fractioned = (foldl (\(a,n) b -> (a * 10 + b,n+1)) (0,0)) <$> ((map digitToInt) <$> digits)
--double' = (\a (b,n) -> fromIntegral (a * 10^n + b) * 10 ^^ (-n) ) <$> (number <* token ".") <*> fractioned
--double'' = (\a (b,n) exp -> fromIntegral (a * 10^n + b) * 10 ^^ (exp - n)) <$> (number <* token ".") <*> fractioned <*> exponent


--exponent s = (token "+" <|> token "-") digits 

--optional :: Parser a -> Parser [a]
--optional p = \s -> (:) <$> ([p] <|> pure [])
