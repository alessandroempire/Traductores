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
        TkProgram | TkTrue | TkFalse | TkEOF | TkId | TkString
        deriving (Eq,Show)


data AlexUserState = AlexUSt { errors :: Seq LexicalError}

--alexInitUserState :: AlexUserState
alexInitUserState = AlexUSt empty


modifyUserState :: (AlexUserState -> AlexUserState) -> Alex ()
modifyUserState f = Alex $ \s -> let st = alex_ust s in Right (s {alex_ust = f st},())

getUserState :: Alex AlexUserState
getUserState = Alex (\s -> Right (s,alex_ust s))

data LexicalError = LexicalError { lexicalErrorPos  :: AlexPosn,
                                   lexicalErrorChar :: Char } 
                                   deriving(Eq)

instance Show LexicalError where 
    show (LexicalError pos char) = show "Lexical Error " ++ showPosn pos 
                                   ++ show char


--mkL ::
mkL c (p,_,_,str) len = return (Tk p c (take len str))

--showPosn ::
showPosn (AlexPn _ line col) = "in line " ++ show line ++ " ,column " ++ show col

--ShowToken ::
showToken (Tk p tkn str) = show tkn ++ " '" ++ str ++ "' " ++ showPosn p

alexEOF = return (Tk undefined TkEOF "")

-- runalex'  :: String -> Alex a -> (err, tok) -> (errors, tokens)
runAlex' input (Alex f) =
    let Right (st, a) = f state
        ust           = errors (alex_ust st)
    in (ust, a)
    where
        state :: AlexState
        state = AlexState { alex_pos   = alexStartPos
                           , alex_inp   = input 
                           , alex_chr   = '\n'
                           , alex_bytes = []
                           , alex_ust   = alexInitUserState
                           , alex_scd   = 0}

alexError' :: AlexInput -> Alex ()
alexError' (pos, c, _, string) = tellLError pos c


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
    AlexError inp' -> alexError' inp
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
        tok <- alexMonadScan
        if isEof tok then return (reverse acc)
                     else loop ([tok]:acc)
}
