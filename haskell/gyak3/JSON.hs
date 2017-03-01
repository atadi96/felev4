{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}
--{-# LANGUAGE OverlappingInstances #-}
module JSON where

import Doc

data JValue
    = JNull
    | JString String
    | JBool Bool
    | JNumber Double
    | JArray [JValue]
    | JObject [(String, JValue)]
    deriving (Show, Eq)
    
renderJValue :: JValue -> Doc
renderJValue JNull = text "null"
renderJValue (JBool True) = text "true"
renderJValue (JBool False) = text "false"
renderJValue (JNumber n) = double n
renderJValue (JString s) = string s
renderJValue (JArray xs) = series '[' ']' (\x -> nest 4 $ renderJValue x) xs
renderJValue (JObject xs) = series '{' '}' f xs
    where
        f (s,x) = nest 4 $ string s </> text ":" </> renderJValue x

class JSON a where
    toJSON   :: a -> JValue
    fromJSON :: JValue -> Maybe a
    
newtype S = S String

instance JSON S where
    --toJSON :: String -> JValue
    toJSON (S s) = JString s
    -- ^éta-konverzió
    fromJSON (JString s) = Just (S s)
    fromJSON _           = Nothing

instance JSON Bool where
    --toJSON :: Bool -> JValue
    toJSON b = JBool b
    fromJSON (JBool b) = Just b
    fromJSON _           = Nothing
    
instance JSON Integer where
    toJSON n = JNumber (fromIntegral n)
    fromJSON (JNumber n) = Just (round n)
    fromJSON _           = Nothing

instance JSON Double where
    toJSON = JNumber
    fromJSON (JNumber n) = Just n
    fromJSON _           = Nothing
    
instance JSON a => JSON [a] where
    toJSON xs = JArray [ toJSON x | x <- xs]
    fromJSON (JArray xs) = f [fromJSON x | x <- xs]
        where
            f :: [Maybe a]  -> Maybe [a]
            f []            = Just []
            f (Nothing:_)   = Nothing
            f ((Just x):xs) = 
                case (f xs) of
                    Nothing -> Nothing
                    Just xs -> Just (x:xs)
    fromJSON _           = Nothing
    
newtype O a =  O [(String, a)]

instance JSON a=> JSON (O a) where
    toJSON (O xs) = JObject [ (s, toJSON x) | (s,x)<-xs]
--  toJSON (O [("a",S "b"),("c",S "d")])
    fromJSON (JObject xs) = g $ f [(s, fromJSON x) | (s,x)<-xs]
        where
            g :: Maybe [(String,a)] -> Maybe (O a)
            g Nothing   = Nothing
            g (Just xs) = Just (O xs)
            
            f :: [(String, Maybe a)] -> Maybe [(String,a)]
            f []              = Just []
            f ((_,Nothing):_) = Nothing
            f ((s,Just x):xs) =
                case (f xs) of
                    Nothing -> Nothing
                    Just xs -> Just ((s,x):xs)
    fromJSON _           = Nothing