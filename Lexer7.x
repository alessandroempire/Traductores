{
module Lexer7
    ( Token(..)
    , getTokens
    ) 
    where

import          Control.Monad (liftM)
import          Data.Sequence (Seq, empty, (|>))
import          Data.Maybe    (fromJust)
import          Prelude       hiding (lex)

import Data.Word (Word8)
import qualified Data.Bits
#if __GLASGOW_HASKELL__ >= 603
#include "ghcconfig.h"
#elif defined(__GLASGOW_HASKELL__)
#include "config.h"
#endif
#if __GLASGOW_HASKELL__ >= 503
import Data.Array
import Data.Char (ord)
import Data.Array.Base (unsafeAt)
#else
import Array
import Char (ord)
#endif
#if __GLASGOW_HASKELL__ >= 503
import GHC.Exts
#else
import GlaExts
#endif
}

--Definiciones de Macro

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
 
    --Espacios en blanco y comentarios
    $white+               ;
    "#".*                 ;

    --Lenguaje
    "program"             { lex' TkProgram       }
    "begin"               { lex' TkBegin         }
    "end"                 { lex' TkEnd           }
    "function"            { lex' TkFunction      } 
    "return"              { lex' TkReturn        }
    ";"                   { lex' TkSemicolon     }
    ","                   { lex' TkComma         }
    ":"                   { lex' TkDoublePoint   }

    --Tipos
    "boolean"             { lex' TkBooleanType   }
    "number"              { lex' TkNumberType    }
    "matrix"              { lex' TkMatrixType    }             
    "row"                 { lex' TkRowType       }
    "col"                 { lex' TkColType       }

    --Brackets
    "("                   { lex' TkLParen        }
    ")"                   { lex' TkRParen        }
    "{"                   { lex' TkLLlaves       }
    "}"                   { lex' TkRLlaves       }
    "["                   { lex' TkLCorche       }
    "]"                   { lex' TkRCorche       }        

    --Condicionales
    "if"                  { lex' TkIf            }
    "else"                { lex' TkElse          }
    "then"                { lex' TkThen          }

    --Loops
    "for"                 { lex' TkFor           }
    "do"                  { lex' TkDo            }
    "while"               { lex' TkWhile         }

    --Entrada/Salida
    "print"               { lex' TkPrint         }
    "read"                { lex' TkRead          }

    --Operadores Booleanos
    "&"                   { lex' TkAnd           }
    "|"                   { lex' TkOr            }
    "not"                 { lex' TkNot           }

    "=="                  { lex' TkEqual         }
    "/="                  { lex' TkUnequal       }
    "<="                  { lex' TkLessEq        }
    "<"                   { lex' TkLess          }
    ">="                  { lex' TkGreatEq       }
    ">"                   { lex' TkGreat         }

    --Operadores Aritmeticos
    "+"                   { lex' TkSum           }
    "-"                   { lex' TkDiff          }
    "*"                   { lex' TkMul           }
    "/"                   { lex' TkDivEnt        }
    "%"                   { lex' TkModEnt        }
    "div"                 { lex' TkDiv           }
    "mod"                 { lex' TkMod           }
    "'"                   { lex' TkTrans         }

    --Operadores Cruzados 
    ".+."                 { lex' TkCruzSum       }
    ".-."                 { lex' TkCruzDiff      }
    ".*."                 { lex' TkCruzMul       }
    "./."                 { lex' TkCruzDivEnt    }
    ".%."                 { lex' TkCruzModEnt    }
    ".div."               { lex' TkCruzDiv       }
    ".mod."               { lex' TkCruzMod       }

    --Declaraciones
    "="                   { lex' TkAssign        }
    "use"                 { lex' TkUse           }
    "in"                  { lex' TkIn            }
    "set"                 { lex' TkSet           }

    --Expresiones literales 
    @num                  { lex (TkNumber . read) }
    "true"                { lex' TkBoolean        }
    "false"               { lex' TkBoolean        }
    @string               { lex TkString          }

    --Identificadores
    @id                   { lex TkId             }

------------------------------------------------------------------------------- 
{

data Lexeme a = Lex { lexInfo :: a
                    , lexPosn ::  AlexPosn 
                    }
                 
instance Show a => Show (Lexeme a) where
    show (Lex a pos) = show a ++ " : " ++ showPosn pos

instance Functor Lexeme where
    fmap f (Lex a p) = Lex (f a) p 

--------------------------------------------------------
data Token =

    --Lenguaje 
    TkProgram | TkBegin | TkEnd | TkFunction | TkReturn | TkSemicolon 
    | TkComma | TkDoublePoint

    --Tipos
    | TkBooleanType | TkNumberType | TkMatrixType | TkRowType | TkColType

    --Brackets
    | TkLParen | TkRParen | TkLLlaves | TkRLlaves | TkLCorche | TkRCorche

    --Condicionales
    | TkIf | TkElse | TkThen

    --Loops
    | TkFor | TkDo | TkWhile

    --E/S
    | TkPrint | TkRead

    --Operadores Booleanos
    | TkAnd | TkOr | TkNot | TkEqual | TkUnequal 
    | TkLess | TkLessEq | TkGreat | TkGreatEq

    --Operadores Aritmeticos
    | TkSum | TkDiff | TkMul | TkDivEnt | TkModEnt | TkDiv | TkMod | TkTrans

    --Operadores Cruzados 
    | TkCruzSum | TkCruzDiff | TkCruzMul | TkCruzDivEnt | TkCruzModEnt 
    | TkCruzDiv | TkCruzMod

    --Declaraciones
    | TkAssign | TkUse | TkIn | TkSet

    --Expresiones literales
    | TkNumber  {unTk :: Float } --revisar
    | TkBoolean 
    | TkString  {unTkStr :: String}

    --Identificadores
    | TkId {unTkId :: String }

    --Compilador
    | TkEOF

    deriving (Eq)


instance Show Token where
    show tk = case tk of 

        TkProgram       -> "'program'"
        TkBegin         -> "'begin'"
        TkEnd           -> "'end'"
        TkReturn        -> "'return'"
        TkFunction      -> "'function'"
        TkSemicolon     -> "';'"
        TkComma         -> "','"
        TkDoublePoint    -> "':'"
        TkAssign 	    -> "'='"
        TkUse           -> "'use'"
        TkIn            -> "'in'"
        TkSet           -> "'set'"       
        TkLParen	    -> "'('"
        TkRParen        -> "')'"
        TkLLlaves       -> "'{'"
        TkRLlaves       -> "'}'"
        TkLCorche       -> "'['"
        TkRCorche       -> "']'"
        TkBooleanType   -> "type 'Bool'"
        TkNumberType    -> "type 'Number'"
        TkMatrixType    -> "type 'Matrix'"
        TkRowType       -> "type 'Row'"	
        TkColType       -> "type 'Col'"	
        TkIf            -> "'if'"
        TkElse          -> "'else'"
        TkThen          -> "'then'"
        TkFor           -> "'for'"
        TkDo            -> "'do'"
        TkWhile         -> "'while'"
        TkPrint         -> "'print'"
        TkRead          -> "'read'"
        TkAnd           -> "'&'"
        TkOr            -> "'|'"
        TkNot           -> "'not'"
        TkEqual         -> "'=='"
        TkUnequal       -> "'/='"
        TkLess          -> "'<'"
        TkLessEq        -> "'<='"
        TkGreat         -> "'>'"
        TkGreatEq       -> "'>='"
        TkSum           -> "'+'"
        TkDiff          -> "'-'"
        TkMul           -> "'*'"
        TkDivEnt        -> "'/'"
        TkModEnt        -> "'%'"
        TkDiv           -> "'div'"
        TkMod           -> "'mod'"
        TkTrans         -> "'''"
        TkCruzSum       -> "'.+.'"
        TkCruzDiff      -> "'.-.'"
        TkCruzMul       -> "'.*.'"
        TkCruzDivEnt    -> "'./.'"
        TkCruzModEnt    -> "'.%.'"
        TkCruzDiv       -> "'.div.'"
        TkCruzMod       -> "'.mod.'"
        TkEOF           -> "'EOF'"
        TkNumber n      -> "literal 'Number' " ++ show n
        TkBoolean       -> "literal 'Bool'"
        TkString s      -> "literal 'String' " ++ s
        TkId i          -> "identificador de variable " ++ i



-----------------------------------------------------------

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

getTokens :: String -> (Seq LexicalError, [[Lexeme Token]])
getTokens s = runAlex' s (loop [])
    where
      isEof x  = case x of {  Lex TkEOF _ -> True; _ -> False }
      loop acc = do
        tok <- alexMonadScan
        if isEof tok then return (reverse acc)
                     else loop ([tok]:acc)


---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--Traido del wrapper "UserStateMonad"

-- | Encode a Haskell String to a list of Word8 values, in UTF8 format.
utf8Encode :: Char -> [Word8]
utf8Encode = map fromIntegral . go . ord
 where
  go oc
   | oc <= 0x7f       = [oc]

   | oc <= 0x7ff      = [ 0xc0 + (oc `Data.Bits.shiftR` 6)
                        , 0x80 + oc Data.Bits..&. 0x3f
                        ]

   | oc <= 0xffff     = [ 0xe0 + (oc `Data.Bits.shiftR` 12)
                        , 0x80 + ((oc `Data.Bits.shiftR` 6) Data.Bits..&. 0x3f)
                        , 0x80 + oc Data.Bits..&. 0x3f
                        ]
   | otherwise        = [ 0xf0 + (oc `Data.Bits.shiftR` 18)
                        , 0x80 + ((oc `Data.Bits.shiftR` 12) Data.Bits..&. 0x3f)
                        , 0x80 + ((oc `Data.Bits.shiftR` 6) Data.Bits..&. 0x3f)
                        , 0x80 + oc Data.Bits..&. 0x3f
                        ]



type Byte = Word8

-- -----------------------------------------------------------------------------
-- The input type


type AlexInput = (AlexPosn,     -- current position,
                  Char,         -- previous char
                  [Byte],       -- pending bytes on current char
                  String)       -- current input string

ignorePendingBytes :: AlexInput -> AlexInput
ignorePendingBytes (p,c,ps,s) = (p,c,[],s)

alexInputPrevChar :: AlexInput -> Char
alexInputPrevChar (p,c,bs,s) = c

alexGetByte :: AlexInput -> Maybe (Byte,AlexInput)
alexGetByte (p,c,(b:bs),s) = Just (b,(p,c,bs,s))
alexGetByte (p,c,[],[]) = Nothing
alexGetByte (p,_,[],(c:s))  = let p' = alexMove p c 
                                  (b:bs) = utf8Encode c
                              in p' `seq`  Just (b, (p', c, bs, s))


{-# LINE 89 "templates/wrappers.hs" #-}

{-# LINE 103 "templates/wrappers.hs" #-}

{-# LINE 118 "templates/wrappers.hs" #-}

-- -----------------------------------------------------------------------------
-- Token positions

-- `Posn' records the location of a token in the input text.  It has three
-- fields: the address (number of chacaters preceding the token), line number
-- and column of a token within the file. `start_pos' gives the position of the
-- start of the file and `eof_pos' a standard encoding for the end of file.
-- `move_pos' calculates the new position after traversing a given character,
-- assuming the usual eight character tab stops.


data AlexPosn = AlexPn !Int !Int !Int
        deriving (Eq,Show)

alexStartPos :: AlexPosn
alexStartPos = AlexPn 0 1 1

alexMove :: AlexPosn -> Char -> AlexPosn
alexMove (AlexPn a l c) '\t' = AlexPn (a+1)  l     (((c+7) `div` 8)*8+1)
alexMove (AlexPn a l c) '\n' = AlexPn (a+1) (l+1)   1
alexMove (AlexPn a l c) _    = AlexPn (a+1)  l     (c+1)


-- -----------------------------------------------------------------------------
-- Default monad


data AlexState = AlexState {
        alex_pos :: !AlexPosn,  -- position at current input location
        alex_inp :: String,     -- the current input
        alex_chr :: !Char,      -- the character before the input
        alex_bytes :: [Byte],
        alex_scd :: !Int        -- the current startcode

      , alex_ust :: AlexUserState -- AlexUserState will be defined in the user program

    }

-- Compile with -funbox-strict-fields for best results!

runAlex :: String -> Alex a -> Either String a
runAlex input (Alex f) 
   = case f (AlexState {alex_pos = alexStartPos,
                        alex_inp = input,       
                        alex_chr = '\n',
                        alex_bytes = [],

                        alex_ust = alexInitUserState,

                        alex_scd = 0}) of Left msg -> Left msg
                                          Right ( _, a ) -> Right a

newtype Alex a = Alex { unAlex :: AlexState -> Either String (AlexState, a) }

instance Monad Alex where
  m >>= k  = Alex $ \s -> case unAlex m s of 
                                Left msg -> Left msg
                                Right (s',a) -> unAlex (k a) s'
  return a = Alex $ \s -> Right (s,a)

alexGetInput :: Alex AlexInput
alexGetInput
 = Alex $ \s@AlexState{alex_pos=pos,alex_chr=c,alex_bytes=bs,alex_inp=inp} -> 
        Right (s, (pos,c,bs,inp))

alexSetInput :: AlexInput -> Alex ()
alexSetInput (pos,c,bs,inp)
 = Alex $ \s -> case s{alex_pos=pos,alex_chr=c,alex_bytes=bs,alex_inp=inp} of
                  s@(AlexState{}) -> Right (s, ())

-- agrega los errores al AlexUserState
--alexError ::
alexError pos char = modifyUserState $ \st -> 
                              st { errors = errors st |> (LexicalError pos char)}

-- Modifica el AlexUserState
modifyUserState :: (AlexUserState -> AlexUserState) -> Alex ()
modifyUserState f = Alex $ \s -> 
                    let st = alex_ust s 
                    in Right(s {alex_ust = f st},())

alexGetStartCode :: Alex Int
alexGetStartCode = Alex $ \s@AlexState{alex_scd=sc} -> Right (s, sc)

alexSetStartCode :: Int -> Alex ()
alexSetStartCode sc = Alex $ \s -> Right (s{alex_scd=sc}, ())

-- Auxiliar
--muestra :: AlexInput -> Alex()
muestra inp = Alex $ \s -> Left (show inp)

--
extractInput (_,input) = input

--
extractPos (p,_,_,_) = p

--
extractChar (_,c,_,_) = c

-- Se modifico el alexError para cuando consiga un error, se 
-- modique el alexUserState agregando el caracter que dio error
-- e ignorando el resto de los caraceteres de ese strin. 
alexMonadScan = do
  inp <- alexGetInput
  sc <- alexGetStartCode
  case alexScan inp sc of
    AlexEOF -> alexEOF
    AlexError inp' -> do
        let pos    = extractPos inp'
            newInp = extractInput $ fromJust $ alexGetByte $ 
                       ignorePendingBytes inp'
            char   = extractChar newInp
        alexError pos char
        alexSetInput newInp
        alexMonadScan
    AlexSkip  inp' len -> do
        alexSetInput inp'
        alexMonadScan
    AlexToken inp' len action -> do
        alexSetInput inp'
        action (ignorePendingBytes inp) len

-- Lee el resto de los caracteres del string donde se encuentra el error
-- y los ignora. 
alexMonadScanSkip inp sc = do
  case alexScan inp sc of
    AlexEOF -> alexEOF
    AlexError inp' -> do
        let pos    = extractPos inp'
            newInp = extractInput $ fromJust $ alexGetByte $ 
                       ignorePendingBytes inp'
            char   = extractChar newInp
        alexError pos char
        alexMonadScanSkip newInp sc
    AlexSkip  inp' len -> do
        alexSetInput inp'
        alexMonadScan
    AlexToken inp' len action -> do
        alexSetInput inp'
        alexMonadScan

-- -----------------------------------------------------------------------------
-- Useful token actions

type AlexAction result = AlexInput -> Int -> Alex result

-- just ignore this token and scan another one
-- skip :: AlexAction result
skip input len = alexMonadScan

-- ignore this token, but set the start code to a new value
-- begin :: Int -> AlexAction result
begin code input len = do alexSetStartCode code; alexMonadScan

-- perform an action for this token, and set the start code to a new value
andBegin :: AlexAction result -> Int -> AlexAction result
(action `andBegin` code) input len = do alexSetStartCode code; action input len

token :: (AlexInput -> Int -> token) -> AlexAction token
token t input len = return (t input len)
}
