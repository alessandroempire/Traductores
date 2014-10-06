import System.Environment as SE
import Lexer             

main = do
    (fileName : _ )  <- SE.getArgs
    string <- readFile fileName
    let (errors, tokens) = getTokens string
    print errors
    mapM_ print tokens
