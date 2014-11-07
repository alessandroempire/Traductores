{-# LANGUAGE LambdaCase #-}

module Expression
    ( Expression(..)
    , Access(..)
    , Binary(..)
    , Unary(..)
    , binaryOperation
    , binaryOperationMatrix
    , binaryOperationRow
    , binaryOperationCol
    , binaryOperationMC
    , binaryMatrixMul
    , binaryRCMul
    , unaryOperation
    , isComparable
    ) where

import          DataType
import          Identifier
import          Lexeme

import          Data.Sequence (Seq, fromList)
import          Data.Functor ((<$), (<$>))
import          Data.Foldable (concatMap, find)
import          Control.Applicative
import          Prelude       hiding (concatMap)

data Expression
    = LitNumber (Lexeme Number)
    | LitBool (Lexeme Bool)
    | LitString (Lexeme String)
    | VariableId (Lexeme Identifier)
    | LitMatrix [Seq (Lexeme Expression)]
    | ProyM (Lexeme Expression) (Lexeme Expression) (Lexeme Expression)
    | ProyRC (Lexeme Expression) (Lexeme Expression)
    | ExpBinary (Lexeme Binary) (Lexeme Expression) (Lexeme Expression)
    | ExpUnary (Lexeme Unary) (Lexeme Expression)
    deriving (Eq, Ord)

instance Show Expression where
    show = \case
        LitNumber vL        -> "Literal numérico: " ++ show (lexInfo vL)
        LitBool vL          -> "Literal booleano: " ++ show (lexInfo vL)
        LitString strL      -> "Literal string: "   ++ show (lexInfo strL)
        VariableId accL     -> "Identificador de variable: " ++ show (lexInfo accL)
        LitMatrix expS      -> "Literal Matricial: { " ++ " }"
        ProyM expL indexlL indexrL -> "Proyección: " ++ show (lexInfo expL) ++ "[" 
                                ++ show (lexInfo indexlL) ++ "," ++ show (lexInfo indexrL) ++ "]"
        ProyRC expL indexL  -> "Proyección: " ++ show (lexInfo expL) ++ "[" ++ show (lexInfo indexL) ++ "]"                
        ExpBinary opL lL rL -> "Operador Binario: " ++ show (lexInfo lL) ++ " " 
                                ++ show (lexInfo opL) ++ " " ++ show (lexInfo rL)
        ExpUnary opL expL   -> "Operador Unario: " ++ show (lexInfo opL) ++ " " 
                                ++ show (lexInfo expL)

---------------------------------------------------------------------

data Access 
    = VariableAccess (Lexeme Identifier)
    | MatrixAccess (Lexeme Identifier) (Lexeme Expression) (Lexeme Expression)
    | RCAccess (Lexeme Identifier) (Lexeme Expression)
    deriving (Eq, Ord)

instance Show Access where
    show = \case
        VariableAccess idnL     -> lexInfo idnL
        MatrixAccess idnL sizeR sizeC -> lexInfo idnL ++ "[" ++ show (lexInfo sizeR) 
                                   ++ "," ++ show (lexInfo sizeC) ++ "]"
        RCAccess idnL expL -> lexInfo idnL ++ "[" ++ show (lexInfo expL) ++ "]"

---------------------------------------------------------------------

data Binary
    = OpSum | OpDiff | OpMul | OpDivEnt | OpModEnt | OpDiv | OpMod
    | OpCruzSum | OpCruzDiff | OpCruzMul | OpCruzDivEnt | OpCruzModEnt
    | OpCruzDiv | OpCruzMod
    | OpEqual | OpUnequal | OpLess | OpLessEq | OpGreat | OpGreatEq
    | OpOr | OpAnd
    deriving (Eq, Ord)

instance Show Binary where
    show = \case
        OpSum        -> "+"
        OpDiff       -> "-"
        OpMul        -> "*"
        OpDivEnt     -> "/"
        OpModEnt     -> "%"
        OpDiv        -> "div"
        OpMod        -> "mod"
        OpCruzSum    -> ".+."
        OpCruzDiff   -> ".-."
        OpCruzMul    -> ".*."
        OpCruzDivEnt -> "./."
        OpCruzModEnt -> ".%."
        OpCruzDiv    -> ".div."
        OpCruzMod    -> ".mod."
        OpEqual      -> "=="
        OpUnequal    -> "/="
        OpLess       -> "<"
        OpLessEq     -> "<="
        OpGreat      -> ">" 
        OpGreatEq    -> ">="
        OpOr         -> "|"
        OpAnd        -> "&"
  
  


--NO BORRAR: (fmap (+) l1) <*> l3) ((fmap (+) l2) <*> l4)
-- siendo l1 y l3 Lex Double 

--multiplicacion de matrices
binaryMatrixMul :: Binary -> (DataType, DataType) -> Maybe DataType
binaryMatrixMul op dts@(Matrix l1 l2, Matrix l3 l4) = 
    snd <$> find ((dts ==) . fst) (mul op)
    where 
        mul = fromList . \case
            OpMul -> [((Matrix l1 l2, Matrix l3 l4), Matrix l1 l4)]

--multiplicacion de rows y col
binaryRCMul :: Binary -> (DataType, DataType) -> Maybe DataType
binaryRCMul op dts@(Col l1, Row l2) = 
    snd <$> find ((dts ==) . fst) (mul op)
    where 
        mul = fromList . \case
            OpMul -> [((Col l1, Row l2), 
                      Matrix (Lex 1.0 defaultPosn) (Lex 1.0 defaultPosn))]

