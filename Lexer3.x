{
module Lexer3
    ( Token(..),
      lexx
    ) 
    where
}

%wrapper "monad"

$digit = 0-9			-- digits
$alpha = [a-zA-Z]		-- alphabetic characters

tokens :-
    $white+              ;
    "program"            { mkL TkProgram }

 
{

--http://stackoverflow.com/questions/6038573/request-for-comments-on-simple-alex-parser

-- The token type:
data Token = L AlexPosn Lexeme String

data Lexeme =
        TkProgram | TkEOF
        deriving (Eq,Show)

mkL :: Lexeme -> AlexInput -> Int -> Alex Token
mkL c (p,_,_,str) len = return (L p c (take len str))

lexError s = do
    (p,c,_,input) <- alexGetInput
    alexError (s ++ ": " ++ showPosn p)

showPosn (AlexPn _ line col) = "in line " ++ show line ++ " ,column " ++ show col

showToken (L p tkn str) = show tkn ++ " '" ++ str ++ "' " ++ showPosn p

alexEOF = return (L undefined TkEOF "")

alexMonadScanTokens = do
    inp <- alexGetInput
    sc <- alexGetStartCode
    case alexScan inp sc of
      AlexEOF -> alexEOF
      AlexError inp' -> lexError "lexical error"
      -- AQUI SE DEBERIA MODIFICAR...
      AlexSkip  inp' len -> do
        alexSetInput inp'
        alexMonadScanTokens
      AlexToken inp' len action -> do
        alexSetInput inp'
        token <- action inp len
        action (ignorePendingBytes inp) len

lexTokens s = runAlex s $ loop []
    where
      isEof x = case x of { L _ TkEOF _ -> True; _ -> False }
      loop acc = do
        tok <- alexMonadScanTokens
        if isEof tok
        then return (reverse acc)
        else loop (tok:acc)

lexx s = do
    let result = lexTokens s
    case result of
      Right x -> mapM_ (putStrLn . showToken) x
      Left err -> putStrLn err
}
