{
module Lexer3
    ( Token(..)
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

------------------------------------------------------------------------------- 
{

-- The token type:
data Token = Tk AlexPosn Lexeme String

instance Show Token where
    show (Tk p tkn str) = show tkn ++ " '" ++ str ++ "' " ++ showPosn p


data Lexeme =
        TkProgram | TkTrue | TkFalse | TkEOF | TkId | TkString | TkError
        deriving (Eq,Show)

data LexicalError = LexicalError { lexicalErrorPosition :: AlexPosn,
                                   lexicalErrorChar     :: Char } 
                                   deriving(Eq)

--instance Show LexicalError where 
--    show  = "Lexical Error " ++ showPosn ++ showPosn lexicalErrorPosition 


--mkL ::
mkL c (p,_,_,str) len = return (Tk p c (take len str))

--showPosn ::
showPosn (AlexPn _ line col) = "in line " ++ show line ++ " ,column " ++ show col

--ShowToken ::
showToken (Tk p tkn str) = show tkn ++ " '" ++ str ++ "' " ++ showPosn p

alexEOF = return (Tk undefined TkEOF "")

--Debemos redefinir runalex
-- runalex'  :: String -> Alex a -> (err, tok) -> (errors, tokens)
runAlex' input (Alex f) (err, tok) =
    case f state of
        Left msg     -> (msg : err, tok)
        Right (_, a) -> (err,  a : tok)
    where
        state :: AlexState
        state = (AlexState {alex_pos = alexStartPos,
                            alex_inp = input,       
                            alex_chr = '\n',
                            alex_bytes = [],
                            alex_scd = 0})

--redefinir
alexMonadScanTokens = do
  inp <- alexGetInput
  sc  <- alexGetStartCode
  case alexScan inp sc of
    AlexEOF -> alexEOF
    AlexError inp' -> do     --alexError "lexical error"
        return (Tk undefined TkError "lexical error")
        alexSetInput inp'
        alexMonadScan
    AlexSkip  inp' len -> do
        alexSetInput inp'
        alexMonadScan
    AlexToken inp' len action -> do
        alexSetInput inp'
        action (ignorePendingBytes inp) len


lexTokens s = runAlex' s (loop []) ([],[])
    where
      isEof x  = case x of { Tk _ TkEOF _ -> True; _ -> False }
      loop acc = do
        tok <- alexMonadScan
        if isEof tok then return (reverse acc)
                     else loop ([tok]:acc)












------------------------------------------------------------------------------
{-
--
scanTokens string = getTokens string ([], [])

--
getTokens string (e, t) = do
    let token = runAlex string alexMonadScan
    show token
    case token of 
        Right a -> case a of 
                  (Tk _ TkEOF _) -> showLexer
                  (Tk _ l s )    -> getTokens string (e, (l,s):t)
        -- Right a -> show "RIGHT " ++ show a    --getTokens string (e, a:t)
        --Left ms ->  "left"                   --getTokens string (ms:e, t)

showLexer = show "llege"
-}

}
