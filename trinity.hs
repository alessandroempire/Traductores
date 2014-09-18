
import System.Environment as SE
import System.Directory   as SD
import System.IO          as IO

main = do
    (filename : _) <- SE.getArgs
    fileExists     <- SD.doesFileExist filename
    if fileExists
        then do openF filename
        else do putStrLn "El archivo no existe"

openF :: FilePath -> IO ()
openF filename = do 
    handle   <- IO.openFile filename ReadMode
    contents <- hGetContents handle
    putStrLn contents
    hClose handle
