module Parser where

import Prelude hiding ((<$>), (<*>))
import Data.Char

type Parser a = String -> [(a, String)]

char :: Char -> Parser Char
char c = matches (== c);

matches :: (Char -> Bool) -> Parser Char
(matches p) s =
    case s of
        (x:xs) | p x -> [(x, xs)]
        _               -> []
        
digit :: Parser Char
digit = matches isDigit

letter :: Parser Char
letter = matches isAlpha

comp :: (a -> b -> c) -> Parser a -> Parser b -> Parser c
(comp f p q) s = [(f x y, s'') | (x, s') <- p s, (y, s'') <- q s']


ossze c1 c2 = [c1, c2]
szambetu = comp ossze letter digit
betuszam = comp ossze digit letter

--comp (\c1 c2 -> [c1,c2]) letter letter "alma" == ["al", "ma"]
        
--some p = (:) <$> p <*> many p