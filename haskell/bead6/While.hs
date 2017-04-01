import Data.Char
import Prelude hiding ((<$>), (<*>), (<*), (*>), (<|>), pure)

type Parser a = String -> [(a, String)]

runParser :: Parser a -> String -> Maybe a
runParser p s =
  case [ x | (x, "") <- p s ] of
    (x:_) -> Just x
    _     -> Nothing

matches :: (Char -> Bool) -> Parser Char
matches p (x:xs) | p x = [(x,xs)]
matches _ _            = []

char :: Char -> Parser Char
char c = matches (== c)

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

chainl :: Parser a -> Parser (a -> a -> a) -> a -> Parser a
chainl p q x = (p `chainl1` q) <|> pure x

chainl1 :: Parser a -> Parser (a -> a -> a) -> Parser a
chainl1 p q = foldl (\x f -> f x) <$> p <*> many ((\f x y -> f y x) <$> q <*> p)

{-
<digit>    ::= '0' | ... | '9'
<letter>   ::= 'a' | ... | 'z' | 'A' | ... | 'Z'
<number>   ::= <digit>{<digit>}
<boolean>  ::= "tt" | "ff"
<variable> ::= <letter>{<letter> | <digit>}

<bexp>       ::= <boolean> | <variable>
<expression> ::= <number> | <boolean> | <variable>

<statement> ::= <variable> ":=" <expression>
            |  "skip"
            |  <statement> ";" <statement>
            |  "if" <bexp> "then" <statement> "else" <statement> "fi"
            |  "while" <bexp> "do" <statement> "od"
-}

---saját kód
    
data Expr
    = ALit Integer
    | BLit Bool
    | Variable String
    deriving (Show, Eq)

data Stm
    = Assignment String Expr
    | Skip
    | Seq Stm Stm
    | If Expr Stm Stm
    | While Expr Stm
    deriving (Show, Eq)
    
digit = matches isDigit
letter = matches isAlpha
whitespace = matches (`elem` " \t\n")

around x y = x *> y <* x

number :: Parser Integer
number = many whitespace `around` (foldl (\x y -> 10 * x + (toInteger . digitToInt) y) 0 <$> some digit)

boolean :: Parser Bool
boolean = many whitespace `around` ((token "tt" *> pure True) <|> (token "ff" *> pure False))

variable :: Parser String
variable = many whitespace `around` ((:) <$> letter <*> many (letter <|> digit))

bexp :: Parser Expr
bexp = BLit <$> boolean <|> Variable <$> variable

expression :: Parser Expr
expression
    =   ALit <$> number
    <|> BLit <$> boolean
    <|> Variable <$> variable

statement :: Parser Stm
statement
    =   Assignment <$> (variable <* many whitespace `around` token ":=") <*> expression
    <|> (many whitespace `around` token "skip" *> pure Skip)
    <|> If 
        <$> (many whitespace *> token "if" *> some whitespace *> bexp)
        <*> (some whitespace `around` token "then" *> stm)
        <*> (some whitespace `around` token "else" *> stm <* some whitespace <* token "fi" <* many whitespace)
    <|> While 
        <$> (many whitespace *> token "while" *> some whitespace *> bexp)
        <*> (some whitespace `around` token "do" *> stm <* some whitespace <* token "od" <* many whitespace)
    
stm :: Parser Stm
stm = statement `chainl1` ((\_ x y -> Seq x y) <$> token ";")

