import System.Environment as SE
import System.Directory   as SD
import System.IO          as IO
import Lexer7 


main = do
    (filename : _) <- SE.getArgs
    fileExists     <- SD.doesFileExist filename
    if fileExists
        then do openF filename
        else do putStrLn "El archivo no existe"

openF :: FilePath -> IO ()
openF filename = do 
    handle   <- IO.openFile filename ReadMode
    processFile handle

--processFile ::
processFile handle = do
    line  <- hGetContents handle
    let (a,b) = getTokens line
    putStrLn $ "Error Lexicos encontrados: \n" ++ show a
    putStrLn $ "Tokens encontrados:" 
    printTokens b
    
printTokens []    = putStrLn ""
printTokens (a:b) = do 
    putStrLn $ show a
    printTokens b
