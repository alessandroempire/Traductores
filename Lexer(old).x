{
module Lexer
    ( Token(..)
    , getTokens
    ) 
    where

import          Control.Monad (liftM)
import          Data.Sequence (Seq, empty, (|>))
import          Data.Maybe    (fromJust)
import          Prelude       hiding (lex)


}

%wrapper "monadUserState"

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
    | TkNumber  {unTk :: Double } --revisar
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

alexInitUserState :: AlexUserState
alexInitUserState = AlexUSt empty

alexEOF :: Alex (Lexeme Token)
alexEOF = liftM (Lex TkEOF) alexGetPosition

alexGetPosition :: Alex AlexPosn
alexGetPosition = alexGetInput >>= \(p,_,_,_) -> return p

showPosn :: AlexPosn -> String
showPosn (AlexPn _ line col) = "in line " ++ show line ++ " ,column " ++ show col
 
lex :: (String -> Token) -> AlexAction (Lexeme Token)
lex f (p,_,_,str) i = return $ Lex (f (take i str)) (p)

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
        tok <- alexMonadScanTokens
        if isEof tok then return (reverse acc)
                     else loop ([tok]:acc)

-- agrega los errores al AlexUserState
alexError' :: AlexPosn -> Char -> Alex()
alexError' pos char = modifyUserState $ \st -> 
                              st { errors = errors st |> (LexicalError pos char)}

-- Modifica el AlexUserState
modifyUserState :: (AlexUserState -> AlexUserState) -> Alex ()
modifyUserState f = Alex $ \s -> 
                    let st = alex_ust s 
                    in Right(s {alex_ust = f st},())

-- Auxiliar
--muestra :: AlexInput -> Alex()
--muestra inp = Alex $ \s -> Left (show inp)

extractInput :: (Byte, AlexInput) -> AlexInput
extractInput (_,input) = input

extractPos :: AlexInput -> AlexPosn
extractPos (p,_,_,_) = p

extractChar :: AlexInput -> Char
extractChar (_,c,_,_) = c

-- Se modifico el alexError para cuando consiga un error, se 
-- modique el alexUserState agregando el caracter que dio error
-- e ignorando el resto de los caraceteres de ese strin. 
alexMonadScanTokens :: Alex (Lexeme Token)
alexMonadScanTokens = do
  inp <- alexGetInput
  sc <- alexGetStartCode
  case alexScan inp sc of
    AlexEOF -> alexEOF
    AlexError inp' -> do
        let pos    = extractPos inp'
            newInp = extractInput $ fromJust $ alexGetByte $ 
                       ignorePendingBytes inp'
            char   = extractChar newInp
        alexError' pos char
        alexSetInput newInp
        alexMonadScan
    AlexSkip  inp' len -> do
        alexSetInput inp'
        alexMonadScan
    AlexToken inp' len action -> do
        alexSetInput inp'
        action (ignorePendingBytes inp) len
}