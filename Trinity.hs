import          Lexer
import          Parser
import          Program

import          System.Environment as SE
import          Data.Sequence      as DS (null)
import          System.Exit              (exitFailure, exitSuccess)

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

