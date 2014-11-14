import          Parser
import          Lexer
import          TrinityMonad
import          Definition
import          TypeChecker
import          Interpreter

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

    let (defS, dfErrors) = processDefinition False lpErrors program
    unlessGuard (null $ errors dfErrors) $ errorReport dfErrors

    let (typS, tpErrors) = processTypeChecker False dfErrors (getTable defS) program
    unlessGuard (null $ errors tpErrors) $ mapM_ (liftIO . print) tpErrors
    
    liftIO $ print (getTable typS)
    liftIO $ putStrLn "Proceso terminado."
    exitSuccess
  
errorReport err = do
    mapM_ (liftIO . print) err
    exitFailure
