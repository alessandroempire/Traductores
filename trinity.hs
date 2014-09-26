import System.Environment as SE
import System.Directory   as SD
import System.IO          as IO
import Lexer6

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
    lexx line
    
