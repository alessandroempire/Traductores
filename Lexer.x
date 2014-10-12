{
module Lexer
    ( Alex(..)
    , Token(..)
    , Lexeme(..)
    , Position(..)
    , LexicalError
    , runAlex'
    , alexMonadScanTokens
    ) 
    where

import          Lexeme
import          Token

import          Control.Monad (liftM)
import          Data.Maybe    (fromJust)
import          Data.Sequence (Seq, empty, (|>))
import          Prelude       hiding (lex)

}

%wrapper "monadUserState"

--------------------------------------------------------
-- Definiciones de Macros
--------------------------------------------------------

$digit = 0-9  --Dígitos

$alpha = [a-zA-Z] --Caracteres alfabeticos

$sliteral = [$printable \n \\ \"]  --Strings literales

$identifiers = [$alpha $digit _]  --Identificadores

$backlash = ["\\n] --Backslash

@num = $digit+(\.$digit+)?

@inside_string = ($printable # ["\\] | \\$backlash)

@string = \"@inside_string*\"

@id = $alpha $identifiers*

--------------------------------------------------------
-- Expresiones Regulares
--------------------------------------------------------

tokens :-
 
    --Espacios en blanco y comentarios
    $white+               ;
    "#".*                 ;

    --Lenguaje
    "program"             { lex' TkProgram         }
    "begin"               { lex' TkBegin           }
    "end"                 { lex' TkEnd             }
    "function"            { lex' TkFunction        } 
    "return"              { lex' TkReturn          }
    ";"                   { lex' TkSemicolon       }
    ","                   { lex' TkComma           }
    ":"                   { lex' TkDoublePoint     }

    --Tipos
    "boolean"             { lex' TkBooleanType     }
    "number"              { lex' TkNumberType      }
    "matrix"              { lex' TkMatrixType      }             
    "row"                 { lex' TkRowType         }
    "col"                 { lex' TkColType         }

    --Brackets
    "("                   { lex' TkLParen          }
    ")"                   { lex' TkRParen          }
    "{"                   { lex' TkLLlaves         }
    "}"                   { lex' TkRLlaves         }
    "["                   { lex' TkLCorche         }
    "]"                   { lex' TkRCorche         }

    --Condicionales
    "if"                  { lex' TkIf              }
    "else"                { lex' TkElse            }
    "then"                { lex' TkThen            }

    --Loops
    "for"                 { lex' TkFor             }
    "do"                  { lex' TkDo              }
    "while"               { lex' TkWhile           }

    --Entrada/Salida
    "print"               { lex' TkPrint           }
    "read"                { lex' TkRead            }

    --Operadores Booleanos
    "&"                   { lex' TkAnd             }
    "|"                   { lex' TkOr              }
    "not"                 { lex' TkNot             }

    "=="                  { lex' TkEqual           }
    "/="                  { lex' TkUnequal         }
    "<="                  { lex' TkLessEq          }
    "<"                   { lex' TkLess            }
    ">="                  { lex' TkGreatEq         }
    ">"                   { lex' TkGreat           }

    --Operadores Aritméticos
    "+"                   { lex' TkSum             }
    "-"                   { lex' TkDiff            }
    "*"                   { lex' TkMul             }
    "/"                   { lex' TkDivEnt          }
    "%"                   { lex' TkModEnt          }
    "div"                 { lex' TkDiv             }
    "mod"                 { lex' TkMod             }
    "'"                   { lex' TkTrans           }

    --Operadores Cruzados 
    ".+."                 { lex' TkCruzSum         }
    ".-."                 { lex' TkCruzDiff        }
    ".*."                 { lex' TkCruzMul         }
    "./."                 { lex' TkCruzDivEnt      }
    ".%."                 { lex' TkCruzModEnt      }
    ".div."               { lex' TkCruzDiv         }
    ".mod."               { lex' TkCruzMod         }

    --Declaraciones/Asignaciones
    "="                   { lex' TkAssign          }
    "use"                 { lex' TkUse             }
    "in"                  { lex' TkIn              }
    "set"                 { lex' TkSet             }

    --Expresiones literales 
    @num                  { lex (TkNumber . read)  }
    "true"                { lex' (TkBoolean True)  }
    "false"               { lex' (TkBoolean False) }
    @string               { lex TkString           }

    --Identificadores
    @id                   { lex TkId               }

{

--------------------------------------------------------
-- Codigo Haskell
--------------------------------------------------------

data AlexUserState = AlexUSt { errors :: Seq LexicalError}

data LexicalError = LexicalError { lexicalErrorPos  :: Position,
                                   lexicalErrorChar :: Char } 
                                   deriving(Eq)

instance Show LexicalError where 
    show (LexicalError pos char) = "Error Léxico: " ++ show pos 
                                   ++ " " ++ show char

alexInitUserState :: AlexUserState
alexInitUserState = AlexUSt empty

alexEOF :: Alex (Lexeme Token)
alexEOF = liftM (Lex TkEOF) alexGetPosition

--alexGetPosition :: Alex AlexPosn
alexGetPosition = alexGetInput >>= \(p,_,_,_) -> return $ toPosition p

toPosition :: AlexPosn -> Position
toPosition (AlexPn _ r c) = Posn (r, c)

-- Tokens que dependen del input 
lex :: (String -> Token) -> AlexAction (Lexeme Token)
lex f (p,_,_,str) i = return $ Lex (f (take i str)) (toPosition p)

-- Tokens que no dependen del input
lex' :: Token -> AlexAction (Lexeme Token)
lex' = lex . const

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

alexError' :: AlexPosn -> Char -> Alex()
alexError' pos char = modifyUserState $ \st -> 
                         st { errors = errors st |> 
                            (LexicalError (toPosition pos) char)}

modifyUserState :: (AlexUserState -> AlexUserState) -> Alex ()
modifyUserState f = Alex $ \s -> 
                    let st = alex_ust s 
                    in Right(s {alex_ust = f st},())

extractInput :: (Byte, AlexInput) -> AlexInput
extractInput (_,input) = input

extractPos :: AlexInput -> AlexPosn
extractPos (p,_,_,_) = p

extractChar :: AlexInput -> Char
extractChar (_,c,_,_) = c

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
