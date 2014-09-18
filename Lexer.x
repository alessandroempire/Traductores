{
{ -|
      Lexer for programming language trinity
}

module Lexer 
    (
    ) where

}

-------------------------------------------------------------

tokens :-

    --Language
    program                 { lex' TkProgram }
    use                     { lex' TkUse}

    -- -- Brackets

    -- Types
    -- boolean                 { lex' TkBooleanType }


    -- Expressions/ Operators


----------------------------------------------------------------------
{
data Token = 

    -- Language
    TkProgram | TkUse

instance Show Token where
    show tk = case tk of 
        TkProgram       -> "'newline'"
        TkUse           -> "'end'"

-----------------------------------------------------------------------


}
