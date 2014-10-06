import System.Environment as SE
import Lexer             

main = do
    (fileName : _ )  <- SE.getArgs
    string <- readFile fileName
    let (error, tokens) = getTokens string
    print error
    mapM_ print tokens
