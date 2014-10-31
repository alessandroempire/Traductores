{-# OPTIONS_GHC -w #-}
module Parser
    ( parseProgram
    ) 
    where

import          Error
import          Lexer
import          Program

import          Control.Monad        (unless)
import          Data.Functor         ((<$>),(<$))
import          Data.Maybe           (fromJust, isJust)
import          Data.Foldable        (concatMap)
import          Data.Sequence hiding (length)
import          Prelude       hiding (concatMap, foldr, zip)

-- parser produced by Happy Version 1.18.10

data HappyAbsSyn 
	= HappyTerminal (Lexeme Token)
	| HappyErrorToken Int
	| HappyAbsSyn4 (Program)
	| HappyAbsSyn5 (FunctionSeq)
	| HappyAbsSyn7 (Lexeme Function)
	| HappyAbsSyn8 (StatementSeq)
	| HappyAbsSyn10 (Lexeme Statement)
	| HappyAbsSyn11 (DeclarationSeq)
	| HappyAbsSyn15 (Lexeme Declaration)
	| HappyAbsSyn17 (Seq (Lexeme Expression))
	| HappyAbsSyn19 ([Seq (Lexeme Expression)])
	| HappyAbsSyn20 (Lexeme Expression)
	| HappyAbsSyn21 (Lexeme Double)
	| HappyAbsSyn22 (Lexeme Bool)
	| HappyAbsSyn23 (Lexeme String)
	| HappyAbsSyn24 (Lexeme Access)
	| HappyAbsSyn25 (Lexeme Identifier)
	| HappyAbsSyn26 (Lexeme DataType)

{- to allow type-synonyms as our monads (likely
 - with explicitly-specified bind and return)
 - in Haskell98, it seems that with
 - /type M a = .../, then /(HappyReduction M)/
 - is not allowed.  But Happy is a
 - code-generator that can just substitute it.
type HappyReduction m = 
	   Int 
	-> (Lexeme Token)
	-> HappyState (Lexeme Token) (HappyStk HappyAbsSyn -> m HappyAbsSyn)
	-> [HappyState (Lexeme Token) (HappyStk HappyAbsSyn -> m HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> m HappyAbsSyn
-}

action_0,
 action_1,
 action_2,
 action_3,
 action_4,
 action_5,
 action_6,
 action_7,
 action_8,
 action_9,
 action_10,
 action_11,
 action_12,
 action_13,
 action_14,
 action_15,
 action_16,
 action_17,
 action_18,
 action_19,
 action_20,
 action_21,
 action_22,
 action_23,
 action_24,
 action_25,
 action_26,
 action_27,
 action_28,
 action_29,
 action_30,
 action_31,
 action_32,
 action_33,
 action_34,
 action_35,
 action_36,
 action_37,
 action_38,
 action_39,
 action_40,
 action_41,
 action_42,
 action_43,
 action_44,
 action_45,
 action_46,
 action_47,
 action_48,
 action_49,
 action_50,
 action_51,
 action_52,
 action_53,
 action_54,
 action_55,
 action_56,
 action_57,
 action_58,
 action_59,
 action_60,
 action_61,
 action_62,
 action_63,
 action_64,
 action_65,
 action_66,
 action_67,
 action_68,
 action_69,
 action_70,
 action_71,
 action_72,
 action_73,
 action_74,
 action_75,
 action_76,
 action_77,
 action_78,
 action_79,
 action_80,
 action_81,
 action_82,
 action_83,
 action_84,
 action_85,
 action_86,
 action_87,
 action_88,
 action_89,
 action_90,
 action_91,
 action_92,
 action_93,
 action_94,
 action_95,
 action_96,
 action_97,
 action_98,
 action_99,
 action_100,
 action_101,
 action_102,
 action_103,
 action_104,
 action_105,
 action_106,
 action_107,
 action_108,
 action_109,
 action_110,
 action_111,
 action_112,
 action_113,
 action_114,
 action_115,
 action_116,
 action_117,
 action_118,
 action_119,
 action_120,
 action_121,
 action_122,
 action_123,
 action_124,
 action_125,
 action_126,
 action_127,
 action_128,
 action_129,
 action_130,
 action_131,
 action_132,
 action_133,
 action_134,
 action_135,
 action_136,
 action_137,
 action_138,
 action_139,
 action_140,
 action_141,
 action_142,
 action_143,
 action_144,
 action_145,
 action_146,
 action_147,
 action_148,
 action_149,
 action_150,
 action_151,
 action_152,
 action_153,
 action_154,
 action_155,
 action_156,
 action_157,
 action_158,
 action_159,
 action_160,
 action_161,
 action_162,
 action_163,
 action_164,
 action_165,
 action_166,
 action_167,
 action_168,
 action_169,
 action_170,
 action_171,
 action_172,
 action_173 :: () => Int -> ({-HappyReduction (Alex) = -}
	   Int 
	-> (Lexeme Token)
	-> HappyState (Lexeme Token) (HappyStk HappyAbsSyn -> (Alex) HappyAbsSyn)
	-> [HappyState (Lexeme Token) (HappyStk HappyAbsSyn -> (Alex) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> (Alex) HappyAbsSyn)

happyReduce_1,
 happyReduce_2,
 happyReduce_3,
 happyReduce_4,
 happyReduce_5,
 happyReduce_6,
 happyReduce_7,
 happyReduce_8,
 happyReduce_9,
 happyReduce_10,
 happyReduce_11,
 happyReduce_12,
 happyReduce_13,
 happyReduce_14,
 happyReduce_15,
 happyReduce_16,
 happyReduce_17,
 happyReduce_18,
 happyReduce_19,
 happyReduce_20,
 happyReduce_21,
 happyReduce_22,
 happyReduce_23,
 happyReduce_24,
 happyReduce_25,
 happyReduce_26,
 happyReduce_27,
 happyReduce_28,
 happyReduce_29,
 happyReduce_30,
 happyReduce_31,
 happyReduce_32,
 happyReduce_33,
 happyReduce_34,
 happyReduce_35,
 happyReduce_36,
 happyReduce_37,
 happyReduce_38,
 happyReduce_39,
 happyReduce_40,
 happyReduce_41,
 happyReduce_42,
 happyReduce_43,
 happyReduce_44,
 happyReduce_45,
 happyReduce_46,
 happyReduce_47,
 happyReduce_48,
 happyReduce_49,
 happyReduce_50,
 happyReduce_51,
 happyReduce_52,
 happyReduce_53,
 happyReduce_54,
 happyReduce_55,
 happyReduce_56,
 happyReduce_57,
 happyReduce_58,
 happyReduce_59,
 happyReduce_60,
 happyReduce_61,
 happyReduce_62,
 happyReduce_63,
 happyReduce_64,
 happyReduce_65,
 happyReduce_66,
 happyReduce_67,
 happyReduce_68,
 happyReduce_69,
 happyReduce_70,
 happyReduce_71,
 happyReduce_72,
 happyReduce_73,
 happyReduce_74,
 happyReduce_75,
 happyReduce_76,
 happyReduce_77,
 happyReduce_78,
 happyReduce_79,
 happyReduce_80,
 happyReduce_81 :: () => ({-HappyReduction (Alex) = -}
	   Int 
	-> (Lexeme Token)
	-> HappyState (Lexeme Token) (HappyStk HappyAbsSyn -> (Alex) HappyAbsSyn)
	-> [HappyState (Lexeme Token) (HappyStk HappyAbsSyn -> (Alex) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> (Alex) HappyAbsSyn)

action_0 (30) = happyShift action_5
action_0 (4) = happyGoto action_6
action_0 (5) = happyGoto action_2
action_0 (6) = happyGoto action_3
action_0 (7) = happyGoto action_4
action_0 _ = happyReduce_2

action_1 (30) = happyShift action_5
action_1 (5) = happyGoto action_2
action_1 (6) = happyGoto action_3
action_1 (7) = happyGoto action_4
action_1 _ = happyFail

action_2 (27) = happyShift action_10
action_2 _ = happyFail

action_3 (32) = happyShift action_9
action_3 _ = happyFail

action_4 _ = happyReduce_4

action_5 (86) = happyShift action_8
action_5 (25) = happyGoto action_7
action_5 _ = happyFail

action_6 (87) = happyAccept
action_6 _ = happyFail

action_7 (40) = happyShift action_24
action_7 _ = happyFail

action_8 _ = happyReduce_76

action_9 (30) = happyShift action_5
action_9 (7) = happyGoto action_23
action_9 _ = happyReduce_3

action_10 (31) = happyShift action_15
action_10 (46) = happyShift action_16
action_10 (49) = happyShift action_17
action_10 (51) = happyShift action_18
action_10 (52) = happyShift action_19
action_10 (53) = happyShift action_20
action_10 (79) = happyShift action_21
action_10 (81) = happyShift action_22
action_10 (86) = happyShift action_8
action_10 (8) = happyGoto action_11
action_10 (9) = happyGoto action_12
action_10 (10) = happyGoto action_13
action_10 (25) = happyGoto action_14
action_10 _ = happyReduce_7

action_11 (29) = happyShift action_61
action_11 _ = happyFail

action_12 (32) = happyShift action_60
action_12 _ = happyFail

action_13 _ = happyReduce_9

action_14 (40) = happyShift action_59
action_14 _ = happyFail

action_15 (40) = happyShift action_47
action_15 (42) = happyShift action_48
action_15 (56) = happyShift action_49
action_15 (64) = happyShift action_50
action_15 (82) = happyShift action_51
action_15 (83) = happyShift action_52
action_15 (84) = happyShift action_53
action_15 (85) = happyShift action_54
action_15 (86) = happyShift action_8
action_15 (20) = happyGoto action_58
action_15 (21) = happyGoto action_43
action_15 (22) = happyGoto action_44
action_15 (23) = happyGoto action_45
action_15 (25) = happyGoto action_46
action_15 _ = happyFail

action_16 (40) = happyShift action_47
action_16 (42) = happyShift action_48
action_16 (56) = happyShift action_49
action_16 (64) = happyShift action_50
action_16 (82) = happyShift action_51
action_16 (83) = happyShift action_52
action_16 (84) = happyShift action_53
action_16 (85) = happyShift action_54
action_16 (86) = happyShift action_8
action_16 (20) = happyGoto action_57
action_16 (21) = happyGoto action_43
action_16 (22) = happyGoto action_44
action_16 (23) = happyGoto action_45
action_16 (25) = happyGoto action_46
action_16 _ = happyFail

action_17 (86) = happyShift action_8
action_17 (25) = happyGoto action_56
action_17 _ = happyFail

action_18 (40) = happyShift action_47
action_18 (42) = happyShift action_48
action_18 (56) = happyShift action_49
action_18 (64) = happyShift action_50
action_18 (82) = happyShift action_51
action_18 (83) = happyShift action_52
action_18 (84) = happyShift action_53
action_18 (85) = happyShift action_54
action_18 (86) = happyShift action_8
action_18 (20) = happyGoto action_55
action_18 (21) = happyGoto action_43
action_18 (22) = happyGoto action_44
action_18 (23) = happyGoto action_45
action_18 (25) = happyGoto action_46
action_18 _ = happyFail

action_19 (40) = happyShift action_47
action_19 (42) = happyShift action_48
action_19 (56) = happyShift action_49
action_19 (64) = happyShift action_50
action_19 (82) = happyShift action_51
action_19 (83) = happyShift action_52
action_19 (84) = happyShift action_53
action_19 (85) = happyShift action_54
action_19 (86) = happyShift action_8
action_19 (18) = happyGoto action_41
action_19 (20) = happyGoto action_42
action_19 (21) = happyGoto action_43
action_19 (22) = happyGoto action_44
action_19 (23) = happyGoto action_45
action_19 (25) = happyGoto action_46
action_19 _ = happyFail

action_20 (86) = happyShift action_8
action_20 (25) = happyGoto action_40
action_20 _ = happyFail

action_21 (35) = happyShift action_29
action_21 (36) = happyShift action_30
action_21 (37) = happyShift action_31
action_21 (38) = happyShift action_32
action_21 (39) = happyShift action_33
action_21 (11) = happyGoto action_36
action_21 (12) = happyGoto action_37
action_21 (15) = happyGoto action_38
action_21 (26) = happyGoto action_39
action_21 _ = happyReduce_21

action_22 (86) = happyShift action_8
action_22 (24) = happyGoto action_34
action_22 (25) = happyGoto action_35
action_22 _ = happyFail

action_23 _ = happyReduce_5

action_24 (35) = happyShift action_29
action_24 (36) = happyShift action_30
action_24 (37) = happyShift action_31
action_24 (38) = happyShift action_32
action_24 (39) = happyShift action_33
action_24 (13) = happyGoto action_25
action_24 (14) = happyGoto action_26
action_24 (16) = happyGoto action_27
action_24 (26) = happyGoto action_28
action_24 _ = happyReduce_25

action_25 (41) = happyShift action_109
action_25 _ = happyFail

action_26 (33) = happyShift action_108
action_26 _ = happyReduce_26

action_27 _ = happyReduce_27

action_28 (86) = happyShift action_8
action_28 (25) = happyGoto action_107
action_28 _ = happyFail

action_29 _ = happyReduce_77

action_30 _ = happyReduce_78

action_31 (40) = happyShift action_106
action_31 _ = happyFail

action_32 (40) = happyShift action_105
action_32 _ = happyFail

action_33 (40) = happyShift action_104
action_33 _ = happyFail

action_34 (78) = happyShift action_103
action_34 _ = happyFail

action_35 (44) = happyShift action_102
action_35 _ = happyReduce_74

action_36 (80) = happyShift action_101
action_36 _ = happyFail

action_37 (32) = happyShift action_100
action_37 _ = happyFail

action_38 _ = happyReduce_23

action_39 (86) = happyShift action_8
action_39 (25) = happyGoto action_99
action_39 _ = happyFail

action_40 _ = happyReduce_18

action_41 (33) = happyShift action_98
action_41 _ = happyReduce_19

action_42 (44) = happyShift action_66
action_42 (54) = happyShift action_67
action_42 (55) = happyShift action_68
action_42 (57) = happyShift action_69
action_42 (58) = happyShift action_70
action_42 (59) = happyShift action_71
action_42 (60) = happyShift action_72
action_42 (61) = happyShift action_73
action_42 (62) = happyShift action_74
action_42 (63) = happyShift action_75
action_42 (64) = happyShift action_76
action_42 (65) = happyShift action_77
action_42 (66) = happyShift action_78
action_42 (67) = happyShift action_79
action_42 (68) = happyShift action_80
action_42 (69) = happyShift action_81
action_42 (70) = happyShift action_82
action_42 (71) = happyShift action_83
action_42 (72) = happyShift action_84
action_42 (73) = happyShift action_85
action_42 (74) = happyShift action_86
action_42 (75) = happyShift action_87
action_42 (76) = happyShift action_88
action_42 (77) = happyShift action_89
action_42 _ = happyReduce_34

action_43 _ = happyReduce_38

action_44 _ = happyReduce_39

action_45 _ = happyReduce_40

action_46 _ = happyReduce_41

action_47 (40) = happyShift action_47
action_47 (42) = happyShift action_48
action_47 (56) = happyShift action_49
action_47 (64) = happyShift action_50
action_47 (82) = happyShift action_51
action_47 (83) = happyShift action_52
action_47 (84) = happyShift action_53
action_47 (85) = happyShift action_54
action_47 (86) = happyShift action_8
action_47 (20) = happyGoto action_97
action_47 (21) = happyGoto action_43
action_47 (22) = happyGoto action_44
action_47 (23) = happyGoto action_45
action_47 (25) = happyGoto action_46
action_47 _ = happyFail

action_48 (40) = happyShift action_47
action_48 (42) = happyShift action_48
action_48 (56) = happyShift action_49
action_48 (64) = happyShift action_50
action_48 (82) = happyShift action_51
action_48 (83) = happyShift action_52
action_48 (84) = happyShift action_53
action_48 (85) = happyShift action_54
action_48 (86) = happyShift action_8
action_48 (18) = happyGoto action_95
action_48 (19) = happyGoto action_96
action_48 (20) = happyGoto action_42
action_48 (21) = happyGoto action_43
action_48 (22) = happyGoto action_44
action_48 (23) = happyGoto action_45
action_48 (25) = happyGoto action_46
action_48 _ = happyFail

action_49 (40) = happyShift action_47
action_49 (42) = happyShift action_48
action_49 (56) = happyShift action_49
action_49 (64) = happyShift action_50
action_49 (82) = happyShift action_51
action_49 (83) = happyShift action_52
action_49 (84) = happyShift action_53
action_49 (85) = happyShift action_54
action_49 (86) = happyShift action_8
action_49 (20) = happyGoto action_94
action_49 (21) = happyGoto action_43
action_49 (22) = happyGoto action_44
action_49 (23) = happyGoto action_45
action_49 (25) = happyGoto action_46
action_49 _ = happyFail

action_50 (40) = happyShift action_47
action_50 (42) = happyShift action_48
action_50 (56) = happyShift action_49
action_50 (64) = happyShift action_50
action_50 (82) = happyShift action_51
action_50 (83) = happyShift action_52
action_50 (84) = happyShift action_53
action_50 (85) = happyShift action_54
action_50 (86) = happyShift action_8
action_50 (20) = happyGoto action_93
action_50 (21) = happyGoto action_43
action_50 (22) = happyGoto action_44
action_50 (23) = happyGoto action_45
action_50 (25) = happyGoto action_46
action_50 _ = happyFail

action_51 _ = happyReduce_70

action_52 _ = happyReduce_71

action_53 _ = happyReduce_72

action_54 _ = happyReduce_73

action_55 (44) = happyShift action_66
action_55 (50) = happyShift action_92
action_55 (54) = happyShift action_67
action_55 (55) = happyShift action_68
action_55 (57) = happyShift action_69
action_55 (58) = happyShift action_70
action_55 (59) = happyShift action_71
action_55 (60) = happyShift action_72
action_55 (61) = happyShift action_73
action_55 (62) = happyShift action_74
action_55 (63) = happyShift action_75
action_55 (64) = happyShift action_76
action_55 (65) = happyShift action_77
action_55 (66) = happyShift action_78
action_55 (67) = happyShift action_79
action_55 (68) = happyShift action_80
action_55 (69) = happyShift action_81
action_55 (70) = happyShift action_82
action_55 (71) = happyShift action_83
action_55 (72) = happyShift action_84
action_55 (73) = happyShift action_85
action_55 (74) = happyShift action_86
action_55 (75) = happyShift action_87
action_55 (76) = happyShift action_88
action_55 (77) = happyShift action_89
action_55 _ = happyFail

action_56 (80) = happyShift action_91
action_56 _ = happyFail

action_57 (44) = happyShift action_66
action_57 (48) = happyShift action_90
action_57 (54) = happyShift action_67
action_57 (55) = happyShift action_68
action_57 (57) = happyShift action_69
action_57 (58) = happyShift action_70
action_57 (59) = happyShift action_71
action_57 (60) = happyShift action_72
action_57 (61) = happyShift action_73
action_57 (62) = happyShift action_74
action_57 (63) = happyShift action_75
action_57 (64) = happyShift action_76
action_57 (65) = happyShift action_77
action_57 (66) = happyShift action_78
action_57 (67) = happyShift action_79
action_57 (68) = happyShift action_80
action_57 (69) = happyShift action_81
action_57 (70) = happyShift action_82
action_57 (71) = happyShift action_83
action_57 (72) = happyShift action_84
action_57 (73) = happyShift action_85
action_57 (74) = happyShift action_86
action_57 (75) = happyShift action_87
action_57 (76) = happyShift action_88
action_57 (77) = happyShift action_89
action_57 _ = happyFail

action_58 (44) = happyShift action_66
action_58 (54) = happyShift action_67
action_58 (55) = happyShift action_68
action_58 (57) = happyShift action_69
action_58 (58) = happyShift action_70
action_58 (59) = happyShift action_71
action_58 (60) = happyShift action_72
action_58 (61) = happyShift action_73
action_58 (62) = happyShift action_74
action_58 (63) = happyShift action_75
action_58 (64) = happyShift action_76
action_58 (65) = happyShift action_77
action_58 (66) = happyShift action_78
action_58 (67) = happyShift action_79
action_58 (68) = happyShift action_80
action_58 (69) = happyShift action_81
action_58 (70) = happyShift action_82
action_58 (71) = happyShift action_83
action_58 (72) = happyShift action_84
action_58 (73) = happyShift action_85
action_58 (74) = happyShift action_86
action_58 (75) = happyShift action_87
action_58 (76) = happyShift action_88
action_58 (77) = happyShift action_89
action_58 _ = happyReduce_13

action_59 (40) = happyShift action_47
action_59 (42) = happyShift action_48
action_59 (56) = happyShift action_49
action_59 (64) = happyShift action_50
action_59 (82) = happyShift action_51
action_59 (83) = happyShift action_52
action_59 (84) = happyShift action_53
action_59 (85) = happyShift action_54
action_59 (86) = happyShift action_8
action_59 (17) = happyGoto action_64
action_59 (18) = happyGoto action_65
action_59 (20) = happyGoto action_42
action_59 (21) = happyGoto action_43
action_59 (22) = happyGoto action_44
action_59 (23) = happyGoto action_45
action_59 (25) = happyGoto action_46
action_59 _ = happyReduce_32

action_60 (31) = happyShift action_15
action_60 (46) = happyShift action_16
action_60 (49) = happyShift action_17
action_60 (51) = happyShift action_18
action_60 (52) = happyShift action_19
action_60 (53) = happyShift action_20
action_60 (79) = happyShift action_21
action_60 (81) = happyShift action_22
action_60 (86) = happyShift action_8
action_60 (10) = happyGoto action_63
action_60 (25) = happyGoto action_14
action_60 _ = happyReduce_8

action_61 (32) = happyShift action_62
action_61 _ = happyFail

action_62 _ = happyReduce_1

action_63 _ = happyReduce_10

action_64 (41) = happyShift action_150
action_64 _ = happyFail

action_65 (33) = happyShift action_98
action_65 _ = happyReduce_33

action_66 (40) = happyShift action_47
action_66 (42) = happyShift action_48
action_66 (56) = happyShift action_49
action_66 (64) = happyShift action_50
action_66 (82) = happyShift action_51
action_66 (83) = happyShift action_52
action_66 (84) = happyShift action_53
action_66 (85) = happyShift action_54
action_66 (86) = happyShift action_8
action_66 (18) = happyGoto action_149
action_66 (20) = happyGoto action_42
action_66 (21) = happyGoto action_43
action_66 (22) = happyGoto action_44
action_66 (23) = happyGoto action_45
action_66 (25) = happyGoto action_46
action_66 _ = happyFail

action_67 (40) = happyShift action_47
action_67 (42) = happyShift action_48
action_67 (56) = happyShift action_49
action_67 (64) = happyShift action_50
action_67 (82) = happyShift action_51
action_67 (83) = happyShift action_52
action_67 (84) = happyShift action_53
action_67 (85) = happyShift action_54
action_67 (86) = happyShift action_8
action_67 (20) = happyGoto action_148
action_67 (21) = happyGoto action_43
action_67 (22) = happyGoto action_44
action_67 (23) = happyGoto action_45
action_67 (25) = happyGoto action_46
action_67 _ = happyFail

action_68 (40) = happyShift action_47
action_68 (42) = happyShift action_48
action_68 (56) = happyShift action_49
action_68 (64) = happyShift action_50
action_68 (82) = happyShift action_51
action_68 (83) = happyShift action_52
action_68 (84) = happyShift action_53
action_68 (85) = happyShift action_54
action_68 (86) = happyShift action_8
action_68 (20) = happyGoto action_147
action_68 (21) = happyGoto action_43
action_68 (22) = happyGoto action_44
action_68 (23) = happyGoto action_45
action_68 (25) = happyGoto action_46
action_68 _ = happyFail

action_69 (40) = happyShift action_47
action_69 (42) = happyShift action_48
action_69 (56) = happyShift action_49
action_69 (64) = happyShift action_50
action_69 (82) = happyShift action_51
action_69 (83) = happyShift action_52
action_69 (84) = happyShift action_53
action_69 (85) = happyShift action_54
action_69 (86) = happyShift action_8
action_69 (20) = happyGoto action_146
action_69 (21) = happyGoto action_43
action_69 (22) = happyGoto action_44
action_69 (23) = happyGoto action_45
action_69 (25) = happyGoto action_46
action_69 _ = happyFail

action_70 (40) = happyShift action_47
action_70 (42) = happyShift action_48
action_70 (56) = happyShift action_49
action_70 (64) = happyShift action_50
action_70 (82) = happyShift action_51
action_70 (83) = happyShift action_52
action_70 (84) = happyShift action_53
action_70 (85) = happyShift action_54
action_70 (86) = happyShift action_8
action_70 (20) = happyGoto action_145
action_70 (21) = happyGoto action_43
action_70 (22) = happyGoto action_44
action_70 (23) = happyGoto action_45
action_70 (25) = happyGoto action_46
action_70 _ = happyFail

action_71 (40) = happyShift action_47
action_71 (42) = happyShift action_48
action_71 (56) = happyShift action_49
action_71 (64) = happyShift action_50
action_71 (82) = happyShift action_51
action_71 (83) = happyShift action_52
action_71 (84) = happyShift action_53
action_71 (85) = happyShift action_54
action_71 (86) = happyShift action_8
action_71 (20) = happyGoto action_144
action_71 (21) = happyGoto action_43
action_71 (22) = happyGoto action_44
action_71 (23) = happyGoto action_45
action_71 (25) = happyGoto action_46
action_71 _ = happyFail

action_72 (40) = happyShift action_47
action_72 (42) = happyShift action_48
action_72 (56) = happyShift action_49
action_72 (64) = happyShift action_50
action_72 (82) = happyShift action_51
action_72 (83) = happyShift action_52
action_72 (84) = happyShift action_53
action_72 (85) = happyShift action_54
action_72 (86) = happyShift action_8
action_72 (20) = happyGoto action_143
action_72 (21) = happyGoto action_43
action_72 (22) = happyGoto action_44
action_72 (23) = happyGoto action_45
action_72 (25) = happyGoto action_46
action_72 _ = happyFail

action_73 (40) = happyShift action_47
action_73 (42) = happyShift action_48
action_73 (56) = happyShift action_49
action_73 (64) = happyShift action_50
action_73 (82) = happyShift action_51
action_73 (83) = happyShift action_52
action_73 (84) = happyShift action_53
action_73 (85) = happyShift action_54
action_73 (86) = happyShift action_8
action_73 (20) = happyGoto action_142
action_73 (21) = happyGoto action_43
action_73 (22) = happyGoto action_44
action_73 (23) = happyGoto action_45
action_73 (25) = happyGoto action_46
action_73 _ = happyFail

action_74 (40) = happyShift action_47
action_74 (42) = happyShift action_48
action_74 (56) = happyShift action_49
action_74 (64) = happyShift action_50
action_74 (82) = happyShift action_51
action_74 (83) = happyShift action_52
action_74 (84) = happyShift action_53
action_74 (85) = happyShift action_54
action_74 (86) = happyShift action_8
action_74 (20) = happyGoto action_141
action_74 (21) = happyGoto action_43
action_74 (22) = happyGoto action_44
action_74 (23) = happyGoto action_45
action_74 (25) = happyGoto action_46
action_74 _ = happyFail

action_75 (40) = happyShift action_47
action_75 (42) = happyShift action_48
action_75 (56) = happyShift action_49
action_75 (64) = happyShift action_50
action_75 (82) = happyShift action_51
action_75 (83) = happyShift action_52
action_75 (84) = happyShift action_53
action_75 (85) = happyShift action_54
action_75 (86) = happyShift action_8
action_75 (20) = happyGoto action_140
action_75 (21) = happyGoto action_43
action_75 (22) = happyGoto action_44
action_75 (23) = happyGoto action_45
action_75 (25) = happyGoto action_46
action_75 _ = happyFail

action_76 (40) = happyShift action_47
action_76 (42) = happyShift action_48
action_76 (56) = happyShift action_49
action_76 (64) = happyShift action_50
action_76 (82) = happyShift action_51
action_76 (83) = happyShift action_52
action_76 (84) = happyShift action_53
action_76 (85) = happyShift action_54
action_76 (86) = happyShift action_8
action_76 (20) = happyGoto action_139
action_76 (21) = happyGoto action_43
action_76 (22) = happyGoto action_44
action_76 (23) = happyGoto action_45
action_76 (25) = happyGoto action_46
action_76 _ = happyFail

action_77 (40) = happyShift action_47
action_77 (42) = happyShift action_48
action_77 (56) = happyShift action_49
action_77 (64) = happyShift action_50
action_77 (82) = happyShift action_51
action_77 (83) = happyShift action_52
action_77 (84) = happyShift action_53
action_77 (85) = happyShift action_54
action_77 (86) = happyShift action_8
action_77 (20) = happyGoto action_138
action_77 (21) = happyGoto action_43
action_77 (22) = happyGoto action_44
action_77 (23) = happyGoto action_45
action_77 (25) = happyGoto action_46
action_77 _ = happyFail

action_78 (40) = happyShift action_47
action_78 (42) = happyShift action_48
action_78 (56) = happyShift action_49
action_78 (64) = happyShift action_50
action_78 (82) = happyShift action_51
action_78 (83) = happyShift action_52
action_78 (84) = happyShift action_53
action_78 (85) = happyShift action_54
action_78 (86) = happyShift action_8
action_78 (20) = happyGoto action_137
action_78 (21) = happyGoto action_43
action_78 (22) = happyGoto action_44
action_78 (23) = happyGoto action_45
action_78 (25) = happyGoto action_46
action_78 _ = happyFail

action_79 (40) = happyShift action_47
action_79 (42) = happyShift action_48
action_79 (56) = happyShift action_49
action_79 (64) = happyShift action_50
action_79 (82) = happyShift action_51
action_79 (83) = happyShift action_52
action_79 (84) = happyShift action_53
action_79 (85) = happyShift action_54
action_79 (86) = happyShift action_8
action_79 (20) = happyGoto action_136
action_79 (21) = happyGoto action_43
action_79 (22) = happyGoto action_44
action_79 (23) = happyGoto action_45
action_79 (25) = happyGoto action_46
action_79 _ = happyFail

action_80 (40) = happyShift action_47
action_80 (42) = happyShift action_48
action_80 (56) = happyShift action_49
action_80 (64) = happyShift action_50
action_80 (82) = happyShift action_51
action_80 (83) = happyShift action_52
action_80 (84) = happyShift action_53
action_80 (85) = happyShift action_54
action_80 (86) = happyShift action_8
action_80 (20) = happyGoto action_135
action_80 (21) = happyGoto action_43
action_80 (22) = happyGoto action_44
action_80 (23) = happyGoto action_45
action_80 (25) = happyGoto action_46
action_80 _ = happyFail

action_81 (40) = happyShift action_47
action_81 (42) = happyShift action_48
action_81 (56) = happyShift action_49
action_81 (64) = happyShift action_50
action_81 (82) = happyShift action_51
action_81 (83) = happyShift action_52
action_81 (84) = happyShift action_53
action_81 (85) = happyShift action_54
action_81 (86) = happyShift action_8
action_81 (20) = happyGoto action_134
action_81 (21) = happyGoto action_43
action_81 (22) = happyGoto action_44
action_81 (23) = happyGoto action_45
action_81 (25) = happyGoto action_46
action_81 _ = happyFail

action_82 _ = happyReduce_65

action_83 (40) = happyShift action_47
action_83 (42) = happyShift action_48
action_83 (56) = happyShift action_49
action_83 (64) = happyShift action_50
action_83 (82) = happyShift action_51
action_83 (83) = happyShift action_52
action_83 (84) = happyShift action_53
action_83 (85) = happyShift action_54
action_83 (86) = happyShift action_8
action_83 (20) = happyGoto action_133
action_83 (21) = happyGoto action_43
action_83 (22) = happyGoto action_44
action_83 (23) = happyGoto action_45
action_83 (25) = happyGoto action_46
action_83 _ = happyFail

action_84 (40) = happyShift action_47
action_84 (42) = happyShift action_48
action_84 (56) = happyShift action_49
action_84 (64) = happyShift action_50
action_84 (82) = happyShift action_51
action_84 (83) = happyShift action_52
action_84 (84) = happyShift action_53
action_84 (85) = happyShift action_54
action_84 (86) = happyShift action_8
action_84 (20) = happyGoto action_132
action_84 (21) = happyGoto action_43
action_84 (22) = happyGoto action_44
action_84 (23) = happyGoto action_45
action_84 (25) = happyGoto action_46
action_84 _ = happyFail

action_85 (40) = happyShift action_47
action_85 (42) = happyShift action_48
action_85 (56) = happyShift action_49
action_85 (64) = happyShift action_50
action_85 (82) = happyShift action_51
action_85 (83) = happyShift action_52
action_85 (84) = happyShift action_53
action_85 (85) = happyShift action_54
action_85 (86) = happyShift action_8
action_85 (20) = happyGoto action_131
action_85 (21) = happyGoto action_43
action_85 (22) = happyGoto action_44
action_85 (23) = happyGoto action_45
action_85 (25) = happyGoto action_46
action_85 _ = happyFail

action_86 (40) = happyShift action_47
action_86 (42) = happyShift action_48
action_86 (56) = happyShift action_49
action_86 (64) = happyShift action_50
action_86 (82) = happyShift action_51
action_86 (83) = happyShift action_52
action_86 (84) = happyShift action_53
action_86 (85) = happyShift action_54
action_86 (86) = happyShift action_8
action_86 (20) = happyGoto action_130
action_86 (21) = happyGoto action_43
action_86 (22) = happyGoto action_44
action_86 (23) = happyGoto action_45
action_86 (25) = happyGoto action_46
action_86 _ = happyFail

action_87 (40) = happyShift action_47
action_87 (42) = happyShift action_48
action_87 (56) = happyShift action_49
action_87 (64) = happyShift action_50
action_87 (82) = happyShift action_51
action_87 (83) = happyShift action_52
action_87 (84) = happyShift action_53
action_87 (85) = happyShift action_54
action_87 (86) = happyShift action_8
action_87 (20) = happyGoto action_129
action_87 (21) = happyGoto action_43
action_87 (22) = happyGoto action_44
action_87 (23) = happyGoto action_45
action_87 (25) = happyGoto action_46
action_87 _ = happyFail

action_88 (40) = happyShift action_47
action_88 (42) = happyShift action_48
action_88 (56) = happyShift action_49
action_88 (64) = happyShift action_50
action_88 (82) = happyShift action_51
action_88 (83) = happyShift action_52
action_88 (84) = happyShift action_53
action_88 (85) = happyShift action_54
action_88 (86) = happyShift action_8
action_88 (20) = happyGoto action_128
action_88 (21) = happyGoto action_43
action_88 (22) = happyGoto action_44
action_88 (23) = happyGoto action_45
action_88 (25) = happyGoto action_46
action_88 _ = happyFail

action_89 (40) = happyShift action_47
action_89 (42) = happyShift action_48
action_89 (56) = happyShift action_49
action_89 (64) = happyShift action_50
action_89 (82) = happyShift action_51
action_89 (83) = happyShift action_52
action_89 (84) = happyShift action_53
action_89 (85) = happyShift action_54
action_89 (86) = happyShift action_8
action_89 (20) = happyGoto action_127
action_89 (21) = happyGoto action_43
action_89 (22) = happyGoto action_44
action_89 (23) = happyGoto action_45
action_89 (25) = happyGoto action_46
action_89 _ = happyFail

action_90 (31) = happyShift action_15
action_90 (46) = happyShift action_16
action_90 (49) = happyShift action_17
action_90 (51) = happyShift action_18
action_90 (52) = happyShift action_19
action_90 (53) = happyShift action_20
action_90 (79) = happyShift action_21
action_90 (81) = happyShift action_22
action_90 (86) = happyShift action_8
action_90 (8) = happyGoto action_126
action_90 (9) = happyGoto action_12
action_90 (10) = happyGoto action_13
action_90 (25) = happyGoto action_14
action_90 _ = happyReduce_7

action_91 (40) = happyShift action_47
action_91 (42) = happyShift action_48
action_91 (56) = happyShift action_49
action_91 (64) = happyShift action_50
action_91 (82) = happyShift action_51
action_91 (83) = happyShift action_52
action_91 (84) = happyShift action_53
action_91 (85) = happyShift action_54
action_91 (86) = happyShift action_8
action_91 (20) = happyGoto action_125
action_91 (21) = happyGoto action_43
action_91 (22) = happyGoto action_44
action_91 (23) = happyGoto action_45
action_91 (25) = happyGoto action_46
action_91 _ = happyFail

action_92 (31) = happyShift action_15
action_92 (46) = happyShift action_16
action_92 (49) = happyShift action_17
action_92 (51) = happyShift action_18
action_92 (52) = happyShift action_19
action_92 (53) = happyShift action_20
action_92 (79) = happyShift action_21
action_92 (81) = happyShift action_22
action_92 (86) = happyShift action_8
action_92 (8) = happyGoto action_124
action_92 (9) = happyGoto action_12
action_92 (10) = happyGoto action_13
action_92 (25) = happyGoto action_14
action_92 _ = happyReduce_7

action_93 (70) = happyShift action_82
action_93 _ = happyReduce_66

action_94 (44) = happyShift action_66
action_94 (63) = happyShift action_75
action_94 (64) = happyShift action_76
action_94 (65) = happyShift action_77
action_94 (66) = happyShift action_78
action_94 (67) = happyShift action_79
action_94 (68) = happyShift action_80
action_94 (69) = happyShift action_81
action_94 (70) = happyShift action_82
action_94 (71) = happyShift action_83
action_94 (72) = happyShift action_84
action_94 (73) = happyShift action_85
action_94 (74) = happyShift action_86
action_94 (75) = happyShift action_87
action_94 (76) = happyShift action_88
action_94 (77) = happyShift action_89
action_94 _ = happyReduce_68

action_95 (33) = happyShift action_98
action_95 _ = happyReduce_36

action_96 (34) = happyShift action_122
action_96 (43) = happyShift action_123
action_96 _ = happyFail

action_97 (41) = happyShift action_121
action_97 (44) = happyShift action_66
action_97 (54) = happyShift action_67
action_97 (55) = happyShift action_68
action_97 (57) = happyShift action_69
action_97 (58) = happyShift action_70
action_97 (59) = happyShift action_71
action_97 (60) = happyShift action_72
action_97 (61) = happyShift action_73
action_97 (62) = happyShift action_74
action_97 (63) = happyShift action_75
action_97 (64) = happyShift action_76
action_97 (65) = happyShift action_77
action_97 (66) = happyShift action_78
action_97 (67) = happyShift action_79
action_97 (68) = happyShift action_80
action_97 (69) = happyShift action_81
action_97 (70) = happyShift action_82
action_97 (71) = happyShift action_83
action_97 (72) = happyShift action_84
action_97 (73) = happyShift action_85
action_97 (74) = happyShift action_86
action_97 (75) = happyShift action_87
action_97 (76) = happyShift action_88
action_97 (77) = happyShift action_89
action_97 _ = happyFail

action_98 (40) = happyShift action_47
action_98 (42) = happyShift action_48
action_98 (56) = happyShift action_49
action_98 (64) = happyShift action_50
action_98 (82) = happyShift action_51
action_98 (83) = happyShift action_52
action_98 (84) = happyShift action_53
action_98 (85) = happyShift action_54
action_98 (86) = happyShift action_8
action_98 (20) = happyGoto action_120
action_98 (21) = happyGoto action_43
action_98 (22) = happyGoto action_44
action_98 (23) = happyGoto action_45
action_98 (25) = happyGoto action_46
action_98 _ = happyFail

action_99 (78) = happyShift action_119
action_99 _ = happyReduce_29

action_100 (35) = happyShift action_29
action_100 (36) = happyShift action_30
action_100 (37) = happyShift action_31
action_100 (38) = happyShift action_32
action_100 (39) = happyShift action_33
action_100 (15) = happyGoto action_118
action_100 (26) = happyGoto action_39
action_100 _ = happyReduce_22

action_101 (31) = happyShift action_15
action_101 (46) = happyShift action_16
action_101 (49) = happyShift action_17
action_101 (51) = happyShift action_18
action_101 (52) = happyShift action_19
action_101 (53) = happyShift action_20
action_101 (79) = happyShift action_21
action_101 (81) = happyShift action_22
action_101 (86) = happyShift action_8
action_101 (8) = happyGoto action_117
action_101 (9) = happyGoto action_12
action_101 (10) = happyGoto action_13
action_101 (25) = happyGoto action_14
action_101 _ = happyReduce_7

action_102 (40) = happyShift action_47
action_102 (42) = happyShift action_48
action_102 (56) = happyShift action_49
action_102 (64) = happyShift action_50
action_102 (82) = happyShift action_51
action_102 (83) = happyShift action_52
action_102 (84) = happyShift action_53
action_102 (85) = happyShift action_54
action_102 (86) = happyShift action_8
action_102 (18) = happyGoto action_116
action_102 (20) = happyGoto action_42
action_102 (21) = happyGoto action_43
action_102 (22) = happyGoto action_44
action_102 (23) = happyGoto action_45
action_102 (25) = happyGoto action_46
action_102 _ = happyFail

action_103 (40) = happyShift action_47
action_103 (42) = happyShift action_48
action_103 (56) = happyShift action_49
action_103 (64) = happyShift action_50
action_103 (82) = happyShift action_51
action_103 (83) = happyShift action_52
action_103 (84) = happyShift action_53
action_103 (85) = happyShift action_54
action_103 (86) = happyShift action_8
action_103 (20) = happyGoto action_115
action_103 (21) = happyGoto action_43
action_103 (22) = happyGoto action_44
action_103 (23) = happyGoto action_45
action_103 (25) = happyGoto action_46
action_103 _ = happyFail

action_104 (82) = happyShift action_51
action_104 (21) = happyGoto action_114
action_104 _ = happyFail

action_105 (82) = happyShift action_51
action_105 (21) = happyGoto action_113
action_105 _ = happyFail

action_106 (82) = happyShift action_51
action_106 (21) = happyGoto action_112
action_106 _ = happyFail

action_107 _ = happyReduce_31

action_108 (35) = happyShift action_29
action_108 (36) = happyShift action_30
action_108 (37) = happyShift action_31
action_108 (38) = happyShift action_32
action_108 (39) = happyShift action_33
action_108 (16) = happyGoto action_111
action_108 (26) = happyGoto action_28
action_108 _ = happyFail

action_109 (31) = happyShift action_110
action_109 _ = happyFail

action_110 (35) = happyShift action_29
action_110 (36) = happyShift action_30
action_110 (37) = happyShift action_31
action_110 (38) = happyShift action_32
action_110 (39) = happyShift action_33
action_110 (26) = happyGoto action_163
action_110 _ = happyFail

action_111 _ = happyReduce_28

action_112 (33) = happyShift action_162
action_112 _ = happyFail

action_113 (41) = happyShift action_161
action_113 _ = happyFail

action_114 (41) = happyShift action_160
action_114 _ = happyFail

action_115 (44) = happyShift action_66
action_115 (54) = happyShift action_67
action_115 (55) = happyShift action_68
action_115 (57) = happyShift action_69
action_115 (58) = happyShift action_70
action_115 (59) = happyShift action_71
action_115 (60) = happyShift action_72
action_115 (61) = happyShift action_73
action_115 (62) = happyShift action_74
action_115 (63) = happyShift action_75
action_115 (64) = happyShift action_76
action_115 (65) = happyShift action_77
action_115 (66) = happyShift action_78
action_115 (67) = happyShift action_79
action_115 (68) = happyShift action_80
action_115 (69) = happyShift action_81
action_115 (70) = happyShift action_82
action_115 (71) = happyShift action_83
action_115 (72) = happyShift action_84
action_115 (73) = happyShift action_85
action_115 (74) = happyShift action_86
action_115 (75) = happyShift action_87
action_115 (76) = happyShift action_88
action_115 (77) = happyShift action_89
action_115 _ = happyReduce_11

action_116 (33) = happyShift action_98
action_116 (45) = happyShift action_159
action_116 _ = happyFail

action_117 (29) = happyShift action_158
action_117 _ = happyFail

action_118 _ = happyReduce_24

action_119 (40) = happyShift action_47
action_119 (42) = happyShift action_48
action_119 (56) = happyShift action_49
action_119 (64) = happyShift action_50
action_119 (82) = happyShift action_51
action_119 (83) = happyShift action_52
action_119 (84) = happyShift action_53
action_119 (85) = happyShift action_54
action_119 (86) = happyShift action_8
action_119 (20) = happyGoto action_157
action_119 (21) = happyGoto action_43
action_119 (22) = happyGoto action_44
action_119 (23) = happyGoto action_45
action_119 (25) = happyGoto action_46
action_119 _ = happyFail

action_120 (44) = happyShift action_66
action_120 (54) = happyShift action_67
action_120 (55) = happyShift action_68
action_120 (57) = happyShift action_69
action_120 (58) = happyShift action_70
action_120 (59) = happyShift action_71
action_120 (60) = happyShift action_72
action_120 (61) = happyShift action_73
action_120 (62) = happyShift action_74
action_120 (63) = happyShift action_75
action_120 (64) = happyShift action_76
action_120 (65) = happyShift action_77
action_120 (66) = happyShift action_78
action_120 (67) = happyShift action_79
action_120 (68) = happyShift action_80
action_120 (69) = happyShift action_81
action_120 (70) = happyShift action_82
action_120 (71) = happyShift action_83
action_120 (72) = happyShift action_84
action_120 (73) = happyShift action_85
action_120 (74) = happyShift action_86
action_120 (75) = happyShift action_87
action_120 (76) = happyShift action_88
action_120 (77) = happyShift action_89
action_120 _ = happyReduce_35

action_121 _ = happyReduce_69

action_122 (40) = happyShift action_47
action_122 (42) = happyShift action_48
action_122 (56) = happyShift action_49
action_122 (64) = happyShift action_50
action_122 (82) = happyShift action_51
action_122 (83) = happyShift action_52
action_122 (84) = happyShift action_53
action_122 (85) = happyShift action_54
action_122 (86) = happyShift action_8
action_122 (18) = happyGoto action_156
action_122 (20) = happyGoto action_42
action_122 (21) = happyGoto action_43
action_122 (22) = happyGoto action_44
action_122 (23) = happyGoto action_45
action_122 (25) = happyGoto action_46
action_122 _ = happyFail

action_123 _ = happyReduce_42

action_124 (29) = happyShift action_155
action_124 _ = happyFail

action_125 (44) = happyShift action_66
action_125 (50) = happyShift action_154
action_125 (54) = happyShift action_67
action_125 (55) = happyShift action_68
action_125 (57) = happyShift action_69
action_125 (58) = happyShift action_70
action_125 (59) = happyShift action_71
action_125 (60) = happyShift action_72
action_125 (61) = happyShift action_73
action_125 (62) = happyShift action_74
action_125 (63) = happyShift action_75
action_125 (64) = happyShift action_76
action_125 (65) = happyShift action_77
action_125 (66) = happyShift action_78
action_125 (67) = happyShift action_79
action_125 (68) = happyShift action_80
action_125 (69) = happyShift action_81
action_125 (70) = happyShift action_82
action_125 (71) = happyShift action_83
action_125 (72) = happyShift action_84
action_125 (73) = happyShift action_85
action_125 (74) = happyShift action_86
action_125 (75) = happyShift action_87
action_125 (76) = happyShift action_88
action_125 (77) = happyShift action_89
action_125 _ = happyFail

action_126 (29) = happyShift action_152
action_126 (47) = happyShift action_153
action_126 _ = happyFail

action_127 (44) = happyShift action_66
action_127 (70) = happyShift action_82
action_127 _ = happyReduce_56

action_128 (44) = happyShift action_66
action_128 (70) = happyShift action_82
action_128 _ = happyReduce_55

action_129 (44) = happyShift action_66
action_129 (70) = happyShift action_82
action_129 _ = happyReduce_54

action_130 (44) = happyShift action_66
action_130 (70) = happyShift action_82
action_130 _ = happyReduce_53

action_131 (44) = happyShift action_66
action_131 (70) = happyShift action_82
action_131 _ = happyReduce_52

action_132 (44) = happyShift action_66
action_132 (65) = happyShift action_77
action_132 (66) = happyShift action_78
action_132 (67) = happyShift action_79
action_132 (68) = happyShift action_80
action_132 (69) = happyShift action_81
action_132 (70) = happyShift action_82
action_132 (73) = happyShift action_85
action_132 (74) = happyShift action_86
action_132 (75) = happyShift action_87
action_132 (76) = happyShift action_88
action_132 (77) = happyShift action_89
action_132 _ = happyReduce_51

action_133 (44) = happyShift action_66
action_133 (65) = happyShift action_77
action_133 (66) = happyShift action_78
action_133 (67) = happyShift action_79
action_133 (68) = happyShift action_80
action_133 (69) = happyShift action_81
action_133 (70) = happyShift action_82
action_133 (73) = happyShift action_85
action_133 (74) = happyShift action_86
action_133 (75) = happyShift action_87
action_133 (76) = happyShift action_88
action_133 (77) = happyShift action_89
action_133 _ = happyReduce_50

action_134 (44) = happyShift action_66
action_134 (70) = happyShift action_82
action_134 _ = happyReduce_49

action_135 (44) = happyShift action_66
action_135 (70) = happyShift action_82
action_135 _ = happyReduce_48

action_136 (44) = happyShift action_66
action_136 (70) = happyShift action_82
action_136 _ = happyReduce_47

action_137 (44) = happyShift action_66
action_137 (70) = happyShift action_82
action_137 _ = happyReduce_46

action_138 (44) = happyShift action_66
action_138 (70) = happyShift action_82
action_138 _ = happyReduce_45

action_139 (44) = happyShift action_66
action_139 (65) = happyShift action_77
action_139 (66) = happyShift action_78
action_139 (67) = happyShift action_79
action_139 (68) = happyShift action_80
action_139 (69) = happyShift action_81
action_139 (70) = happyShift action_82
action_139 (73) = happyShift action_85
action_139 (74) = happyShift action_86
action_139 (75) = happyShift action_87
action_139 (76) = happyShift action_88
action_139 (77) = happyShift action_89
action_139 _ = happyReduce_44

action_140 (44) = happyShift action_66
action_140 (65) = happyShift action_77
action_140 (66) = happyShift action_78
action_140 (67) = happyShift action_79
action_140 (68) = happyShift action_80
action_140 (69) = happyShift action_81
action_140 (70) = happyShift action_82
action_140 (73) = happyShift action_85
action_140 (74) = happyShift action_86
action_140 (75) = happyShift action_87
action_140 (76) = happyShift action_88
action_140 (77) = happyShift action_89
action_140 _ = happyReduce_43

action_141 (44) = happyShift action_66
action_141 (57) = happyFail
action_141 (58) = happyFail
action_141 (59) = happyFail
action_141 (60) = happyFail
action_141 (61) = happyFail
action_141 (62) = happyFail
action_141 (63) = happyShift action_75
action_141 (64) = happyShift action_76
action_141 (65) = happyShift action_77
action_141 (66) = happyShift action_78
action_141 (67) = happyShift action_79
action_141 (68) = happyShift action_80
action_141 (69) = happyShift action_81
action_141 (70) = happyShift action_82
action_141 (71) = happyShift action_83
action_141 (72) = happyShift action_84
action_141 (73) = happyShift action_85
action_141 (74) = happyShift action_86
action_141 (75) = happyShift action_87
action_141 (76) = happyShift action_88
action_141 (77) = happyShift action_89
action_141 _ = happyReduce_63

action_142 (44) = happyShift action_66
action_142 (57) = happyFail
action_142 (58) = happyFail
action_142 (59) = happyFail
action_142 (60) = happyFail
action_142 (61) = happyFail
action_142 (62) = happyFail
action_142 (63) = happyShift action_75
action_142 (64) = happyShift action_76
action_142 (65) = happyShift action_77
action_142 (66) = happyShift action_78
action_142 (67) = happyShift action_79
action_142 (68) = happyShift action_80
action_142 (69) = happyShift action_81
action_142 (70) = happyShift action_82
action_142 (71) = happyShift action_83
action_142 (72) = happyShift action_84
action_142 (73) = happyShift action_85
action_142 (74) = happyShift action_86
action_142 (75) = happyShift action_87
action_142 (76) = happyShift action_88
action_142 (77) = happyShift action_89
action_142 _ = happyReduce_64

action_143 (44) = happyShift action_66
action_143 (57) = happyFail
action_143 (58) = happyFail
action_143 (59) = happyFail
action_143 (60) = happyFail
action_143 (61) = happyFail
action_143 (62) = happyFail
action_143 (63) = happyShift action_75
action_143 (64) = happyShift action_76
action_143 (65) = happyShift action_77
action_143 (66) = happyShift action_78
action_143 (67) = happyShift action_79
action_143 (68) = happyShift action_80
action_143 (69) = happyShift action_81
action_143 (70) = happyShift action_82
action_143 (71) = happyShift action_83
action_143 (72) = happyShift action_84
action_143 (73) = happyShift action_85
action_143 (74) = happyShift action_86
action_143 (75) = happyShift action_87
action_143 (76) = happyShift action_88
action_143 (77) = happyShift action_89
action_143 _ = happyReduce_61

action_144 (44) = happyShift action_66
action_144 (57) = happyFail
action_144 (58) = happyFail
action_144 (59) = happyFail
action_144 (60) = happyFail
action_144 (61) = happyFail
action_144 (62) = happyFail
action_144 (63) = happyShift action_75
action_144 (64) = happyShift action_76
action_144 (65) = happyShift action_77
action_144 (66) = happyShift action_78
action_144 (67) = happyShift action_79
action_144 (68) = happyShift action_80
action_144 (69) = happyShift action_81
action_144 (70) = happyShift action_82
action_144 (71) = happyShift action_83
action_144 (72) = happyShift action_84
action_144 (73) = happyShift action_85
action_144 (74) = happyShift action_86
action_144 (75) = happyShift action_87
action_144 (76) = happyShift action_88
action_144 (77) = happyShift action_89
action_144 _ = happyReduce_62

action_145 (44) = happyShift action_66
action_145 (57) = happyFail
action_145 (58) = happyFail
action_145 (59) = happyFail
action_145 (60) = happyFail
action_145 (61) = happyFail
action_145 (62) = happyFail
action_145 (63) = happyShift action_75
action_145 (64) = happyShift action_76
action_145 (65) = happyShift action_77
action_145 (66) = happyShift action_78
action_145 (67) = happyShift action_79
action_145 (68) = happyShift action_80
action_145 (69) = happyShift action_81
action_145 (70) = happyShift action_82
action_145 (71) = happyShift action_83
action_145 (72) = happyShift action_84
action_145 (73) = happyShift action_85
action_145 (74) = happyShift action_86
action_145 (75) = happyShift action_87
action_145 (76) = happyShift action_88
action_145 (77) = happyShift action_89
action_145 _ = happyReduce_60

action_146 (44) = happyShift action_66
action_146 (57) = happyFail
action_146 (58) = happyFail
action_146 (59) = happyFail
action_146 (60) = happyFail
action_146 (61) = happyFail
action_146 (62) = happyFail
action_146 (63) = happyShift action_75
action_146 (64) = happyShift action_76
action_146 (65) = happyShift action_77
action_146 (66) = happyShift action_78
action_146 (67) = happyShift action_79
action_146 (68) = happyShift action_80
action_146 (69) = happyShift action_81
action_146 (70) = happyShift action_82
action_146 (71) = happyShift action_83
action_146 (72) = happyShift action_84
action_146 (73) = happyShift action_85
action_146 (74) = happyShift action_86
action_146 (75) = happyShift action_87
action_146 (76) = happyShift action_88
action_146 (77) = happyShift action_89
action_146 _ = happyReduce_59

action_147 (44) = happyShift action_66
action_147 (54) = happyShift action_67
action_147 (57) = happyShift action_69
action_147 (58) = happyShift action_70
action_147 (59) = happyShift action_71
action_147 (60) = happyShift action_72
action_147 (61) = happyShift action_73
action_147 (62) = happyShift action_74
action_147 (63) = happyShift action_75
action_147 (64) = happyShift action_76
action_147 (65) = happyShift action_77
action_147 (66) = happyShift action_78
action_147 (67) = happyShift action_79
action_147 (68) = happyShift action_80
action_147 (69) = happyShift action_81
action_147 (70) = happyShift action_82
action_147 (71) = happyShift action_83
action_147 (72) = happyShift action_84
action_147 (73) = happyShift action_85
action_147 (74) = happyShift action_86
action_147 (75) = happyShift action_87
action_147 (76) = happyShift action_88
action_147 (77) = happyShift action_89
action_147 _ = happyReduce_57

action_148 (44) = happyShift action_66
action_148 (57) = happyShift action_69
action_148 (58) = happyShift action_70
action_148 (59) = happyShift action_71
action_148 (60) = happyShift action_72
action_148 (61) = happyShift action_73
action_148 (62) = happyShift action_74
action_148 (63) = happyShift action_75
action_148 (64) = happyShift action_76
action_148 (65) = happyShift action_77
action_148 (66) = happyShift action_78
action_148 (67) = happyShift action_79
action_148 (68) = happyShift action_80
action_148 (69) = happyShift action_81
action_148 (70) = happyShift action_82
action_148 (71) = happyShift action_83
action_148 (72) = happyShift action_84
action_148 (73) = happyShift action_85
action_148 (74) = happyShift action_86
action_148 (75) = happyShift action_87
action_148 (76) = happyShift action_88
action_148 (77) = happyShift action_89
action_148 _ = happyReduce_58

action_149 (33) = happyShift action_98
action_149 (45) = happyShift action_151
action_149 _ = happyFail

action_150 _ = happyReduce_12

action_151 _ = happyReduce_67

action_152 _ = happyReduce_15

action_153 (31) = happyShift action_15
action_153 (46) = happyShift action_16
action_153 (49) = happyShift action_17
action_153 (51) = happyShift action_18
action_153 (52) = happyShift action_19
action_153 (53) = happyShift action_20
action_153 (79) = happyShift action_21
action_153 (81) = happyShift action_22
action_153 (86) = happyShift action_8
action_153 (8) = happyGoto action_167
action_153 (9) = happyGoto action_12
action_153 (10) = happyGoto action_13
action_153 (25) = happyGoto action_14
action_153 _ = happyReduce_7

action_154 (31) = happyShift action_15
action_154 (46) = happyShift action_16
action_154 (49) = happyShift action_17
action_154 (51) = happyShift action_18
action_154 (52) = happyShift action_19
action_154 (53) = happyShift action_20
action_154 (79) = happyShift action_21
action_154 (81) = happyShift action_22
action_154 (86) = happyShift action_8
action_154 (8) = happyGoto action_166
action_154 (9) = happyGoto action_12
action_154 (10) = happyGoto action_13
action_154 (25) = happyGoto action_14
action_154 _ = happyReduce_7

action_155 _ = happyReduce_17

action_156 (33) = happyShift action_98
action_156 _ = happyReduce_37

action_157 (44) = happyShift action_66
action_157 (54) = happyShift action_67
action_157 (55) = happyShift action_68
action_157 (57) = happyShift action_69
action_157 (58) = happyShift action_70
action_157 (59) = happyShift action_71
action_157 (60) = happyShift action_72
action_157 (61) = happyShift action_73
action_157 (62) = happyShift action_74
action_157 (63) = happyShift action_75
action_157 (64) = happyShift action_76
action_157 (65) = happyShift action_77
action_157 (66) = happyShift action_78
action_157 (67) = happyShift action_79
action_157 (68) = happyShift action_80
action_157 (69) = happyShift action_81
action_157 (70) = happyShift action_82
action_157 (71) = happyShift action_83
action_157 (72) = happyShift action_84
action_157 (73) = happyShift action_85
action_157 (74) = happyShift action_86
action_157 (75) = happyShift action_87
action_157 (76) = happyShift action_88
action_157 (77) = happyShift action_89
action_157 _ = happyReduce_30

action_158 _ = happyReduce_20

action_159 _ = happyReduce_75

action_160 _ = happyReduce_81

action_161 _ = happyReduce_80

action_162 (82) = happyShift action_51
action_162 (21) = happyGoto action_165
action_162 _ = happyFail

action_163 (28) = happyShift action_164
action_163 _ = happyFail

action_164 (31) = happyShift action_15
action_164 (46) = happyShift action_16
action_164 (49) = happyShift action_17
action_164 (51) = happyShift action_18
action_164 (52) = happyShift action_19
action_164 (53) = happyShift action_20
action_164 (79) = happyShift action_21
action_164 (81) = happyShift action_22
action_164 (86) = happyShift action_8
action_164 (9) = happyGoto action_171
action_164 (10) = happyGoto action_13
action_164 (25) = happyGoto action_14
action_164 _ = happyFail

action_165 (41) = happyShift action_170
action_165 _ = happyFail

action_166 (29) = happyShift action_169
action_166 _ = happyFail

action_167 (29) = happyShift action_168
action_167 _ = happyFail

action_168 _ = happyReduce_14

action_169 _ = happyReduce_16

action_170 _ = happyReduce_79

action_171 (32) = happyShift action_172
action_171 _ = happyFail

action_172 (29) = happyShift action_173
action_172 (31) = happyShift action_15
action_172 (46) = happyShift action_16
action_172 (49) = happyShift action_17
action_172 (51) = happyShift action_18
action_172 (52) = happyShift action_19
action_172 (53) = happyShift action_20
action_172 (79) = happyShift action_21
action_172 (81) = happyShift action_22
action_172 (86) = happyShift action_8
action_172 (10) = happyGoto action_63
action_172 (25) = happyGoto action_14
action_172 _ = happyFail

action_173 _ = happyReduce_6

happyReduce_1 = happyReduce 5 4 happyReduction_1
happyReduction_1 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn8  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn5  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn4
		 (Program happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_2 = happySpecReduce_0  5 happyReduction_2
happyReduction_2  =  HappyAbsSyn5
		 (empty
	)

happyReduce_3 = happySpecReduce_2  5 happyReduction_3
happyReduction_3 _
	(HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn5
		 (happy_var_1
	)
happyReduction_3 _ _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_1  6 happyReduction_4
happyReduction_4 (HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn5
		 (singleton happy_var_1
	)
happyReduction_4 _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_3  6 happyReduction_5
happyReduction_5 (HappyAbsSyn7  happy_var_3)
	_
	(HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn5
		 (happy_var_1 |> happy_var_3
	)
happyReduction_5 _ _ _  = notHappyAtAll 

happyReduce_6 = happyReduce 11 7 happyReduction_6
happyReduction_6 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn8  happy_var_9) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn26  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn11  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn25  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 (Function happy_var_2 happy_var_4 happy_var_7 happy_var_9 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_7 = happySpecReduce_0  8 happyReduction_7
happyReduction_7  =  HappyAbsSyn8
		 (empty
	)

happyReduce_8 = happySpecReduce_2  8 happyReduction_8
happyReduction_8 _
	(HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_1
	)
happyReduction_8 _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_1  9 happyReduction_9
happyReduction_9 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn8
		 (expandStatement happy_var_1
	)
happyReduction_9 _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_3  9 happyReduction_10
happyReduction_10 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_1 >< expandStatement happy_var_3
	)
happyReduction_10 _ _ _  = notHappyAtAll 

happyReduce_11 = happyReduce 4 10 happyReduction_11
happyReduction_11 ((HappyAbsSyn20  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn24  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (StAssign happy_var_2 happy_var_4 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_12 = happyReduce 4 10 happyReduction_12
happyReduction_12 (_ `HappyStk`
	(HappyAbsSyn17  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn25  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (StFunctionCall happy_var_1 happy_var_3 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_13 = happySpecReduce_2  10 happyReduction_13
happyReduction_13 (HappyAbsSyn20  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn10
		 (StReturn happy_var_2 <$ happy_var_1
	)
happyReduction_13 _ _  = notHappyAtAll 

happyReduce_14 = happyReduce 7 10 happyReduction_14
happyReduction_14 (_ `HappyStk`
	(HappyAbsSyn8  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn8  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn20  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (StIf happy_var_2 happy_var_4 happy_var_6 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_15 = happyReduce 5 10 happyReduction_15
happyReduction_15 (_ `HappyStk`
	(HappyAbsSyn8  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn20  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (StIf happy_var_2 happy_var_4 empty <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_16 = happyReduce 7 10 happyReduction_16
happyReduction_16 (_ `HappyStk`
	(HappyAbsSyn8  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn20  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn25  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (StFor happy_var_2 happy_var_4 happy_var_6 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_17 = happyReduce 5 10 happyReduction_17
happyReduction_17 (_ `HappyStk`
	(HappyAbsSyn8  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn20  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (StWhile happy_var_2 happy_var_4 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_18 = happySpecReduce_2  10 happyReduction_18
happyReduction_18 (HappyAbsSyn25  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn10
		 (StRead happy_var_2 <$ happy_var_1
	)
happyReduction_18 _ _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_2  10 happyReduction_19
happyReduction_19 (HappyAbsSyn17  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn10
		 (StPrintList happy_var_2 <$ happy_var_1
	)
happyReduction_19 _ _  = notHappyAtAll 

happyReduce_20 = happyReduce 5 10 happyReduction_20
happyReduction_20 (_ `HappyStk`
	(HappyAbsSyn8  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn11  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (StBlock happy_var_2 happy_var_4 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_21 = happySpecReduce_0  11 happyReduction_21
happyReduction_21  =  HappyAbsSyn11
		 (empty
	)

happyReduce_22 = happySpecReduce_2  11 happyReduction_22
happyReduction_22 _
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 (happy_var_1
	)
happyReduction_22 _ _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_1  12 happyReduction_23
happyReduction_23 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn11
		 (singleton happy_var_1
	)
happyReduction_23 _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_3  12 happyReduction_24
happyReduction_24 (HappyAbsSyn15  happy_var_3)
	_
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 (happy_var_1 |> happy_var_3
	)
happyReduction_24 _ _ _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_0  13 happyReduction_25
happyReduction_25  =  HappyAbsSyn11
		 (empty
	)

happyReduce_26 = happySpecReduce_1  13 happyReduction_26
happyReduction_26 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 (happy_var_1
	)
happyReduction_26 _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_1  14 happyReduction_27
happyReduction_27 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn11
		 (singleton happy_var_1
	)
happyReduction_27 _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_3  14 happyReduction_28
happyReduction_28 (HappyAbsSyn15  happy_var_3)
	_
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 (happy_var_1 |> happy_var_3
	)
happyReduction_28 _ _ _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_2  15 happyReduction_29
happyReduction_29 (HappyAbsSyn25  happy_var_2)
	(HappyAbsSyn26  happy_var_1)
	 =  HappyAbsSyn15
		 (Dcl happy_var_1 happy_var_2 <$ happy_var_1
	)
happyReduction_29 _ _  = notHappyAtAll 

happyReduce_30 = happyReduce 4 15 happyReduction_30
happyReduction_30 ((HappyAbsSyn20  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn25  happy_var_2) `HappyStk`
	(HappyAbsSyn26  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn15
		 (DclInit happy_var_1 happy_var_2 happy_var_4 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_31 = happySpecReduce_2  16 happyReduction_31
happyReduction_31 (HappyAbsSyn25  happy_var_2)
	(HappyAbsSyn26  happy_var_1)
	 =  HappyAbsSyn15
		 (DclParam happy_var_1 happy_var_2 <$ happy_var_1
	)
happyReduction_31 _ _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_0  17 happyReduction_32
happyReduction_32  =  HappyAbsSyn17
		 (empty
	)

happyReduce_33 = happySpecReduce_1  17 happyReduction_33
happyReduction_33 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_33 _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_1  18 happyReduction_34
happyReduction_34 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn17
		 (singleton happy_var_1
	)
happyReduction_34 _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_3  18 happyReduction_35
happyReduction_35 (HappyAbsSyn20  happy_var_3)
	_
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1 |> happy_var_3
	)
happyReduction_35 _ _ _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_1  19 happyReduction_36
happyReduction_36 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn19
		 ([happy_var_1]
	)
happyReduction_36 _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_3  19 happyReduction_37
happyReduction_37 (HappyAbsSyn17  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_37 _ _ _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_1  20 happyReduction_38
happyReduction_38 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn20
		 (LitNumber happy_var_1 <$ happy_var_1
	)
happyReduction_38 _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_1  20 happyReduction_39
happyReduction_39 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn20
		 (LitBool happy_var_1 <$ happy_var_1
	)
happyReduction_39 _  = notHappyAtAll 

happyReduce_40 = happySpecReduce_1  20 happyReduction_40
happyReduction_40 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn20
		 (LitString happy_var_1 <$ happy_var_1
	)
happyReduction_40 _  = notHappyAtAll 

happyReduce_41 = happySpecReduce_1  20 happyReduction_41
happyReduction_41 (HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn20
		 (VariableId happy_var_1 <$ happy_var_1
	)
happyReduction_41 _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_3  20 happyReduction_42
happyReduction_42 _
	(HappyAbsSyn19  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn20
		 (LitMatrix happy_var_2 <$ happy_var_1
	)
happyReduction_42 _ _ _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_3  20 happyReduction_43
happyReduction_43 (HappyAbsSyn20  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (ExpBinary (OpSum <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_43 _ _ _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_3  20 happyReduction_44
happyReduction_44 (HappyAbsSyn20  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (ExpBinary (OpDiff <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_44 _ _ _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_3  20 happyReduction_45
happyReduction_45 (HappyAbsSyn20  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (ExpBinary (OpMul <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_45 _ _ _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_3  20 happyReduction_46
happyReduction_46 (HappyAbsSyn20  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (ExpBinary (OpDivEnt <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_46 _ _ _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_3  20 happyReduction_47
happyReduction_47 (HappyAbsSyn20  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (ExpBinary (OpModEnt <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_47 _ _ _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_3  20 happyReduction_48
happyReduction_48 (HappyAbsSyn20  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (ExpBinary (OpDiv <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_48 _ _ _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_3  20 happyReduction_49
happyReduction_49 (HappyAbsSyn20  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (ExpBinary (OpMod <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_49 _ _ _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_3  20 happyReduction_50
happyReduction_50 (HappyAbsSyn20  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (ExpBinary (OpCruzSum <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_50 _ _ _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_3  20 happyReduction_51
happyReduction_51 (HappyAbsSyn20  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (ExpBinary (OpCruzDiff <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_51 _ _ _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_3  20 happyReduction_52
happyReduction_52 (HappyAbsSyn20  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (ExpBinary (OpCruzMul <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_52 _ _ _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_3  20 happyReduction_53
happyReduction_53 (HappyAbsSyn20  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (ExpBinary (OpCruzDivEnt <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_53 _ _ _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_3  20 happyReduction_54
happyReduction_54 (HappyAbsSyn20  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (ExpBinary (OpCruzModEnt <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_54 _ _ _  = notHappyAtAll 

happyReduce_55 = happySpecReduce_3  20 happyReduction_55
happyReduction_55 (HappyAbsSyn20  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (ExpBinary (OpCruzDiv <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_55 _ _ _  = notHappyAtAll 

happyReduce_56 = happySpecReduce_3  20 happyReduction_56
happyReduction_56 (HappyAbsSyn20  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (ExpBinary (OpCruzMod <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_56 _ _ _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_3  20 happyReduction_57
happyReduction_57 (HappyAbsSyn20  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (ExpBinary (OpOr <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_57 _ _ _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_3  20 happyReduction_58
happyReduction_58 (HappyAbsSyn20  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (ExpBinary (OpAnd <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_58 _ _ _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_3  20 happyReduction_59
happyReduction_59 (HappyAbsSyn20  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (ExpBinary (OpEqual <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_59 _ _ _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_3  20 happyReduction_60
happyReduction_60 (HappyAbsSyn20  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (ExpBinary (OpUnequal <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_60 _ _ _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_3  20 happyReduction_61
happyReduction_61 (HappyAbsSyn20  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (ExpBinary (OpLess <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_61 _ _ _  = notHappyAtAll 

happyReduce_62 = happySpecReduce_3  20 happyReduction_62
happyReduction_62 (HappyAbsSyn20  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (ExpBinary (OpLessEq <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_62 _ _ _  = notHappyAtAll 

happyReduce_63 = happySpecReduce_3  20 happyReduction_63
happyReduction_63 (HappyAbsSyn20  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (ExpBinary (OpGreat <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_63 _ _ _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_3  20 happyReduction_64
happyReduction_64 (HappyAbsSyn20  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (ExpBinary (OpGreatEq <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_64 _ _ _  = notHappyAtAll 

happyReduce_65 = happySpecReduce_2  20 happyReduction_65
happyReduction_65 (HappyTerminal happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (ExpUnary (OpTranspose <$ happy_var_2) happy_var_1 <$ happy_var_1
	)
happyReduction_65 _ _  = notHappyAtAll 

happyReduce_66 = happySpecReduce_2  20 happyReduction_66
happyReduction_66 (HappyAbsSyn20  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn20
		 (ExpUnary (OpNegative <$ happy_var_1) happy_var_2 <$ happy_var_1
	)
happyReduction_66 _ _  = notHappyAtAll 

happyReduce_67 = happyReduce 4 20 happyReduction_67
happyReduction_67 (_ `HappyStk`
	(HappyAbsSyn17  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn20  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (Proy happy_var_1 happy_var_3 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_68 = happySpecReduce_2  20 happyReduction_68
happyReduction_68 (HappyAbsSyn20  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn20
		 (ExpUnary (OpNot <$ happy_var_1) happy_var_2 <$ happy_var_1
	)
happyReduction_68 _ _  = notHappyAtAll 

happyReduce_69 = happySpecReduce_3  20 happyReduction_69
happyReduction_69 _
	(HappyAbsSyn20  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn20
		 (lexInfo happy_var_2 <$ happy_var_1
	)
happyReduction_69 _ _ _  = notHappyAtAll 

happyReduce_70 = happySpecReduce_1  21 happyReduction_70
happyReduction_70 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn21
		 (unTkNumber `fmap` happy_var_1
	)
happyReduction_70 _  = notHappyAtAll 

happyReduce_71 = happySpecReduce_1  22 happyReduction_71
happyReduction_71 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn22
		 (unTkBoolean `fmap` happy_var_1
	)
happyReduction_71 _  = notHappyAtAll 

happyReduce_72 = happySpecReduce_1  22 happyReduction_72
happyReduction_72 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn22
		 (unTkBoolean `fmap` happy_var_1
	)
happyReduction_72 _  = notHappyAtAll 

happyReduce_73 = happySpecReduce_1  23 happyReduction_73
happyReduction_73 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn23
		 (unTkString `fmap` happy_var_1
	)
happyReduction_73 _  = notHappyAtAll 

happyReduce_74 = happySpecReduce_1  24 happyReduction_74
happyReduction_74 (HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn24
		 (VariableAccess happy_var_1 <$ happy_var_1
	)
happyReduction_74 _  = notHappyAtAll 

happyReduce_75 = happyReduce 4 24 happyReduction_75
happyReduction_75 (_ `HappyStk`
	(HappyAbsSyn17  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn25  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn24
		 (MatrixAccess happy_var_1 happy_var_3 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_76 = happySpecReduce_1  25 happyReduction_76
happyReduction_76 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn25
		 (unTkId `fmap` happy_var_1
	)
happyReduction_76 _  = notHappyAtAll 

happyReduce_77 = happySpecReduce_1  26 happyReduction_77
happyReduction_77 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn26
		 (Bool <$ happy_var_1
	)
happyReduction_77 _  = notHappyAtAll 

happyReduce_78 = happySpecReduce_1  26 happyReduction_78
happyReduction_78 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn26
		 (Double <$ happy_var_1
	)
happyReduction_78 _  = notHappyAtAll 

happyReduce_79 = happyReduce 6 26 happyReduction_79
happyReduction_79 (_ `HappyStk`
	(HappyAbsSyn21  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn26
		 (Matrix happy_var_3 happy_var_5 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_80 = happyReduce 4 26 happyReduction_80
happyReduction_80 (_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn26
		 (Row happy_var_3 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_81 = happyReduce 4 26 happyReduction_81
happyReduction_81 (_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn26
		 (Col happy_var_3 <$ happy_var_1
	) `HappyStk` happyRest

happyNewToken action sts stk
	= lexWrap(\tk -> 
	let cont i = action i i tk (HappyState action) sts stk in
	case tk of {
	Lex TkEOF _ -> action 87 87 tk (HappyState action) sts stk;
	Lex TkProgram      _ -> cont 27;
	Lex TkBegin        _ -> cont 28;
	Lex TkEnd          _ -> cont 29;
	Lex TkFunction     _ -> cont 30;
	Lex TkReturn       _ -> cont 31;
	Lex TkSemicolon    _ -> cont 32;
	Lex TkComma        _ -> cont 33;
	Lex TkDoublePoint  _ -> cont 34;
	Lex TkBooleanType  _ -> cont 35;
	Lex TkNumberType   _ -> cont 36;
	Lex TkMatrixType   _ -> cont 37;
	Lex TkRowType      _ -> cont 38;
	Lex TkColType      _ -> cont 39;
	Lex TkLParen       _ -> cont 40;
	Lex TkRParen       _ -> cont 41;
	Lex TkLLlaves      _ -> cont 42;
	Lex TkRLlaves      _ -> cont 43;
	Lex TkLCorche      _ -> cont 44;
	Lex TkRCorche      _ -> cont 45;
	Lex TkIf           _ -> cont 46;
	Lex TkElse         _ -> cont 47;
	Lex TkThen         _ -> cont 48;
	Lex TkFor          _ -> cont 49;
	Lex TkDo           _ -> cont 50;
	Lex TkWhile        _ -> cont 51;
	Lex TkPrint        _ -> cont 52;
	Lex TkRead         _ -> cont 53;
	Lex TkAnd          _ -> cont 54;
	Lex TkOr           _ -> cont 55;
	Lex TkNot          _ -> cont 56;
	Lex TkEqual        _ -> cont 57;
	Lex TkUnequal      _ -> cont 58;
	Lex TkLessEq       _ -> cont 59;
	Lex TkLess         _ -> cont 60;
	Lex TkGreatEq      _ -> cont 61;
	Lex TkGreat        _ -> cont 62;
	Lex TkSum          _ -> cont 63;
	Lex TkDiff         _ -> cont 64;
	Lex TkMul          _ -> cont 65;
	Lex TkDivEnt       _ -> cont 66;
	Lex TkModEnt       _ -> cont 67;
	Lex TkDiv          _ -> cont 68;
	Lex TkMod          _ -> cont 69;
	Lex TkTrans        _ -> cont 70;
	Lex TkCruzSum      _ -> cont 71;
	Lex TkCruzDiff     _ -> cont 72;
	Lex TkCruzMul      _ -> cont 73;
	Lex TkCruzDivEnt   _ -> cont 74;
	Lex TkCruzModEnt   _ -> cont 75;
	Lex TkCruzDiv      _ -> cont 76;
	Lex TkCruzMod      _ -> cont 77;
	Lex TkAssign       _ -> cont 78;
	Lex TkUse          _ -> cont 79;
	Lex TkIn           _ -> cont 80;
	Lex TkSet          _ -> cont 81;
	Lex (TkNumber _)   _ -> cont 82;
	Lex (TkBoolean _)  _ -> cont 83;
	Lex (TkBoolean _)  _ -> cont 84;
	Lex (TkString _)   _ -> cont 85;
	Lex (TkId     _)   _ -> cont 86;
	_ -> happyError' tk
	})

happyError_ 87 tk = happyError' tk
happyError_ _ tk = happyError' tk

happyThen :: () => Alex a -> (a -> Alex b) -> Alex b
happyThen = (>>=)
happyReturn :: () => a -> Alex a
happyReturn = (return)
happyThen1 = happyThen
happyReturn1 :: () => a -> Alex a
happyReturn1 = happyReturn
happyError' :: () => (Lexeme Token) -> Alex a
happyError' tk = parseError tk

parse = happySomeParser where
  happySomeParser = happyThen (happyParse action_0) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


--------------------------------------------------------
-- Codigo Haskell
--------------------------------------------------------

expandStatement :: Lexeme Statement -> StatementSeq
expandStatement stL = case lexInfo stL of
    StNoop -> empty
    StPrintList exps -> fmap (\exp -> StPrint exp <$ stL) exps
    _ -> singleton stL

---------------------------------------------------------------------
-- Parser

lexWrap :: (Lexeme Token -> Alex a) -> Alex a
lexWrap cont = do
    t <- alexMonadScan
    case t of 
        Lex (TkError c) pos    -> do
            tellLError pos (UnexpectedChar c)
            lexWrap cont
        Lex (TkErrorS str) pos -> do
            tellLError pos (StringError str)
            lexWrap cont
        --Cualquier otro Token es parte del lenguaje
        Lex _ pos -> cont t

parseError :: Lexeme Token -> Alex a
parseError (Lex t p) = fail $ "Parse Error: token " ++ 
                            show t ++ " " ++ show p ++ "\n" 

parseProgram :: String ->  (Program, Seq Error)
parseProgram input = runAlex' input parse
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "<command-line>" #-}





# 1 "/usr/include/stdc-predef.h" 1 3 4

# 17 "/usr/include/stdc-predef.h" 3 4














# 1 "/usr/include/x86_64-linux-gnu/bits/predefs.h" 1 3 4

# 18 "/usr/include/x86_64-linux-gnu/bits/predefs.h" 3 4












# 31 "/usr/include/stdc-predef.h" 2 3 4








# 5 "<command-line>" 2
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 

{-# LINE 30 "templates/GenericTemplate.hs" #-}








{-# LINE 51 "templates/GenericTemplate.hs" #-}

{-# LINE 61 "templates/GenericTemplate.hs" #-}

{-# LINE 70 "templates/GenericTemplate.hs" #-}

infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is (1), it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
	happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
	 (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action

{-# LINE 148 "templates/GenericTemplate.hs" #-}

-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Int ->                    -- token number
         Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let (i) = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k - ((1) :: Int)) sts of
	 sts1@(((st1@(HappyState (action))):(_))) ->
        	let r = fn stk in  -- it doesn't hurt to always seq here...
       		happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
        happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))
       where (sts1@(((st1@(HappyState (action))):(_)))) = happyDrop k ((st):(sts))
             drop_stk = happyDropStk k stk

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
       happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))
       where (sts1@(((st1@(HappyState (action))):(_)))) = happyDrop k ((st):(sts))
             drop_stk = happyDropStk k stk





             new_state = action


happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n - ((1) :: Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n - ((1)::Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction

{-# LINE 246 "templates/GenericTemplate.hs" #-}
happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery ((1) is the error token)

-- parse error if we are in recovery and we fail again
happyFail (1) tk old_st _ stk@(x `HappyStk` _) =
     let (i) = (case x of { HappyErrorToken (i) -> i }) in
--	trace "failing" $ 
        happyError_ i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  (1) tk old_st (((HappyState (action))):(sts)) 
						(saved_tok `HappyStk` _ `HappyStk` stk) =
--	trace ("discarding state, depth " ++ show (length stk))  $
	action (1) (1) tk (HappyState (action)) sts ((saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail  i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
	action (1) (1) tk (HappyState (action)) sts ( (HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--	happySeq = happyDoSeq
-- otherwise it emits
-- 	happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.

{-# LINE 312 "templates/GenericTemplate.hs" #-}
{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
