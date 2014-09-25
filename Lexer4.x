{
module Lexer4
    ( 
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
    --.                    { mkL TkOneError } -- un token suelto. 
                                            -- como $ en la mitad de la nada. 
    -- que otro errores?
    -- ejemplos 123program
    -- p@gr@am es un error tambien
    -- $graphic+         { mkL TkGError    }
 
{

-- The token type:
data Token = Tk AlexPosn Lexeme String

instance Show Token where
    show (Tk p tkn str) = show tkn ++ " '" ++ str ++ "' " ++ showPosn p

--showPosn ::
showPosn (AlexPn _ line col) = "in line " ++ show line ++ " ,column " ++ show col

data Lexeme =
        TkProgram | TkTrue | TkFalse | TkEOF | TkId | TkString |
        TkError
        deriving (Eq,Show)

--mkL :: Monad m => Lexeme -> (AlexPosn, t, t1, [Char]) -> Int -> Alex Token
--mkL :: Monad m => Lexeme -> AlexState -> Int -> m Token
-- -> Alex Token
mkL c (p,_,_,str) len = return (Tk p c (take len str))

alexEOF = return (Tk undefined TkEOF "")

lexError inp = return (Tk undefined TkError printString )
    where
        printString 

alexMonadScanToken = do
  inp <- alexGetInput
  sc  <- alexGetStartCode
  case alexScan inp sc of
    AlexEOF -> alexEOF
    AlexError inp' -> lexError inp
    AlexSkip  inp' len -> do
        alexSetInput inp'
        alexMonadScan
    AlexToken inp' len action -> do
        alexSetInput inp'
        action (ignorePendingBytes inp) len


--lexTokens string [a] -> [Either]
lexTokens string array = lexTokens string (getTokens : array)
    where
        getTokens acc = do
            tok <- alexMonadScanToken
            if isEof tok then return (reverse acc)
                          else getTokens (tok:acc)
        isEof x  = case x of { Tk _ TkEOF _ -> True; _ -> False }

--scanTokens ::
scanTokens string = lexTokens string []

--quiero arreglo
}
