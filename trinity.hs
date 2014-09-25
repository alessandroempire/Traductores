import System.Environment as SE
import System.Directory   as SD
import System.IO          as IO
import Lexer

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
    line <- hGetContents handle
    let result = lexTokens line
    case result of
      Right x  -> mapM_ (putStrLn . showToken) x
      Left err -> putStrLn err

