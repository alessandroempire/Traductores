import          Parser
import          Lexer
import          TrinityMonad
import          Definition

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

    let (program, lpErrors) = parseProgram input  
    unlessGuard (null $ errors lpErrors) $ errorReport lpErrors
    print program
{-

    let (defS, dfErrors) = processDefinition False lpErrors program
    unlessGuard (null $ errors dfErrors) $ errorReport dfErrors
    
    liftIO $ print (getTable defS)
    liftIO $ putStrLn "Proceso terminado."
    exitSuccess
-}  
errorReport err = do
    mapM_ (liftIO . print) err
    exitFailure

