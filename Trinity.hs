import          Parser
import          Lexer
import          TrinityMonad

import          System.Environment      (getArgs)
import          Data.Sequence           (null)
import          Prelude hiding          (mapM_, null)
import          System.Exit             (exitFailure, exitSuccess)
import          Control.Monad           (guard, void, when)
import          Control.Monad.Trans     (liftIO)
import          Data.Foldable           (mapM_)

main = do
    (fileName : _ ) <- getArgs
    input <- readFile fileName

    let (program, errors) = getTokens input  
    putStrLn "los bellos errores"
    print errors
    putStrLn "los tokens"
    print program
    
    putStrLn "lo tro"


    let (program, errors) = parseProgram input  
    putStrLn "los bellos errores"
    print errors
    putStrLn "el ast"
    --print program

    {-
    if null lpErrors 
        then do
            print program
            liftIO $ putStrLn "Proceso terminado."
            exitSuccess
        else do
            print lpErrors
            exitFailure
-}

--vaina que tenias ahi

        --    let (defErrors, defState) = processDefinition lpErrors program
            --if null defErrors
              --then do
                  -- let (typeErrors, typeState) = typeCheck...
 
