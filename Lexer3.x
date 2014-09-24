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

$sliteral    = [$printable \n \\ \"] -- strings literales
$identifiers = [$alpha $digit _]     -- identificadores

@num = $digit+(\.$digit+)?

@string = \"$sliteral*\"

@id = $alpha $identifiers*

$graphic = $printable # $white

tokens :-
    $white+              ;
    "program"            { mkL TkProgram }
    "#".*                ;

    "true"               { mkL TkTrue        }
    "false"              { mkL TkFalse       } 
    --@num                 { mkL TkNumber    }
    @id                  { mkL TkId          }
    @string              { mkL TkString      }

    --Error
    .                    { mkL TkOneError } -- un token suelto. 
                                            -- como $ en la mitad de la nada. 
    -- que otro errores?
    -- ejemplos 123program
    -- p@gr@am es un error tambien
    $graphic+         { mkL TkGError    }
 
{

--http://stackoverflow.com/questions/6038573/request-for-comments-on-simple-alex-parser

-- The token type:
data Token = L AlexPosn Lexeme String

data Lexeme =
        TkProgram | TkTrue | TkFalse | TkEOF | TkOneError |
        TkId | TkString | TkGError
        deriving (Eq,Show)

mkL :: Lexeme -> AlexInput -> Int -> Alex Token
mkL c (p,_,_,str) len = return (L p c (take len str))

lexError s = do
    (p,c,_,input) <- alexGetInput
    alexError (s ++ ": " ++ showPosn p)
    alexMonadScanTokens


showPosn (AlexPn _ line col) = "in line " ++ show line ++ " ,column " ++ show col

showToken (L p tkn str) = show tkn ++ " '" ++ str ++ "' " ++ showPosn p

alexEOF = return (L undefined TkEOF "")

alexMonadScanTokens = do
    inp <- alexGetInput
    sc <- alexGetStartCode
    case alexScan inp sc of
      AlexEOF -> alexEOF
      AlexError inp' -> lexError "lexical error" --el isse es a la llamada lexError
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
      isEof x  = case x of { L _ TkEOF _ -> True; _ -> False }
      loop acc = do
        tok <- alexMonadScanTokens
        if isEof tok then return (reverse acc)
                     else loop (tok:acc)

lexx s = do
    let result = lexTokens s
    case result of
      Right x  -> mapM_ (putStrLn . showToken) x
      Left err -> putStrLn err
}
