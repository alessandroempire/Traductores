{

module Lexer
    ( lexx
    ) where

}

%wrapper "monad"

-------------------------------------------------------------
-- Reglas para Alex
-------------------------------------------------------------

$digit = 0-9  --Digitos
$alpha = [a-zA-Z] --Caracteres alfabeticos
$sliteral = [$printable \n \\ \n]  --Strings literales
$identifiers = [$alpha $digit _]  --Identificadores

@num = $digit+(\.$digit+)?

@skip = [\ \n\t\v] --Borrar?

@string = \"$sliteral*\"

@id = $alpha $identifiers*

tokens :-

    --Espacios en blanco y comentarios
    $white+               ;
    "#".*                 ;

    --Lenguaje
    "program"             { mkL TkProgram       }
    "begin"               { mkL TkBegin         }
    "end"                 { mkL TkEnd           }
    "function"            { mkL TkFunction      } 
    "return"              { mkL TkReturn        }
    ";"                   { mkL TkSemicolon     }
    ","                   { mkL TkComma         }
    ":"                   { mkL TkDoublePoint   }

    --Tipos
    "boolean"             { mkL TkBooleanType   }
    "number"              { mkL TkNumberType    }
    "matrix"              { mkL TkMatrixType    }             
    "row"                 { mkL TkRowType       }
    "col"                 { mkL TkColType       }

    --Brackets
    "("                   { mkL TkLParen        }
    ")"                   { mkL TkRParen        }
    "{"                   { mkL TkLLlaves       }
    "}"                   { mkL TkRLlaves       }
    "["                   { mkL TkLCorche       }
    "]"                   { mkL TkRCorche       }        

    --Condicionales
    "if"                  { mkL TkIf            }
    "else"                { mkL TkElse          }
    "then"                { mkL TkThen          }

    --Loops
    "for"                 { mkL TkFor           }
    "do"                  { mkL TkDo            }
    "while"               { mkL TkWhile         }

    --Entrada/Salida
    "print"               { mkL TkPrint         }
    "read"                { mkL TkRead          }

    --Operadores Booleanos
    "&"                   { mkL TkAnd           }
    "|"                   { mkL TkOr            }
    "not"                 { mkL TkNot           }

    "=="                  { mkL TkEqual         }
    "/="                  { mkL TkUnequal       }
    "<="                  { mkL TkLessEq        }
    "<"                   { mkL TkLess          }
    ">="                  { mkL TkGreatEq       }
    ">"                   { mkL TkGreat         }

    --Operadores Aritmeticos
    "+"                   { mkL TkSum           }
    "-"                   { mkL TkDiff          }
    "*"                   { mkL TkMul           }
    "/"                   { mkL TkDivEnt        }
    "%"                   { mkL TkModEnt        }
    "div"                 { mkL TkDiv           }
    "mod"                 { mkL TkMod           }
    "'"                   { mkL TkTrans         }

    --Operadores Cruzados 
    ".+."                 { mkL TkCruzSum       }
    ".-."                 { mkL TkCruzDiff      }
    ".*."                 { mkL TkCruzMul       }
    "./."                 { mkL TkCruzDivEnt    }
    ".%."                 { mkL TkCruzModEnt    }
    ".div."               { mkL TkCruzDiv       }
    ".mod."               { mkL TkCruzMod       }

    --Declaraciones
    "="                   { mkL TkAssign        }
    "use"                 { mkL TkUse           }
    "in"                  { mkL TkIn            }
    "set"                 { mkL TkSet           }

    --Expresiones literales 
    @num                  { mkL TkNumber        }
    "true"                { mkL TkBoolean       }
    "false"               { mkL TkBoolean       }
    @string               { mkL TkString        }

    --Identificadores
    @id                   { mkL TkId            }

-------------------------------------------------------------
-- Codigo Haskell
-------------------------------------------------------------

