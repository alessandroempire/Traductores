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
    | ConditionDataType DataType
    | ForInDataType DataType
    | ForVariable Identifier DataType
    | InvalidAccess Identifier DataType
    | IndexAssignType DataType Identifier
    | ProyIndexDataType DataType
    | FunctionNotDefined Identifier
    | FunctionArguments Identifier (Seq DataType) (Seq DataType)
    | BinaryTypes Binary (DataType, DataType)
    | UnaryTypes Unary DataType
    | LitMatricial 
    | MatrixSize
    | ProyMatrixExpression DataType
    | ProyVectorExpression DataType
    | NumElemCol
    | NumElemRow
    | NumElemMatrix
    | OperacionesCol Binary (Lexeme Double) (Lexeme Double)
    | OperacionesRow Binary (Lexeme Double) (Lexeme Double)
    | MulMatrix (Lexeme Double) (Lexeme Double)
    | MulRC (Lexeme Double) (Lexeme Double)
    | Ey

instance Show StaticError where
    show = \case
        StaticError msg -> msg
        AlreadyDeclared var p  -> "Identificador '" ++ var ++ "' fue declarado previamente en la " ++ show p
        InvalidAssignType var vt et -> "Asignando '" ++ show et ++ "' a variable '" ++ var ++ "' de tipo '" ++ show vt ++ "'"
        WrongCategory id cat g -> "Usando '" ++ id ++ "' como " ++ show cat ++ ", pero es una " ++ show g
        ReturnType e g fname -> "Tipo de retorno invalido '" ++ show e ++ "' para funcion '" ++ fname ++ "' de tipo '" ++ show g ++ "'"
        NotDefined iden -> "Identificador '" ++ iden ++ "' no ha sido definido"
        ReadNonReadable dt id -> "Variable '" ++ id ++ "' de tipo '" ++ show dt ++ "' no puede ser usada en instrucciones 'read'"
        ConditionDataType dt -> "Condicion debe ser de tipo 'Bool', pero tiene tipo '" ++ show dt ++ "'"
        ForVariable id dt -> "Variable " ++ show id ++ " debe ser de tipo 'Number', pero tiene tipo '" ++ show dt ++ "'"
        ForInDataType dt -> "Instruccion 'for' debe iterar sobre expresiones de tipo 'Matrix(r,c)', pero tiene tipo '" ++ show dt ++ "'"
        InvalidAccess id dt -> "Intentando accesar al identificador '" ++ show id ++ "' de tipo '" ++ show dt ++ "'"
        IndexAssignType dt id -> "Indice de acceso a '" ++ show id ++ "' debe ser entero, pero tiene tipo '" ++ show dt ++ "'"
        ProyIndexDataType dt -> "Indice de proyeccion matricial debe ser entero, pero tiene tipo '" ++ show dt ++ "'"
        FunctionNotDefined fname -> "Funcion '" ++ fname ++ "' no ha sido definida"
        FunctionArguments fname e g -> "Funcion '" ++ fname ++ "' espera argumentos (" ++ showSign e ++ 
                                       "), pero recibio (" ++ showSign g ++ ")"
        BinaryTypes op (dl, dr) -> "Operador binario '" ++ show op ++ "' no funciona con los operandos de tipo (" ++ 
                                    show dl ++ ", " ++ show dr  ++ ")"
        UnaryTypes op dt -> "Operador unario '" ++ show op ++ 
                            "' no funciona con el operando de tipo (" ++ show dt ++ ")"
        LitMatricial -> "No son expresiones numericas los elementos de la literal matricial "
        MatrixSize -> "Longitudes de la matriz deben ser enteros positivos "
        ProyMatrixExpression dt -> "Expresion de proyeccion matricial tiene tipo '" ++ show dt ++ "'"
        ProyVectorExpression dt -> "Expresion de proyeccion vectorial tiene tipo '" ++ show dt ++ "'"
        NumElemCol -> "Error en el numero de elementos de la columna Col " 
        NumElemRow -> "Error en el numero de elementos de la fila Row" 
        NumElemMatrix -> "Error en el numero de elementos de la matriz "
        OperacionesCol op l1 l2 -> "Error en la operacion aritmetica '" ++ show op ++ 
            "' debido a que hay un numero incorrecto de elementos en la columna de la matriz (_, " ++  
            show l1 ++ ") y (_ ," ++ show l2 ++ ")"
        OperacionesRow op l1 l2 -> "Error en la operacion aritmetica '" ++ show op ++ 
            "' debido a que hay un numero incorrecto de elementos en la fila de la matriz (" 
            ++ show l1 ++ " , _) y (" ++ show l2 ++ " , _)"
        MulMatrix l1 l2 -> "Error en la multiplicacion de matrices ya que no coinciden (_, " ++ 
            show l1 ++ ") con (" ++ show l2 ++ " ,_)"
        MulRC l1 l2 -> "Error en la multiplicacion de Rows y Col ya que no coinciden (" ++ 
            show l1 ++ ") con (" ++ show l2 ++ ")"
        Ey -> "eeey"

showSign :: Seq DataType -> [Char]
showSign = intercalate ", " . map show . toList
       
---------------------------------------------------------------------

data Warning
    = Warning String
    | CaseOfBool
    | VariableDefinedNotUsed Identifier
    | FunctionDefinedNotUsed Identifier

instance Show Warning where
    show = \case
        Warning msg -> msg
        VariableDefinedNotUsed id -> "Identificador '" ++ id ++ "' definido pero no usado"
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
    Warn p _   -> p

