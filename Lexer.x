{
module Lexer
    ( getToken
    ) where

import Prelude

}

%wrapper "basic"

$digit = 0-9                    -- digitos

$small = [a-z]		            -- caracateres minuscula
$large = [A-Z]                  -- caracteres mayuscula
$alpha = [$small $large]        -- caracteres miniscula y mayuscula

$sliteral    = [$printable \n \\ \n]
$identifiers = [$alpha $digit _] 

@num = $digit+(\.$digit+)?

@skip = [\ \n\t\v] --Posiblemente se borre

@string = \"$sliteral*\"

@id = $alpha $identifiers*


tokens :-

        --Espacios en blanco y comentarios
        $white+               { return TkWhiteS } --poner ;
        "#".*                 { return TkComent } --poner ;

        --Lenguaje
        "program"             { return TkProgram          }
        "begin"               { return TkBegin            }
        "end"                 { return TkEnd              }
        "return"              { return TkReturn           }
        "function"            { return TkFunction         }
        ";"                   { return TkSemicolon        }
        ","                   { return TkComma            }
        ":"                   { return TkDoblePoint       }

        --Brackets
        "("                   { return TkLParen           }
        ")"                   { return TkRParen           }
        "{"                   { return TkLLlaves          }
        "}"                   { return TkRLlaves          }
        "["                   { return TkLCorche          }
        "]"                   { return TkRCorche          }

        --Tipos
        "boolean"             { return TkBooleanType      }
        "number"              { return TkNumberType       }
        "matrix"              { return TkMatrixType       }             
        "row"                 { return TkRowType          }
        "col"                 { return TkColType          }

        -- Statements
        -- -- Declaraciones
        "="                   { return TkAssign           }
        "use"                 { return TkUse              }
        "in"                  { return TkIn               }
        "set"                 { return TkSet              }        

        -- -- Condicionales
        "if"                  { return TkIf               }
        "else"                { return TkElse             }
        "then"                { return TkThen             }

        -- -- Loops
        "for"                 { return TkFor              }
        "do"                  { return TkDo               }
        "while"               { return TkWhile            }

        -- --Entrada/Salida
        "print"               { return TkPrint            }
        "read"                { return TkRead             }

        --Expresiones/Operadores
        -- --Literales 
        @num                  { return (TkNumber  . read) }
        "true"                { return (TkBoolean . read) }
        "false"               { return (TkBoolean . read) }
-        @string               { return (TkString  . read) } --posible error

        -- --Operadores Booleanos
        "&"                   { return TkAnd              }
        "|"                   { return TkOr               }
        "not"                 { return TkNot              }

        "=="                  { return TkEqual            }
        "/="                  { return TkUnequal          }

        "<"                   { return TkLess             }
        "<="                  { return TkLessEq           }
        ">"                   { return TkGreat            }
        ">="                  { return TkGreatEq          }

        -- --Operadores Aritmeticos
        "+"                   { return TkSum              }
        "-"                   { return TkDiff             }
        "*"                   { return TkMul              }
        "/"                   { return TkDivEnt           }
        "%"                   { return TkModEnt           }
        "div"                 { return TkDiv              }
        "mod"                 { return TkMod              }
        "'"                   { return TkTrans            }

        -- -- Operadores Cruzados 
        ".+."                 { return TkCruzSum          }
        ".-."                 { return TkCruzDiff         }
        ".*."                 { return TkCruzMul          }
        "./."                 { return TkCruzDivEnt       }
        ".%."                 { return TkCruzDivEnt       }
        ".div."               { return TkCruzDiv          }
        ".mod."               { return TkCruzMod          }

        -- -- Identificadores (pag 12)
        @id                   { return TkID               } --posible error

        -- Errores

-------------------------------------------------------------
{

--Tipo Token
data Token =
    
    --Lenguaje 
    TkProgram | TkBegin | TkEnd | TkReturn | TkFunction | TkSemicolon | TkComma

    --Declaraciones
    | TkUse | TkIn | TkSet

    --Brackets
    | TkLParen | TkRParen | TkLLlaves | TkRLlaves | TkLCorche | TkRCorche

    --Tipos
    | TkBooleanType | TkNumberType | TkMatrixType | TkRowType | TkColType

    --Condicionales
    | TkIf | TkElse | TkThen

    --Loops
    | TkFor | TkDo | TkWhile

    --E/S
    | TkPrint | TkRead

    --Expresiones/Operadores
    -- --Literales
    | TkNumber { unTkNumber :: Float }
    | TkBoolean { unTkBoolean :: Bool }

    -- --Operadores Booleanos
    | TkAnd | TkOr | TkNot | TkEqual | TkUnequal 
    | TkLess | TkLessEq | TkGreat | TkGreatEq

    -- --Operadores Aritmeticos
    | TkSum | TkDiff | TkMul | TkDivEnt | TkModEnt | TkDiv | TkMod | TkTrans

    deriving (Eq)

--------------------------------------------------------------

instance Show Token where
    show tk = case tk of 

        --Lenguaje
        TkProgram       -> "'program'"
        TkBegin         -> "'begin'"
        TkEnd           -> "'end'"
        TkReturn        -> "'return'"
        TkFunction      -> "'function'"
        TkSemicolon     -> "';'"
        TkComma         -> "','"

        --Declaraciones
        TkUse           -> "'use'" 
        TkIn            -> "'in'"
        TkSet           -> "'set'"

---------------------------------------------------------------
--Funciones

getToken :: String -> [Token]
getToken = alexScanTokens

}
