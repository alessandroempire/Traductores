{-# LANGUAGE LambdaCase #-}

module Error
    ( Error(..)
    , LexerError(..)
    , ParseError(..)
    , StaticError(..)
    , Warning(..)
    , isError
    ) where

import           Program
import           SymbolTable

import           Data.Foldable                 (toList)
import           Data.Function                 (on)
import           Data.List                     (intercalate)
import           Data.Sequence                 (Seq)

data Error
    = LError Position LexerError
    | PError Position ParseError
    | SError Position StaticError
    | Warn Position Warning

instance Show Error where
    show = \case
        LError p e -> "Lexical Error: " ++ show p 
                       ++ "\n\t" ++ show e ++ "\n" 
        PError p e -> "Parse Error: " ++ show p 
                       ++ "\n\t" ++ show e ++ "\n"
        SError p e -> "Static Error: "  ++ show p 
                       ++ "\n\t" ++ show e ++ "\n"
        Warn p w -> "Warning: " ++ show p 
                       ++ "\n\t" ++ show w ++ "\n"

instance Eq Error where
    (==) = (==) `on` errorPos

instance Ord Error where
    compare = compare `on` errorPos

---------------------------------------------------------------------

data LexerError  
   = LexerError     String
   | UnexpectedChar Char 
   | StringError    String

instance Show LexerError where
    show = \case
        LexerError msg   -> msg
        UnexpectedChar c -> "Caracter inesperado '" ++ [c] ++ "'"
        StringError str  -> "Expresion faltante en String " ++ show str

---------------------------------------------------------------------

data ParseError
    = ParseError String
    | UnexpectedToken String

instance Show ParseError where
    show = \case
        ParseError msg      -> msg
        UnexpectedToken tok -> "Token inesperado '" ++ show tok ++ "'"

---------------------------------------------------------------------

data StaticError 
    = StaticError String
    | AlreadyDeclared Identifier Position
    | InvalidAssignType Identifier DataType DataType
    | WrongCategory Identifier SymbolCategory SymbolCategory
    | ReturnType DataType DataType Identifier
    | NotDefined Identifier
    | ReadNonReadable DataType Identifier
    | PrintNonPrintable DataType
    | ConditionDataType DataType
    | ForInDataType DataType
    | InvalidAccess Identifier DataType
    | IndexAssignType DataType Identifier
    | ProyIndexDataType DataType
    | FunctionNotDefined Identifier
    | FunctionArguments Identifier (Seq DataType) (Seq DataType)
    | NoReturn Identifier
    | BinaryTypes Binary (DataType, DataType)
    | UnaryTypes Unary DataType
    | LitMatricial 

instance Show StaticError where
    show = \case
        StaticError msg -> msg
        AlreadyDeclared var p  -> "Identificador '" ++ var ++ "' fue declarado previamente en la " ++ show p
        InvalidAssignType var vt et -> "Asignando '" ++ show et ++ "' a variable '" ++ var ++ "' de tipo '" ++ show vt ++ "'"
        WrongCategory id cat g -> "Usando '" ++ id ++ "' como " ++ show cat ++ ", pero es una " ++ show g
        ReturnType e g fname -> "Tipo de retorno invalido '" ++ show e ++ "' para funcion '" ++ fname ++ "' de tipo '" ++ show g ++ "'"
        NotDefined iden -> "Identificador '" ++ iden ++ "' no ha sido definido"
        ReadNonReadable dt id -> "Variable '" ++ id ++ "' de tipo '" ++ show dt ++ "' no puede ser usada en instrucciones 'read'"
        PrintNonPrintable dt -> "Instruccion 'print' para tipo '" ++ show dt ++ "' no soportada"
        ConditionDataType dt -> "Condicion debe ser de tipo 'Bool', pero tiene tipo '" ++ show dt ++ "'"
        ForInDataType dt -> "Instruccion 'for' debe iterar sobre expresiones de tipo 'Matrix(r,c)', pero tiene tipo '" ++ show dt ++ "'"
        InvalidAccess id dt -> "Intentando accesar al identificador '" ++ show id ++ "' de tipo '" ++ show dt ++ "'"
        IndexAssignType dt id -> "Indice de acceso a '" ++ show id ++ "' debe ser entero, pero tiene tipo '" ++ show dt ++ "'"
        ProyIndexDataType dt -> "Indice de proyeccion matricial debe ser entero, pero tiene tipo '" ++ show dt ++ "'"
        FunctionNotDefined fname -> "Funcion '" ++ fname ++ "' no ha sido definida"
        FunctionArguments fname e g -> "Funcion '" ++ fname ++ "' espera argumentos (" ++ showSign e ++ 
                                    "), pero recibio (" ++ showSign g ++ ")"
            where
                showSign = intercalate ", " . map show . toList
        --Operadores
        BinaryTypes op (dl, dr) -> "el operador '" ++ show op ++
                                   "' no funciona con los operandos (" ++ 
                                   show dl ++ ", " ++ show dr  ++ ")"
        UnaryTypes op dt -> "el operador '" ++ show op ++ 
                            "' no funcion con el operador (" ++ show dt ++ ")"
        NoReturn fname -> "Funcion '" ++ fname ++ "' no tiene instruccion 'return'"
        -- Literal Matricial
        LitMatricial -> "Error en las expresiones del literal matricial"

       
---------------------------------------------------------------------

data Warning
    = Warning String
    | CaseOfBool
    | VariableDefinedNotUsed Identifier
    | FunctionDefinedNotUsed Identifier

instance Show Warning where
    show = \case
        Warning msg -> msg
--        CaseOfBool -> "case expression is of type 'Bool', consider using an 'if-then-else' statement"
        VariableDefinedNotUsed id -> "Identificador '" ++ id ++ "' definida pero no usada"
        FunctionDefinedNotUsed id -> "Funcion '"   ++ id ++ "' definida pero no usada"

---------------------------------------------------------------------

isError :: Error -> Bool
isError = \case
    Warn _ _ -> False
    _        -> True

errorPos :: Error -> Position
errorPos error = case error of
    LError p _ -> p
    PError p _ -> p
    SError p _ -> p
    Warn p _ -> p

