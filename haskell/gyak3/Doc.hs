module Doc where

import Data.List

data Doc
    = Empty
    | Text String
    | Char Char
    | Nest Int Doc
    | Line
    | Concat Doc Doc
    | Union Doc Doc
    deriving (Show, Eq)

compact :: Doc -> String
compact x = transform [x] where
    transform :: [Doc] -> String
    transform [] = ""
    transform (d:ds) =
        case d of
            Empty -> transform ds
            Char c -> c : transform ds
            Text s -> s ++ transform ds
            Line   -> '\n' : transform ds
            Nest _ d -> transform (d:ds)
            Concat a b -> transform (a:b:ds)
            Union a _  -> transform (a:ds)
            
pretty :: Int -> Doc -> String
pretty width x = transform (0,0) [x]
    where
        transform _ [] = ""
        transform (col,n) (d:ds) =
            case d of
                Empty      -> transform (col,n) (ds)
                Char c     -> transform (col+1, n) ds
                Text s     -> s ++ transform (col + length s, n) ds
                Line       -> '\n' : spaces n ++ transform (0,n) ds
                Nest m d   ->
                    spaces (m - col) ++
                    transform (col, n+m) [d] ++
                    transform (col, n) ds
                Concat a b -> transform (col,n) (a:b:ds)
                Union a b  ->
                    nicest col (transform (col,n) (a:ds)) (transform (col,n) b:ds)
        spaces n = [ ' ' | _ <- [1..n] ]
        nicest col x y
            | x `fits` (width - least) = x
            | otherwise                = y
            where
                least = width `min` col
        fits :: String -> Int -> Bool
        fits _ _ = True
empty :: Doc
empty = Empty

text :: String -> Doc
text "" = Empty
text s  = Text s

char :: Char -> Doc
char c = Char c

char' :: Char -> Doc
char' c =
    case (lookup c escapees) of
        (Just r) -> text r
        Nothing -> char c
        where
            escapees :: [(Char,String)]
            escapees = [('\n',"\\n"),('\t',"\\t"),('\r',"\\r")]

double :: Double -> Doc
double d = text $ show d

string :: String -> Doc
string s = enclose '"' '"' (<>) (hcat [ char c  | c <- s ])

line :: Doc
line = Line

softline :: Doc
softline = group line

group :: Doc -> Doc
group x = flatten x `Union` x

flatten :: Doc -> Doc
flatten (Concat a b) = Concat (flatten a) (flatten b)
flatten Line         = '\n'
flatten _            = Empty

hcat :: [Doc] -> Doc
hcat xs = foldr (<>) Empty xs

nest :: Int -> Doc -> Doc
nest _ Empty = Empty
nest n (Nest m d) = undefined

enclose :: Char -> Char -> (Doc -> Doc -> Doc) -> Doc -> Doc
enclose left right op x = (char left) `op` x `op` (char right)

series :: Char -> Char -> (a -> Doc) -> [a] -> Doc
series d1 d2 f xs = enclose d1 d2 (</>) (fsep $ (intersperse (char ',') [ f x | x <- xs]))

fsep :: [Doc] -> Doc
fsep xs = foldr (</>) Empty xs

(<>) :: Doc -> Doc -> Doc
Empty <> y = y
x <> Empty = x
x <> y     = x `Concat` y

(</>) :: Doc -> Doc -> Doc
x </> y = x <> softline <> y