--operaciones sobre matrices
binaryOperationMatrix :: Binary -> (DataType, DataType) -> Maybe DataType
binaryOperationMatrix op dts@(Matrix l1 l2, Matrix l3 l4) = 
    snd <$> find ((dts ==) . fst) (matrixOperator op)
    where 
        matrixOperator = fromList . \case
            OpSum     -> [((Matrix l1 l2, Matrix l3 l4), Matrix l1 l2)]
            OpDiff    -> [((Matrix l1 l2, Matrix l3 l4), Matrix l1 l2)]
            OpEqual   -> [((Matrix l1 l2, Matrix l3 l4), Bool)]
            OpUnequal -> [((Matrix l1 l2, Matrix l3 l4), Bool)]
            _         -> [((TypeError, TypeError),TypeError)] 
                         --cualquier otro caso fallara

--operaciones sobre col
binaryOperationCol :: Binary -> (DataType, DataType) -> Maybe DataType
binaryOperationCol op dts@(Col l1, Col l2) = 
    snd <$> find ((dts ==) . fst) (colOperator op)
    where 
        colOperator = fromList . \case
            OpSum     -> [((Col l1, Col l2), Col l1)]
            OpDiff    -> [((Col l1, Col l2), Col l1)]
            OpEqual   -> [((Col l1, Col l2), Bool)]
            OpUnequal -> [((Col l1, Col l2), Bool)]
            _         -> [((TypeError, TypeError),TypeError)] 
                         --cualquier otro caso fallara

--operaciones sobre row
binaryOperationRow :: Binary -> (DataType, DataType) -> Maybe DataType
binaryOperationRow op dts@(Row l1, Row l2) = 
    snd <$> find ((dts ==) . fst) (rowOperator op)
    where 
        rowOperator = fromList . \case
            OpSum     -> [((Row l1, Row l2), Row l1)]
            OpDiff    -> [((Row l1, Row l2), Row l1)]
            OpEqual   -> [((Row l1, Row l2), Bool)]
            OpUnequal -> [((Row l1, Row l2), Bool)]
            _         -> [((TypeError, TypeError),TypeError)]
                         --cualquier otro caso fallara

--cruzados
binaryOperationMC :: Binary -> (DataType, DataType) -> Maybe DataType
binaryOperationMC op dts@(Matrix l1 l2, Number) = 
    snd <$> find ((dts ==) . fst) (cruzOperator op)
    where 
        cruzado = [((Matrix l1 l2, Number), Matrix l1 l2)]
        cruzOperator = fromList . \case
                OpCruzSum    -> cruzado
                OpCruzDiff   -> cruzado
                OpCruzMul    -> cruzado
                OpCruzDivEnt -> cruzado
                OpCruzModEnt -> cruzado
                OpCruzDiv    -> cruzado
                OpCruzMod    -> cruzado
                _            -> [((TypeError, TypeError),TypeError)] 
                                --cualquier otro caso fallara

--El resto de las operaciones que no son con matrices
binaryOperation :: Binary -> (DataType, DataType) -> Maybe DataType
binaryOperation op dts = snd <$> find ((dts ==) . fst) (binaryOperator op)

binaryOperator :: Binary -> Seq ((DataType, DataType), DataType)
binaryOperator = fromList . \case
    OpSum        -> numeric
    OpDiff       -> numeric
    OpMul        -> numeric
    OpDivEnt     -> numeric
    OpModEnt     -> numeric
    OpDiv        -> numeric
    OpMod        -> numeric
    OpEqual      -> everythingCompare
    OpUnequal    -> everythingCompare
    OpLess       -> arithmeticCompare
    OpLessEq     -> arithmeticCompare
    OpGreat      -> arithmeticCompare
    OpGreatEq    -> arithmeticCompare
    OpOr         -> boolean
    OpAnd        -> boolean
    _            -> [((TypeError, TypeError),TypeError)] 
                    --cualquier otro caso falla

    where    
        numeric           = [((Number, Number), Number)]
        boolean           = [((Bool, Bool), Bool)]
        arithmeticCompare = [((Number, Number), Bool)]
        everythingCompare = arithmeticCompare ++ boolean
{-
        cruzado           = cruzadoM1 ++ cruzadoC2 ++ cruzadoC1 ++ cruzadoC2 ++
                            cruzadoR1 ++ cruzadoR2
        cruzadoM1         = [((Matrix lexD lexD, Number), Matrix lexD lexD)] 
        cruzadoM2         = [((Number, Matrix lexD lexD), Matrix lexD lexD)]
        cruzadoC1         = [((Col lexD, Number), Col lexD)]
        cruzadoC2         = [((Number, Col lexD), Col lexD)] 
        cruzadoR1         = [((Number, Row lexD), Row lexD)]
        cruzadoR2         = [((Row lexD, Number), Row lexD)]

-}
lexD :: Lexeme Number
lexD = Lex 0.0 defaultPosn
---------------------------------------------------------------------

data Unary 
    = OpNegative
    | OpNot
    | OpTranspose
    deriving (Eq, Ord)

instance Show Unary where
    show = \case
        OpNegative   -> "-"
        OpNot        -> "not"
        OpTranspose  -> "transpose"

unaryOperation :: Unary -> DataType -> Maybe DataType
unaryOperation op dt = snd <$> find ((dt==) . fst) (unaryOperator op)

unaryOperator :: Unary -> Seq (DataType, DataType)
unaryOperator = fromList . \case
    OpNegative  -> [(Number, Number)] ++ matrixes
    OpNot       -> [(Bool, Bool)]
    OpTranspose -> matrixes
    where 
        matrixes = [(Matrix lexD lexD, Matrix lexD lexD),
                   (Row lexD, Row lexD), (Col lexD, Col lexD)]

---------------------------------------------------------------------

isComparable :: Binary -> Bool
isComparable = flip elem [OpEqual,OpUnequal,OpLess,OpLessEq,OpGreat,OpGreatEq]

