module TextIO where

import Control.Monad.State

type Input  = String
type Output = String

type TextIO a = State (Input,Output) a

write    :: String -> TextIO ()
write s = state (\(input,output) -> ((),(input,output++s)))
writeLn  :: String -> TextIO ()
writeLn s = state (\(input,output) -> ((),(input,output++s++"\n")))
readChar :: TextIO Char
readChar = state (\(i:nput,output) -> (i,(nput,output)))
readLine :: TextIO String
readLine = do
    c <- readChar
    if c == '\n' then
        return ""
    else do
        rest <- readLine
        return $ c:rest

runTextIO :: TextIO a -> Input -> (a, Input, Output)
runTextIO io input = let (a,(input',output)) = runState io (input,"")
                     in (a,input',output)

exampleTIO = do
  s <- readLine
  write "Hello "
  writeLn (s ++ "!")
  return 42

exampleTIO' =
  write "Hello " *> join (write <$> readLine) *> writeLn "!" *> pure 42
