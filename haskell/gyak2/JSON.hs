{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}
--{-# LANGUAGE OverlappingInstances #-}
module JSON where

data JValue
    = JNull
    | JString String
    | JBool Bool
    | JNumber Double
    | JArray [JValue]
    | JObject [(String, JValue)]
    deriving (Show, Eq)
    
-- map: parametrikus polimorfizmus
-- (+): ad-hoc polimorfizmus
{-
class JSON a where
    toJSON   :: a -> JValue
    fromJSON :: JValue -> a
    
newtype S = S String

instance JSON S where
    --toJSON :: String -> JValue
    toJSON (S s) = JString s
    -- ^éta-konverzió
    fromJSON (JString s) = S s

instance JSON Bool where
    --toJSON :: Bool -> JValue
    toJSON b = JBool b
    fromJSON (JBool b) = b
    
instance JSON Integer where
    toJSON n = JNumber (fromIntegral n)
    fromJSON (JNumber n) = round n

instance JSON Double where
    toJSON = JNumber
    fromJSON (JNumber n) = n
    
instance JSON a => JSON [a] where
    toJSON xs = JArray [ toJSON x | x <- xs]
    fromJSON (JArray xs) = [fromJSON x | x <- xs]
    
newtype O a =  O [(String, a)]

instance JSON a=> JSON (O a) where
    toJSON (O xs) = JObject [ (s, toJSON x) | (s,x)<-xs]
--  toJSON (O [("a",S "b"),("c",S "d")])
    fromJSON (JObject xs) = O [(s, fromJSON x) | (s,x)<-xs]
-}

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
    fromJSON (JArray xs) = Just ([fromJSON x | x <- xs])
    fromJSON _           = Nothing
    
newtype O a =  O [(String, a)]

instance JSON a=> JSON (O a) where
    toJSON (O xs) = JObject [ (s, toJSON x) | (s,x)<-xs]
--  toJSON (O [("a",S "b"),("c",S "d")])
    fromJSON (JObject xs) = Just (O [(s, fromJSON x) | (s,x)<-xs])
    fromJSON _           = Nothing