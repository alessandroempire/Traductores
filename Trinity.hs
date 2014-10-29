import          Parser
import          TrinityMonad

import          System.Environment (getArgs)
import          Data.Sequence (null)
import          Prelude hiding (mapM_, null)
import          System.Exit (exitFailure, exitSuccess)
import          Control.Monad (guard, void, when)
import          Control.Monad.Trans (liftIO)
import          Data.Foldable (mapM_)

main = do
    (fileName : _ ) <- getArgs
    input <- readFile fileName

    let (lpErrors, program) = parseProgram input  
    if null lpErrors 
        then do
            print program
            liftIO $ putStrLn "Proceso terminado."
            exitSuccess
   
        --    let (defErrors, defState) = processDefinition lpErrors program
            --if null defErrors
              --then do
                  -- let (typeErrors, typeState) = typeCheck...
 
        else do
            print lpErrors
            exitFailure            

