{
module Lexer3
    ( Token(..)
    ) 
    where

import Data.Sequence (Seq, empty, (|>))
}

%wrapper "monadUserState"

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

data Token = Tk AlexPosn Lexeme String

instance Show Token where
    show (Tk p tkn str) = show tkn ++ " '" ++ str ++ "' " ++ showPosn p
 
data Lexeme =
        TkProgram | TkTrue | TkFalse | TkEOF | TkId | TkString | TkError
        deriving (Eq,Show)


data AlexUserState = AlexUSt { errors :: Seq LexicalError}

data LexicalError = LexicalError { lexicalErrorPos  :: AlexPosn,
                                   lexicalErrorChar :: Char } 
                                   deriving(Eq)

instance Show LexicalError where 
    show (LexicalError pos char) = show "Lexical Error " ++ showPosn pos 
                                   ++ show char

---------------------------------------------------------

--alexInitUserState :: AlexUserState
alexInitUserState = AlexUSt empty

--mkL ::
mkL c (p,_,_,str) len = return (Tk p c (take len str))

--showPosn ::
showPosn (AlexPn _ line col) = "in line " ++ show line ++ " ,column " ++ show col

--ShowToken ::
showToken (Tk p tkn str) = show tkn ++ " '" ++ str ++ "' " ++ showPosn p

alexEOF = return (Tk undefined TkEOF "")

<<<<<<< HEAD
-- runalex'  :: String -> Alex a -> (err, tok) -> (errors, tokens)
=======
---------------------------------------------------------

-- runalex'  :: String -> Alex a -> ( Seq LexicalError, a)
>>>>>>> c12ca55cedd975676404e3231b5951d77e6e84e0
runAlex' input (Alex f) =
    let Right ( st, a) = f state
        ust           = errors (alex_ust st)
        x = getState st
    in (x, a)
    where
        state :: AlexState
        state = AlexState { alex_pos   = alexStartPos
                          , alex_inp   = input 
                          , alex_chr   = '\n'
                          , alex_bytes = []
                          , alex_ust   = alexInitUserState
                          , alex_scd   = 0}
         

<<<<<<< HEAD
--alexError' :: AlexInput -> Alex ()
alexError' = do
    (pos, c, _, string) <- alexGetInput
    tellLError pos c
    return (Tk undefined TkError "")
=======
getState :: AlexState -> String
getState AlexState { alex_pos = a , alex_inp = x , alex_chr = b, alex_bytes = c, alex_ust = d , alex_scd = e } = x




--alexError' :: AlexInput -> Alex ()
alexError' (pos, c, _, string) = do tellLError pos c
                                    return (Tk pos TkError string) 

>>>>>>> c12ca55cedd975676404e3231b5951d77e6e84e0

--getUserState :: Alex AlexUserState
getUserState = Alex (\s -> Right (s,alex_ust s))

--modifyUserState :: (AlexUserState -> AlexUserState) -> Alex ()
modifyUserState f = Alex $ \s -> 
                            let st = alex_ust s in Right (s {alex_ust = f st},())

--
tellLError posn err = modifyUserState $ \st -> 
                      st { errors = errors st |> (LexicalError posn err) }

--redefinir
alexMonadScanTokens = do
  inp <- alexGetInput
  sc  <- alexGetStartCode
  case alexScan inp sc of
    AlexEOF -> alexEOF
    AlexError inp' -> alexError'
    AlexSkip  inp' len -> do
        alexSetInput inp'
        alexMonadScan
    AlexToken inp' len action -> do
        alexSetInput inp'
        action (ignorePendingBytes inp) len

lexTokens s = runAlex' s (loop [])
    where
      isEof x  = case x of { Tk _ TkEOF _ -> True; _ -> False }
      loop acc = do
        tok <- alexMonadScanTokens
        if isEof tok then return (reverse acc)
                     else loop ([tok]:acc)
}
