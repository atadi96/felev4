module TextIO where

type Input  = String
type Output = String

newtype TextIO a = TIO (Input -> (a,Input,Output))

instance Functor TextIO where
    f `fmap` TIO io =
        TIO (\input -> case io input of
                (a,input',output') -> (f a, input', output')
            )
    
instance Applicative TextIO where
    pure val = TIO (\input -> (val,input,""))
    TIO io1 <*> TIO io2 =
        TIO (\input -> 
                let (f,input',output') = io1 input
                    (a,input'',output'') = io2 input'
                in (f a, input'', output'++output'')
            )
    
instance Monad TextIO where
    (TIO io) >>= f =
        TIO (\input ->
                let (a, input', output') = io input
                    (TIO io') = f a
                    (b, input'', output'') = io' input'
                in  (b, input'', output' ++ output'')
            )
    return = pure
  
runTextIO :: TextIO a -> Input -> (a, Input, Output)
runTextIO (TIO io) input = io input

write :: String -> TextIO ()
write s = TIO (\input -> ((), input, s))

writeLn :: String -> TextIO ()
writeLn s = TIO (\input -> ((), input, s++['\n']))

readChar :: TextIO Char
readChar = TIO (\(c:cs) -> (c, cs, ""))

readLine :: TextIO String 
readLine = do
    c <- readChar
    if c == '\n' then
        return ""
    else do
        rest <- readLine
        return $ c:rest
        
{-
readLine =  TIO (\input -> 
                let inputLine = line ("",input)
                in (fst inputLine, snd inputLine, "")
            )
    where line s =
            case s of
                (x,"")          -> (x,"")
                (x,('\n':rest)) -> (x,rest)
                (x,c:cs)          -> line (x++[c], cs)
-}
test = do
    write "Hello "
    writeLn "World!!"
    
output = runTextIO test "be\nmenet"

exampleTIO = do
  write "Hello "
  s <- readLine
  writeLn (s ++ "!")
  return 42
