import AbstractParser
import Data.Char

type Lexer a = AbstractParser Char a

type Parser a = AbstractParser Token a

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
	
data Token
	= TALit Integer
	| TBLit Bool
	| TVariable String
	| TAssignment
	| TSkip
	| TIf
	| TThen
	| TElse
	| TFi
	| TWhile
	| TDo
	| TOd
	| TSeparator
	deriving (Eq, Show)
	
getAValue (TALit n) = n
getBValue (TBLit b) = b
getVarName (TVariable s) = s

digit = matches isDigit
letter = matches isAlpha
whitespace = matches (`elem` " \t\n")

around x y = x *> y <* x

number :: Lexer Token
number = TALit <$> (many whitespace `around` (foldl (\x y -> 10 * x + (toInteger . digitToInt) y) 0 <$> some digit))

boolean :: Lexer Token
boolean = many whitespace `around` ((token "tt" *> pure (TBLit True)) <|> (token "ff" *> pure (TBLit False)))

variable :: Lexer Token
variable = TVariable <$> many whitespace `around` ((:) <$> letter <*> many (letter <|> digit))
{-
bexp :: Parser Expr
bexp = BLit <$> getBValue boolean <|> Variable <$> getVarName variable
{-
expression :: Parser Expr
expression
    =   ALit <$> number
    <|> BLit <$> boolean
    <|> Variable <$> variable

statement :: Parser Stm
statement = undefined
    =   Assignment <$> () <*> 
    <|> (pure Skip)
    <|> If 
        <$> ()
        <*> ()
        <*> ()
    <|> While 
        <$> ()
        <*> ()
   
stm :: Parser Stm
stm = statement `chainl1` ((\_ x y -> Seq x y) <$> token ";")
-}