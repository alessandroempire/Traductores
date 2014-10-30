{
module Lexer
    ( Alex(..)
    , Token(..)
    , Lexeme(..)
    , Position(..)
    , tellLError
    , tellPError
    , runAlex'
    , alexMonadScan
    , getTokens
    ) 
    where

import          Error
import          Lexeme
import          Token
import          TrinityMonad (initialWriter)

import          Control.Monad    (liftM)
import          Data.Maybe       (fromJust)
import          Data.Sequence    (Seq, empty, (|>))
import          Data.List        (intercalate, foldl')
import          Data.List.Split  (splitOn)

}

%wrapper "monadUserState"

--------------------------------------------------------
-- Definiciones de Macros
--------------------------------------------------------

$digit = 0-9  --Dígitos

$alpha       = [a-zA-Z] --Caracteres alfabeticos
$sliteral    = [$printable \n \\ \"]  --Strings literales
$identifiers = [$alpha $digit _]  --Identificadores
$backlash    = ["\\n] --Backslash

@num = $digit+(\.$digit+)?

@inside_string = ($printable # ["\\] | \\$backlash)
@string        = \"@inside_string*\"
@id            = $alpha $identifiers*
@string_error  = \"@inside_string*

--------------------------------------------------------
-- Expresiones Regulares
--------------------------------------------------------

tokens :-
 
    --Espacios en blanco y comentarios
    $white+               ;
    "#".*                 ;

    --Lenguaje
    "program"             { tok' TkProgram         }
    "begin"               { tok' TkBegin           }
    "end"                 { tok' TkEnd             }
    "function"            { tok' TkFunction        } 
    "return"              { tok' TkReturn          }
    ";"                   { tok' TkSemicolon       }
    ","                   { tok' TkComma           }
    ":"                   { tok' TkDoublePoint     }

    --Tipos
    "boolean"             { tok' TkBooleanType     }
    "number"              { tok' TkNumberType      }
    "matrix"              { tok' TkMatrixType      }             
    "row"                 { tok' TkRowType         }
    "col"                 { tok' TkColType         }

    --Brackets
    "("                   { tok' TkLParen          }
    ")"                   { tok' TkRParen          }
    "{"                   { tok' TkLLlaves         }
    "}"                   { tok' TkRLlaves         }
    "["                   { tok' TkLCorche         }
    "]"                   { tok' TkRCorche         }

    --Condicionales
    "if"                  { tok' TkIf              }
    "else"                { tok' TkElse            }
    "then"                { tok' TkThen            }

    --Loops
    "for"                 { tok' TkFor             }
    "do"                  { tok' TkDo              }
    "while"               { tok' TkWhile           }

    --Entrada/Salida
    "print"               { tok' TkPrint           }
    "read"                { tok' TkRead            }

    --Operadores Booleanos
    "&"                   { tok' TkAnd             }
    "|"                   { tok' TkOr              }
    "not"                 { tok' TkNot             }

    "=="                  { tok' TkEqual           }
    "/="                  { tok' TkUnequal         }
    "<="                  { tok' TkLessEq          }
    "<"                   { tok' TkLess            }
    ">="                  { tok' TkGreatEq         }
    ">"                   { tok' TkGreat           }

    --Operadores Aritméticos
    "+"                   { tok' TkSum             }
    "-"                   { tok' TkDiff            }
    "*"                   { tok' TkMul             }
    "/"                   { tok' TkDivEnt          }
    "%"                   { tok' TkModEnt          }
    "div"                 { tok' TkDiv             }
    "mod"                 { tok' TkMod             }
    "'"                   { tok' TkTrans           }

    --Operadores Cruzados 
    ".+."                 { tok' TkCruzSum         }
    ".-."                 { tok' TkCruzDiff        }
    ".*."                 { tok' TkCruzMul         }
    "./."                 { tok' TkCruzDivEnt      }
    ".%."                 { tok' TkCruzModEnt      }
    ".div."               { tok' TkCruzDiv         }
    ".mod."               { tok' TkCruzMod         }

    --Declaraciones/Asignaciones
    "="                   { tok' TkAssign          }
    "use"                 { tok' TkUse             }
    "in"                  { tok' TkIn              }
    "set"                 { tok' TkSet             }

    --Expresiones literales 
    @num                  { tok (TkNumber . read)  }
    "true"                { tok' (TkBoolean True)  }
    "false"               { tok' (TkBoolean False) }
    @string               { tok TkString           }

    --Identificadores
    @id                   { tok TkId               }

    --Error
    .                     { tok (TkError . head)   }
    @string_error         { tok (TkErrorS . dropQuotationMarks 1 0 . backslash)}

{

--------------------------------------------------------
-- Codigo Haskell
--------------------------------------------------------

data AlexUserState = AlexUSt { errors :: Seq Error }

alexInitUserState :: AlexUserState
alexInitUserState = AlexUSt initialWriter

modifyUserState :: (AlexUserState -> AlexUserState) -> Alex ()
modifyUserState f = Alex $ \s -> 
                    let st = alex_ust s 
                    in Right(s {alex_ust = f st},())

getUserState :: Alex AlexUserState
getUserState = Alex (\s -> Right (s,alex_ust s))

alexEOF :: Alex (Lexeme Token)
alexEOF = liftM (Lex TkEOF) alexGetPosition

alexGetPosition :: Alex Position
alexGetPosition = alexGetInput >>= \(p,_,_,_) -> return $ toPosition p

toPosition :: AlexPosn -> Position
toPosition (AlexPn _ r c) = Posn (r, c)

-- Tokens que dependen del input 
tok :: (String -> Token) -> AlexAction (Lexeme Token)
tok f (p,_,_,str) i = return $ Lex (f (take i str)) (toPosition p)

-- Tokens que no dependen del input
tok' :: Token -> AlexAction (Lexeme Token)
tok' = tok . const

runAlex' :: String -> Alex a -> (a, Seq Error)
runAlex' input (Alex f) =
    let Right (st,a) = f state
        ust = errors (alex_ust st)
    in (a, ust)
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

tellLError :: Position -> LexerError -> Alex()
tellLError pos err = modifyUserState $ \st -> 
                      st { errors = errors st |> (LError pos err) }   

tellPError :: Position -> ParseError -> Alex ()
tellPError posn err = modifyUserState $ \st -> 
                      st { errors = errors st |> (PError posn err) }

--getTokens :: String -> (Seq Error, [[Lexeme Token]])
getTokens s = runAlex' s (loop [])
    where
      isEof x  = case x of {  Lex TkEOF _ -> True; _ -> False }
      loop acc = do
        tok <- alexMonadScan
        if isEof tok then return (reverse acc)
                     else loop ([tok]:acc)


backslash :: String -> String
backslash str = foldl' (flip replace) str chars
    where
        replace :: (Char, Char) -> String -> String
        replace (new, old) = intercalate [new] . splitOn ['\\', old]
        chars = [('\a', 'a'), ('\b', 'b'), ('\f', 'f'),
                 ('\n', 'n'), ('\r', 'r'), ('\t', 't'),
                 ('\v', 'v'), ('"', '"'), ('\\', '\\')]

dropQuotationMarks :: Int -> Int -> String -> String
dropQuotationMarks l r = reverse . drop r . reverse . drop l
}
