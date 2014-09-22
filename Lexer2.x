{
module Lexer2 
    ( Token(..)
    , AlexPosn(..)
    , alexScanTokens
    , token_posn) 
    where
}

%wrapper "posn"

$digit = 0-9			-- digits
$alpha = [a-zA-Z]		-- alphabetic characters

tokens :-

    "program"            { tok (\p s -> TkProgram p ) }

 
{
-- Each right-hand side has type :: AlexPosn -> String -> Token

tok f p s = f p s

-- The token type:
data Token =
	TkProgram AlexPosn		
--	In  AlexPosn		|
--	Sym AlexPosn Char	|
--	Var AlexPosn String	|
--	Int AlexPosn Int
	deriving (Eq,Show)

token_posn (TkProgram p) = p
--token_posn (In p) = p
--token_posn (Sym p _) = p
--token_posn (Var p _) = p
--token_posn (Int p _) = p
}
