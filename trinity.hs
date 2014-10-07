import System.Environment as SE
import System.Exit        (exitFailure, exitSuccess)
import Data.Sequence      as DS (null)
import Lexer             

main = do
    (fileName : _ )  <- SE.getArgs
    string <- readFile fileName
    let (errors, tokens) = getTokens string
    print errors
    mapM_ print tokens
    if DS.null errors then exitSuccess
                      else exitFailure
