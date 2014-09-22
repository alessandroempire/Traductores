{
module Lexer1
    ( Token(..)
    , alexScanTokens
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

$skip = [\#] --Posiblemente se borre

@string = \"$sliteral*\"

@id = $alpha $identifiers*


tokens :-

        --Espacios en blanco y comentarios
        $white+               { return TkWhiteS } --poner ;
        "#".*                 { return TkComment } --poner ;

        --Lenguaje
        "program"             { return TkProgram          }
        "begin"               { return TkBegin            }

        -- Errores

-------------------------------------------------------------
{

--Tipo Token
data Token =

    --prueba de los whitespace
    TkWhiteS | TkComment |
    
    --Lenguaje 
    TkProgram | TkBegin 

    deriving (Eq)

--------------------------------------------------------------

instance Show Token where
    show tk = case tk of 

        --prueba 
        TkWhiteS        -> "'White Space'"
        TkComment       -> "'comentario'"

        --Lenguaje
        TkProgram       -> "'program'"
        TkBegin         -> "'begin'"
}
