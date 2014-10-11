{
module Lexer
    ( Alex(..),
      Token(..),
      Lexeme(..),
      LexicalError,
      showPosn,
      runAlex',
      alexMonadScanTokens,
      fillLex
    ) 
    where

import          Control.Monad (liftM)
import          Data.Maybe    (fromJust)
import          Data.Sequence (Seq, empty, (|>))
import          Prelude       hiding (lex)

}

%wrapper "monadUserState"

--------------------------------------------------------
-- Definiciones de Macros
--------------------------------------------------------

$digit = 0-9  --Digitos

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

    --Operadores Aritmeticos
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
--Codigo Alex
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

    --Declaraciones/Asignaciones
    | TkAssign | TkUse | TkIn | TkSet

    --Expresiones literales
    | TkNumber  { unTkNumber :: Double }
    | TkBoolean { unTkBoolean :: Bool } 
    | TkString  { unTkString :: String }

    --Identificadores
    | TkId { unTkId :: String }

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
        TkDoublePoint   -> "':'"
        TkAssign        -> "'='"
        TkUse           -> "'use'"
        TkIn            -> "'in'"
        TkSet           -> "'set'"       
        TkLParen        -> "'('"
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
        TkBoolean b      -> "literal 'Bool' " ++ show b
        TkString s      -> "literal 'String' " ++ s
        TkId i          -> "identificador de variable " ++ i

--------------------------------------------------------
-- Codigo Haskell
--------------------------------------------------------

data Lexeme a = Lex { lexInfo :: a
                    , lexPosn ::  AlexPosn 
                    }
                 
instance Show a => Show (Lexeme a) where
    show (Lex a pos) = show a ++ " : " ++ showPosn pos

instance Functor Lexeme where
    fmap f (Lex a p) = Lex (f a) p 

data AlexUserState = AlexUSt { errors :: Seq LexicalError}

data LexicalError = LexicalError { lexicalErrorPos  :: AlexPosn,
                                   lexicalErrorChar :: Char } 
                                   deriving(Eq)

instance Show LexicalError where 
    show (LexicalError pos char) = "Error Léxico: " ++ showPosn pos 
                                   ++ " " ++ show char
fillLex :: a -> Lexeme a
fillLex lex = Lex lex (AlexPn 0 0 0)

alexInitUserState :: AlexUserState
alexInitUserState = AlexUSt empty

alexEOF :: Alex (Lexeme Token)
alexEOF = liftM (Lex TkEOF) alexGetPosition

alexGetPosition :: Alex AlexPosn
alexGetPosition = alexGetInput >>= \(p,_,_,_) -> return p

showPosn :: AlexPosn -> String
showPosn (AlexPn _ line col) = "en la linea " ++ show line ++ ", columna " ++ show col

-- Tokens que dependen del input 
lex :: (String -> Token) -> AlexAction (Lexeme Token)
lex f (p,_,_,str) i = return $ Lex (f (take i str)) (p)

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
                              st { errors = errors st |> (LexicalError pos char)}

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