{

--Tipo Token
data Token = L AlexPosn Lexeme String

--Tipo Lexeme: clases de lexemas de trinity
data Lexeme =
    
    --Lenguaje 
    TkProgram | TkBegin | TkEnd | TkFunction | TkReturn | TkSemicolon | TkComma | TkDoublePoint

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
    | TkCruzSum | TkCruzDiff | TkCruzMul | TkCruzDivEnt | TkCruzModEnt | TkCruzDiv | TkCruzMod

    --Declaraciones
    | TkAssign | TkUse | TkIn | TkSet

    --Expresiones literales
    | TkNumber | TkBoolean | TkString

    --Identificadores
    | TkId

    --Compilador
    | TkEOF

    deriving (Eq, Show)

--instance Show Lexeme where
  --  show lex = case lex of 
     --   TkProgram       -> "'program'"
    --    TkBegin         -> "'begin'"
    --    TkEnd           -> "'end'"
    --    TkFunction      -> "'function'"
    --    TkReturn        -> "'return'"
    --    TkSemicolon     -> "';'"
    --    TkComma         -> "','"
   --    	TkDoublePoint	  -> "':'"
   --     TkBooleanType 	 -> "type 'bool'"
	  --     TkNumberType	   -> "type 'number'"
	     --  TkMatrixType	   -> "type 'Matrix'"
	--       TkRowType	      -> "type 'Row'"	
	--       TkColType	      -> "type 'Col'" 
  --     	TkLParen	       -> "'('"
	--       TkRParen	       -> "')'"
    --   	TkLLlaves      	-> "'{'"
	    --   TkRLlaves	      -> "'}'"
	   --    TkLCorche	      -> "'['"
	    --   TkRCorche	      -> "']'"	
--	       TkIf		          -> "'if'"
	 --      TkElse		        -> "'else'"
	    --   TkThen		        -> "'then'"
	   --    TkFor 		        -> "'for'"
	   --    TkDo		          -> "'do'"
    --   	TkWhile		       -> "'while'"
	  --     TkPrint		       -> "'print'"
	  --     TkRead		        -> "'read'"
   --    	TkAnd		         -> "'&'"
	  --     TkOr		          -> "'|'"
	   --    TkNot		         -> "'not'"
	   --    TkEqual		       -> "'=='"
	     --  TkUnequal	      -> "'/='"
	    --   TkLessEq	       -> "'<='"
	   --    TkLess		        -> "'<'"
	   --    TkGreatEq      	-> "'>='"
	   --    TkGreat		       -> "'>'"
	  --     TkSum	         	-> "'+'"
	  --     TkDiff	        	-> "'-'"
	  --     TkMul	         	-> "'*'"
	  --     TkDivEnt       	-> "'/'"
   --    	TkModEnt       	-> "'%'"
   --    	TkDiv		         -> "'div'"
--	       TkMod		         -> "'mod'"
	 --      TkTrans	       	-> "'''"
	   --    TkCruzSum	      -> "'.+.'"
	     --  TkCruzDiff	     -> "'.-.'"
	   --    TkCruzMul	      -> "'.*.'"
	    --   TkCruzDivEnt	   -> "'./.'"
	   --    TkCruzModEnt	   -> "'.%.'"
	    --   TkCruzDiv	      -> "'.div.'"
	     --  TkCruzMod      	-> "'.mod.'"
     --   TkAssign 	      -> "'='"
      --  TkUse           -> "'use'"
      --  TkIn            -> "'in'"
     --   TkSet           -> "'set'"      
	    --   TkNumber	       -> "literal 'Number'"
	    --   TkBoolean	      -> "literal 'Bool'"
	    --   TkString       	-> "literal 'String'"
	     --  TkId 		         -> "identificador de variable"
      --  TkEOF           -> "'EOF'"
 
-------------------------------------------------------------
-- Funciones
-------------------------------------------------------------

mkL :: Lexeme -> AlexInput -> Int -> Alex Token
mkL c (p,_,_,str) len = return (L p c (take len str))

lexError s = do
    (p,c,_,input) <- alexGetInput
    alexError (s ++ ": " ++ showPosn p)

showPosn (AlexPn _ line col) = "in line " ++ show line ++ ", column " ++ show col

showToken (L p tkn str) = show tkn ++ " '" ++ str ++ "' " ++ showPosn p

alexEOF = return (L undefined TkEOF "")

alexMonadScanTokens = do
    inp <- alexGetInput
    sc <- alexGetStartCode
    case alexScan inp sc of
      AlexEOF -> alexEOF
      AlexError inp' -> lexError "Lexical error"
      -- AQUI SE DEBERIA MODIFICAR...
      AlexSkip  inp' len -> do
        alexSetInput inp'
        alexMonadScanTokens
      AlexToken inp' len action -> do
        alexSetInput inp'
        token <- action inp len
        action (ignorePendingBytes inp) len

lexTokens s = runAlex s $ loop []
    where
      isEof x = case x of { L _ TkEOF _ -> True; _ -> False }
      loop acc = do
        tok <- alexMonadScanTokens
        if isEof tok
        then return (reverse acc)
        else loop (tok:acc)

lexx s = do
    let result = lexTokens s
    case result of
      Right x -> mapM_ (putStrLn . showToken) x
      Left err -> putStrLn err

}
