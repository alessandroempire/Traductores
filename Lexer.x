{
module Lexer
    ( getToken
    ) where

import Prelude
}

%wrapper "basic"

$digit = 0-9			    -- digits

$small = [a-z]		        -- caracateres minuscula
$large = [A-Z]              -- caracteres mayuscula
$alpha = [$small $large]    -- caracteres miniscula y mayuscula

@numero = $digit+(\.$digit+)?


tokens :-

        --Lenguaje
        "program"             { return TkProgram    }
        "end"                 { return TkEnd        }
        "set"                 { return TkSet        }
        ";"                   { return TkSemicolon  }
        ","                   { return TkComma      }

        --Declaraciones
        "use"                 { return TkUse        }
        "in"                  { return TkIn         }

        --Brackets
        "("                   { return TkLParen     }
        ")"                   { return TkRParen     }
        "{"                   { return TkLLlaves    }
        "}"                   { return TkRLlaves    }
        "["                   { return TkLCorche    }
        "]"                   { return TkRCorche          }


        --Tipos
        "boolean"             { return TkBoolean          }
        "number"              { return TkNumber           }
        --"matrix"             
        --"row"
        --"col"

        --Condicionales
        "if"
        "else"

        --Loops
        "for"

        --Expresiones/ Operadores

        -- -- Literales 
        @numero               { return (TkNumber . read)   }
        "true"                { return (TkBoolean . read)  }
        "false"

        -- -- Boolean 
        "&"
        "|"
        "not" 

        "=="
        "/="

        "<"
        "<="
        ">"
        ">="

        -- -- Aritmetico
        "+"
        "-"
        "*"
        "/"
        "%"
        "div"
        "mod"
        "'"



-------------------------------------------------------------
{

--El tipo Token

data Token =
    
    --Lenguaje 
    TkUse | TkProgram
    deriving (Eq)


--------------------------------------------------------------
--

instance Show Token where
    show tk = case tk of 

        --Lenguaje
        TkUse           -> "'use'"
        TkProgram       -> "'program'"


---------------------------------------------------------------
--Funciones

getToken :: String -> [Token]
getToken = alexScanTokens

}
