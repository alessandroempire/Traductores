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
    contents <- hGetLine handle
    putStrLn contents
    let a = getToken contents
    putStrLn $ show a 
    contents <- hGetLine handle
    putStrLn contents
    putStrLn "ahora"
    let a = getToken contents
    putStrLn $ show a 
    hClose handle
