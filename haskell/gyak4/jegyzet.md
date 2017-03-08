# Haladó Haskell

## 4. előadás

### Már megvan

```
JSON
toJSON
|------|   |-----|---pretty-print--->|--------|
|JValue|---| Doc |                   |  json  |
|--ADT-|   |-ADT-|-machine-friendly->|kiíratás|
```

### Cél

A fenti ábra bal oldala elé szeretnénk valamit rakni,
ami fájlból beolvassa az adatokat (**parser**)

```Haskell
module Parse where

import Prelude hiding ((<$>), (<*>))
import Data.Char

type Parser a = String -> [(a, String)]
--char :: Char -> String -> [(Char, String)]
char :: Char -> Parser Char
char c = matches (== c);
{-
(char c) s =
    case s of
        (x:xs) | c == x -> [(x, xs)]
        _               -> []
-}
matches :: (Char -> Bool) -> Parser Char
(matches p) s =
    case s of
        (x:xs) | p x -> [(x, xs)]
        _               -> []
```

Kéne két parser eredményéből egy következő parser-t előállítani, ehhez 
felvesszük a következő függvény

```Haskell

comp :: (a -> b -> c) -> Parser a -> Parser b -> Parser c
(comp f p q) s = [(f x y, s'') | (x, s') <- p s, (y, s'') <- q s']

letter = matches isAlpha
comp (\c1, c2 -> [c1,c1]) letter letter "alma" == ["al", "ma"]

```

szeretnénk: `f x y z ... === (((f x) y ) z )` n paraméteres fv-t

```Haskell

(<$>) :: (a -> b) -> Parser a -> Parser b
(f <$> p) s = [ (f x, s') | (x, s') <- p s]

(digitToInt <$> digit) "42" == [(4, "2")]

```

most a célunk: `"42" -> [4,2]`

```Haskell

:type (digitToInt <$> digit) == Parser Int
:type ((\x y -> [digitToInt x, y]) <$> digit) == Parser (Int -> [Int])

```
```Haskell 

(<*>) :: Parser (a -> b) -> Parser a -> Parser b
(p <*> q) s = [ (f x, s') | (f, s') <- p s, (x, s'') <- q s']


(\ x y -> [digitToInt x, digitToInt y]) <$> digit <*> digit :: Parser [Int]
((\ x y -> [digitToInt x, digitToInt y]) <$> digit <*> digit) "42" == [4,2]
```
