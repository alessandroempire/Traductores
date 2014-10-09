import System.Environment as SE
import System.Exit (exitFailure, exitSuccess)
import Data.Sequence as DS (null)

import Lexer
import Parser

main = do
    (fileName : _ ) <- SE.getArgs
    string <- readFile fileName
    let (errors, program) = parseProgram string
    print errors
    if DS.null errors 
        then exitSuccess
        else exitFailure
