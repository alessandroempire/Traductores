{
module Lexer6
    ( Token(..)
    ) 
    where

import          Control.Monad (liftM)
import          Data.Sequence (Seq, empty, (|>))
import          Prelude       hiding (lex)

}

%wrapper "monadUserState"

$digit = 0-9  --Digitos
$alpha = [a-zA-Z] --Caracteres alfabeticos
$sliteral = [$printable \n \\ \"]  --Strings literales
$identifiers = [$alpha $digit _]  --Identificadores

$backlash = ["\\n]

@num = $digit+(\.$digit+)?

@inside_string = ($printable # ["\\] | \\$backlash)

@string = \"@inside_string*\"

@id = $alpha $identifiers*

tokens :-
    $white+              ;
    "program"            { lex' TkProgram }
    "#".*                ;

    "true"               { lex' TkTrue        }
    "false"              { lex' TkFalse       } 
    --FALTA REVISAR LOS NUMEROS!
    @id                  { lex TkId         }
    @string              { lex TkString      }

------------------------------------------------------------------------------- 
{

data Lexeme a = Lex { lexInfo :: a
                    , lexPosn ::  AlexPosn 
                    }
                 
instance Show a => Show (Lexeme a) where
    show (Lex a pos) = show a ++ " : " ++ showPosn pos

instance Functor Lexeme where
    fmap f (Lex a p) = Lex (f a) p 


data Token =
        TkProgram 
        | TkTrue  
        | TkFalse  
        | TkEOF  
        --  | num     {unTknum :: Float  }
        | TkId     {unTkId :: String  }
        | TkString {unTkStr :: String }
        | TkError
        deriving (Eq)


instance Show Token where
    show tk = case tk of 
        TkProgram  -> "'program'"
        TkTrue     -> "'true' "
        TkFalse    -> "'false'"
        TkId a     -> "Identificador de variable: " ++ a
        TkString a -> "String: " ++ a 

data AlexUserState = AlexUSt { errors :: Seq LexicalError}

data LexicalError = LexicalError { lexicalErrorPos  :: AlexPosn,
                                   lexicalErrorChar :: String } 
                                   deriving(Eq)

instance Show LexicalError where 
    show (LexicalError pos char) = show "Lexical Error " ++ showPosn pos 
                                   ++ show char

---------------------------------------------------------

--alexInitUserState :: AlexUserState
alexInitUserState = AlexUSt empty

alexEOF :: Alex (Lexeme Token)
alexEOF = liftM (Lex TkEOF) alexGetPosition

alexGetPosition = alexGetInput >>= \(p,_,_,_) -> return p

--showPosn ::
showPosn (AlexPn _ line col) = "in line " ++ show line ++ " ,column " ++ show col
 
lex :: (String -> Token) -> AlexAction (Lexeme Token)
lex f (p,_,_,str) i = return $ Lex (f (take i str)) (p)
--lex f (p,_,_,str) i = return $ f (take i str)

-- Para Tokens que no dependen del input
lex' :: Token -> AlexAction (Lexeme Token)
lex' = lex . const

----------------------------------------------------------------------
runAlex' :: String -> Alex a -> (Seq LexicalError, a)
runAlex' input (Alex f) =
    let Right (st,a) = f state
        ust = errors (alex_ust st)
    in (ust,a)
    where
        state :: AlexState
        state = AlexState
            { alex_pos   = alexStartPos
            , alex_inp   = input
            , alex_chr   = '\n'
            , alex_bytes = []
            , alex_ust   = alexInitUserState
            , alex_scd   = 0
            }

lexTokens s = runAlex' s (loop [])
    where
      isEof x  = case x of { Lex TkEOF _ -> True; _ -> False }
      loop acc = do
        tok <- alexMonadScan
        if isEof tok then return (reverse acc)
                     else loop ([tok]:acc)


-------------------------------------------
--alexError' :: AlexInput -> Alex ()
alexError' (pos, c, _, string) = return $ Lex TkError pos
--return $ LexicalError pos string


--getUserState :: Alex AlexUserState
getUserState = Alex (\s -> Right (s,alex_ust s))

--modifyUserState :: (AlexUserState -> AlexUserState) -> Alex ()
modifyUserState f = Alex $ \s -> 
                            let st = alex_ust s in Right (s {alex_ust = f st},())

--
tellLError posn err = modifyUserState $ \st -> 
                      st { errors = errors st |> (LexicalError posn err) }

--redefinir
--alexMoandScanTokens :: Alex (Lexeme a)
alexMonadScanTokens = do
  inp <- alexGetInput
  sc  <- alexGetStartCode
  case alexScan inp sc of
    AlexEOF -> alexEOF
    AlexError inp' -> alexError' inp'
    AlexSkip  inp' len -> do
        alexSetInput inp'
        alexMonadScan
    AlexToken inp' len action -> do
        alexSetInput inp'
        action (ignorePendingBytes inp) len

                         
}
