
import          System.Environment as SE
import          Data.Sequence      as DS (null)
import          System.Exit              (exitFailure, exitSuccess)

import          Lexer
import          Parser

main = do
    (fileName : _ ) <- SE.getArgs
    string <- readFile fileName
    let (errors, program) = parseProgram string
    if DS.null errors 
        then do
            print program
            exitSuccess
        else do
            print errors
            exitFailure
