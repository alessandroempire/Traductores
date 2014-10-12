{-# OPTIONS_GHC -w #-}
module Parser
    ( parseProgram
    ) 
    where


import          Lexer
import          Program

import          Control.Monad        (unless)
import          Data.Functor         ((<$>),(<$))
import          Data.Maybe           (fromJust, isJust)
import          Data.Foldable        (concatMap)
import          Data.Sequence hiding (length)
import          Prelude       hiding (concatMap, foldr, zip)

-- parser produced by Happy Version 1.19.0

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
	| HappyAbsSyn16 (Seq (Lexeme Expression))
	| HappyAbsSyn18 ([Seq (Lexeme Expression)])
	| HappyAbsSyn19 (Lexeme Expression)
	| HappyAbsSyn20 (Lexeme Double)
	| HappyAbsSyn21 (Lexeme Bool)
	| HappyAbsSyn22 (Lexeme String)
	| HappyAbsSyn23 (Lexeme Access)
	| HappyAbsSyn24 (Lexeme Identifier)
	| HappyAbsSyn25 (Lexeme TypeId)

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
 action_171 :: () => Int -> ({-HappyReduction (Alex) = -}
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
 happyReduce_80 :: () => ({-HappyReduction (Alex) = -}
	   Int 
	-> (Lexeme Token)
	-> HappyState (Lexeme Token) (HappyStk HappyAbsSyn -> (Alex) HappyAbsSyn)
	-> [HappyState (Lexeme Token) (HappyStk HappyAbsSyn -> (Alex) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> (Alex) HappyAbsSyn)

action_0 (29) = happyShift action_5
action_0 (4) = happyGoto action_6
action_0 (5) = happyGoto action_2
action_0 (6) = happyGoto action_3
action_0 (7) = happyGoto action_4
action_0 _ = happyReduce_2

action_1 (29) = happyShift action_5
action_1 (5) = happyGoto action_2
action_1 (6) = happyGoto action_3
action_1 (7) = happyGoto action_4
action_1 _ = happyFail

action_2 (26) = happyShift action_10
action_2 _ = happyFail

action_3 (31) = happyShift action_9
action_3 _ = happyFail

action_4 _ = happyReduce_4

action_5 (85) = happyShift action_8
action_5 (24) = happyGoto action_7
action_5 _ = happyFail

action_6 (86) = happyAccept
action_6 _ = happyFail

action_7 (39) = happyShift action_24
action_7 _ = happyFail

action_8 _ = happyReduce_75

action_9 (29) = happyShift action_5
action_9 (7) = happyGoto action_23
action_9 _ = happyReduce_3

action_10 (30) = happyShift action_15
action_10 (45) = happyShift action_16
action_10 (48) = happyShift action_17
action_10 (50) = happyShift action_18
action_10 (51) = happyShift action_19
action_10 (52) = happyShift action_20
action_10 (78) = happyShift action_21
action_10 (80) = happyShift action_22
action_10 (85) = happyShift action_8
action_10 (8) = happyGoto action_11
action_10 (9) = happyGoto action_12
action_10 (10) = happyGoto action_13
action_10 (24) = happyGoto action_14
action_10 _ = happyReduce_7

action_11 (28) = happyShift action_60
action_11 _ = happyFail

action_12 (31) = happyShift action_59
action_12 _ = happyFail

action_13 _ = happyReduce_9

action_14 (39) = happyShift action_58
action_14 _ = happyFail

action_15 (39) = happyShift action_46
action_15 (41) = happyShift action_47
action_15 (55) = happyShift action_48
action_15 (63) = happyShift action_49
action_15 (81) = happyShift action_50
action_15 (82) = happyShift action_51
action_15 (83) = happyShift action_52
action_15 (84) = happyShift action_53
action_15 (85) = happyShift action_8
action_15 (19) = happyGoto action_57
action_15 (20) = happyGoto action_42
action_15 (21) = happyGoto action_43
action_15 (22) = happyGoto action_44
action_15 (24) = happyGoto action_45
action_15 _ = happyFail

action_16 (39) = happyShift action_46
action_16 (41) = happyShift action_47
action_16 (55) = happyShift action_48
action_16 (63) = happyShift action_49
action_16 (81) = happyShift action_50
action_16 (82) = happyShift action_51
action_16 (83) = happyShift action_52
action_16 (84) = happyShift action_53
action_16 (85) = happyShift action_8
action_16 (19) = happyGoto action_56
action_16 (20) = happyGoto action_42
action_16 (21) = happyGoto action_43
action_16 (22) = happyGoto action_44
action_16 (24) = happyGoto action_45
action_16 _ = happyFail

action_17 (85) = happyShift action_8
action_17 (24) = happyGoto action_55
action_17 _ = happyFail

action_18 (39) = happyShift action_46
action_18 (41) = happyShift action_47
action_18 (55) = happyShift action_48
action_18 (63) = happyShift action_49
action_18 (81) = happyShift action_50
action_18 (82) = happyShift action_51
action_18 (83) = happyShift action_52
action_18 (84) = happyShift action_53
action_18 (85) = happyShift action_8
action_18 (19) = happyGoto action_54
action_18 (20) = happyGoto action_42
action_18 (21) = happyGoto action_43
action_18 (22) = happyGoto action_44
action_18 (24) = happyGoto action_45
action_18 _ = happyFail

action_19 (39) = happyShift action_46
action_19 (41) = happyShift action_47
action_19 (55) = happyShift action_48
action_19 (63) = happyShift action_49
action_19 (81) = happyShift action_50
action_19 (82) = happyShift action_51
action_19 (83) = happyShift action_52
action_19 (84) = happyShift action_53
action_19 (85) = happyShift action_8
action_19 (17) = happyGoto action_40
action_19 (19) = happyGoto action_41
action_19 (20) = happyGoto action_42
action_19 (21) = happyGoto action_43
action_19 (22) = happyGoto action_44
action_19 (24) = happyGoto action_45
action_19 _ = happyFail

action_20 (85) = happyShift action_8
action_20 (24) = happyGoto action_39
action_20 _ = happyFail

action_21 (34) = happyShift action_29
action_21 (35) = happyShift action_30
action_21 (36) = happyShift action_31
action_21 (37) = happyShift action_32
action_21 (38) = happyShift action_33
action_21 (11) = happyGoto action_36
action_21 (12) = happyGoto action_37
action_21 (15) = happyGoto action_38
action_21 (25) = happyGoto action_28
action_21 _ = happyReduce_21

action_22 (85) = happyShift action_8
action_22 (23) = happyGoto action_34
action_22 (24) = happyGoto action_35
action_22 _ = happyFail

action_23 _ = happyReduce_5

action_24 (34) = happyShift action_29
action_24 (35) = happyShift action_30
action_24 (36) = happyShift action_31
action_24 (37) = happyShift action_32
action_24 (38) = happyShift action_33
action_24 (13) = happyGoto action_25
action_24 (14) = happyGoto action_26
action_24 (15) = happyGoto action_27
action_24 (25) = happyGoto action_28
action_24 _ = happyReduce_25

action_25 (40) = happyShift action_107
action_25 _ = happyFail

action_26 (32) = happyShift action_106
action_26 _ = happyReduce_26

action_27 _ = happyReduce_27

action_28 (85) = happyShift action_8
action_28 (24) = happyGoto action_105
action_28 _ = happyFail

action_29 _ = happyReduce_76

action_30 _ = happyReduce_77

action_31 (39) = happyShift action_104
action_31 _ = happyFail

action_32 (39) = happyShift action_103
action_32 _ = happyFail

action_33 (39) = happyShift action_102
action_33 _ = happyFail

action_34 (77) = happyShift action_101
action_34 _ = happyFail

action_35 (43) = happyShift action_100
action_35 _ = happyReduce_73

action_36 (79) = happyShift action_99
action_36 _ = happyFail

action_37 (31) = happyShift action_98
action_37 _ = happyFail

action_38 _ = happyReduce_23

action_39 _ = happyReduce_18

action_40 (32) = happyShift action_97
action_40 _ = happyReduce_19

action_41 (43) = happyShift action_65
action_41 (53) = happyShift action_66
action_41 (54) = happyShift action_67
action_41 (56) = happyShift action_68
action_41 (57) = happyShift action_69
action_41 (58) = happyShift action_70
action_41 (59) = happyShift action_71
action_41 (60) = happyShift action_72
action_41 (61) = happyShift action_73
action_41 (62) = happyShift action_74
action_41 (63) = happyShift action_75
action_41 (64) = happyShift action_76
action_41 (65) = happyShift action_77
action_41 (66) = happyShift action_78
action_41 (67) = happyShift action_79
action_41 (68) = happyShift action_80
action_41 (69) = happyShift action_81
action_41 (70) = happyShift action_82
action_41 (71) = happyShift action_83
action_41 (72) = happyShift action_84
action_41 (73) = happyShift action_85
action_41 (74) = happyShift action_86
action_41 (75) = happyShift action_87
action_41 (76) = happyShift action_88
action_41 _ = happyReduce_33

action_42 _ = happyReduce_37

action_43 _ = happyReduce_38

action_44 _ = happyReduce_39

action_45 _ = happyReduce_40

action_46 (39) = happyShift action_46
action_46 (41) = happyShift action_47
action_46 (55) = happyShift action_48
action_46 (63) = happyShift action_49
action_46 (81) = happyShift action_50
action_46 (82) = happyShift action_51
action_46 (83) = happyShift action_52
action_46 (84) = happyShift action_53
action_46 (85) = happyShift action_8
action_46 (19) = happyGoto action_96
action_46 (20) = happyGoto action_42
action_46 (21) = happyGoto action_43
action_46 (22) = happyGoto action_44
action_46 (24) = happyGoto action_45
action_46 _ = happyFail

action_47 (39) = happyShift action_46
action_47 (41) = happyShift action_47
action_47 (55) = happyShift action_48
action_47 (63) = happyShift action_49
action_47 (81) = happyShift action_50
action_47 (82) = happyShift action_51
action_47 (83) = happyShift action_52
action_47 (84) = happyShift action_53
action_47 (85) = happyShift action_8
action_47 (17) = happyGoto action_94
action_47 (18) = happyGoto action_95
action_47 (19) = happyGoto action_41
action_47 (20) = happyGoto action_42
action_47 (21) = happyGoto action_43
action_47 (22) = happyGoto action_44
action_47 (24) = happyGoto action_45
action_47 _ = happyFail

action_48 (39) = happyShift action_46
action_48 (41) = happyShift action_47
action_48 (55) = happyShift action_48
action_48 (63) = happyShift action_49
action_48 (81) = happyShift action_50
action_48 (82) = happyShift action_51
action_48 (83) = happyShift action_52
action_48 (84) = happyShift action_53
action_48 (85) = happyShift action_8
action_48 (19) = happyGoto action_93
action_48 (20) = happyGoto action_42
action_48 (21) = happyGoto action_43
action_48 (22) = happyGoto action_44
action_48 (24) = happyGoto action_45
action_48 _ = happyFail

action_49 (39) = happyShift action_46
action_49 (41) = happyShift action_47
action_49 (55) = happyShift action_48
action_49 (63) = happyShift action_49
action_49 (81) = happyShift action_50
action_49 (82) = happyShift action_51
action_49 (83) = happyShift action_52
action_49 (84) = happyShift action_53
action_49 (85) = happyShift action_8
action_49 (19) = happyGoto action_92
action_49 (20) = happyGoto action_42
action_49 (21) = happyGoto action_43
action_49 (22) = happyGoto action_44
action_49 (24) = happyGoto action_45
action_49 _ = happyFail

action_50 _ = happyReduce_69

action_51 _ = happyReduce_70

action_52 _ = happyReduce_71

action_53 _ = happyReduce_72

action_54 (43) = happyShift action_65
action_54 (49) = happyShift action_91
action_54 (53) = happyShift action_66
action_54 (54) = happyShift action_67
action_54 (56) = happyShift action_68
action_54 (57) = happyShift action_69
action_54 (58) = happyShift action_70
action_54 (59) = happyShift action_71
action_54 (60) = happyShift action_72
action_54 (61) = happyShift action_73
action_54 (62) = happyShift action_74
action_54 (63) = happyShift action_75
action_54 (64) = happyShift action_76
action_54 (65) = happyShift action_77
action_54 (66) = happyShift action_78
action_54 (67) = happyShift action_79
action_54 (68) = happyShift action_80
action_54 (69) = happyShift action_81
action_54 (70) = happyShift action_82
action_54 (71) = happyShift action_83
action_54 (72) = happyShift action_84
action_54 (73) = happyShift action_85
action_54 (74) = happyShift action_86
action_54 (75) = happyShift action_87
action_54 (76) = happyShift action_88
action_54 _ = happyFail

action_55 (79) = happyShift action_90
action_55 _ = happyFail

action_56 (43) = happyShift action_65
action_56 (47) = happyShift action_89
action_56 (53) = happyShift action_66
action_56 (54) = happyShift action_67
action_56 (56) = happyShift action_68
action_56 (57) = happyShift action_69
action_56 (58) = happyShift action_70
action_56 (59) = happyShift action_71
action_56 (60) = happyShift action_72
action_56 (61) = happyShift action_73
action_56 (62) = happyShift action_74
action_56 (63) = happyShift action_75
action_56 (64) = happyShift action_76
action_56 (65) = happyShift action_77
action_56 (66) = happyShift action_78
action_56 (67) = happyShift action_79
action_56 (68) = happyShift action_80
action_56 (69) = happyShift action_81
action_56 (70) = happyShift action_82
action_56 (71) = happyShift action_83
action_56 (72) = happyShift action_84
action_56 (73) = happyShift action_85
action_56 (74) = happyShift action_86
action_56 (75) = happyShift action_87
action_56 (76) = happyShift action_88
action_56 _ = happyFail

action_57 (43) = happyShift action_65
action_57 (53) = happyShift action_66
action_57 (54) = happyShift action_67
action_57 (56) = happyShift action_68
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
action_57 _ = happyReduce_13

action_58 (39) = happyShift action_46
action_58 (41) = happyShift action_47
action_58 (55) = happyShift action_48
action_58 (63) = happyShift action_49
action_58 (81) = happyShift action_50
action_58 (82) = happyShift action_51
action_58 (83) = happyShift action_52
action_58 (84) = happyShift action_53
action_58 (85) = happyShift action_8
action_58 (16) = happyGoto action_63
action_58 (17) = happyGoto action_64
action_58 (19) = happyGoto action_41
action_58 (20) = happyGoto action_42
action_58 (21) = happyGoto action_43
action_58 (22) = happyGoto action_44
action_58 (24) = happyGoto action_45
action_58 _ = happyReduce_31

action_59 (30) = happyShift action_15
action_59 (45) = happyShift action_16
action_59 (48) = happyShift action_17
action_59 (50) = happyShift action_18
action_59 (51) = happyShift action_19
action_59 (52) = happyShift action_20
action_59 (78) = happyShift action_21
action_59 (80) = happyShift action_22
action_59 (85) = happyShift action_8
action_59 (10) = happyGoto action_62
action_59 (24) = happyGoto action_14
action_59 _ = happyReduce_8

action_60 (31) = happyShift action_61
action_60 _ = happyFail

action_61 _ = happyReduce_1

action_62 _ = happyReduce_10

action_63 (40) = happyShift action_148
action_63 _ = happyFail

action_64 (32) = happyShift action_97
action_64 _ = happyReduce_32

action_65 (39) = happyShift action_46
action_65 (41) = happyShift action_47
action_65 (55) = happyShift action_48
action_65 (63) = happyShift action_49
action_65 (81) = happyShift action_50
action_65 (82) = happyShift action_51
action_65 (83) = happyShift action_52
action_65 (84) = happyShift action_53
action_65 (85) = happyShift action_8
action_65 (17) = happyGoto action_147
action_65 (19) = happyGoto action_41
action_65 (20) = happyGoto action_42
action_65 (21) = happyGoto action_43
action_65 (22) = happyGoto action_44
action_65 (24) = happyGoto action_45
action_65 _ = happyFail

action_66 (39) = happyShift action_46
action_66 (41) = happyShift action_47
action_66 (55) = happyShift action_48
action_66 (63) = happyShift action_49
action_66 (81) = happyShift action_50
action_66 (82) = happyShift action_51
action_66 (83) = happyShift action_52
action_66 (84) = happyShift action_53
action_66 (85) = happyShift action_8
action_66 (19) = happyGoto action_146
action_66 (20) = happyGoto action_42
action_66 (21) = happyGoto action_43
action_66 (22) = happyGoto action_44
action_66 (24) = happyGoto action_45
action_66 _ = happyFail

action_67 (39) = happyShift action_46
action_67 (41) = happyShift action_47
action_67 (55) = happyShift action_48
action_67 (63) = happyShift action_49
action_67 (81) = happyShift action_50
action_67 (82) = happyShift action_51
action_67 (83) = happyShift action_52
action_67 (84) = happyShift action_53
action_67 (85) = happyShift action_8
action_67 (19) = happyGoto action_145
action_67 (20) = happyGoto action_42
action_67 (21) = happyGoto action_43
action_67 (22) = happyGoto action_44
action_67 (24) = happyGoto action_45
action_67 _ = happyFail

action_68 (39) = happyShift action_46
action_68 (41) = happyShift action_47
action_68 (55) = happyShift action_48
action_68 (63) = happyShift action_49
action_68 (81) = happyShift action_50
action_68 (82) = happyShift action_51
action_68 (83) = happyShift action_52
action_68 (84) = happyShift action_53
action_68 (85) = happyShift action_8
action_68 (19) = happyGoto action_144
action_68 (20) = happyGoto action_42
action_68 (21) = happyGoto action_43
action_68 (22) = happyGoto action_44
action_68 (24) = happyGoto action_45
action_68 _ = happyFail

action_69 (39) = happyShift action_46
action_69 (41) = happyShift action_47
action_69 (55) = happyShift action_48
action_69 (63) = happyShift action_49
action_69 (81) = happyShift action_50
action_69 (82) = happyShift action_51
action_69 (83) = happyShift action_52
action_69 (84) = happyShift action_53
action_69 (85) = happyShift action_8
action_69 (19) = happyGoto action_143
action_69 (20) = happyGoto action_42
action_69 (21) = happyGoto action_43
action_69 (22) = happyGoto action_44
action_69 (24) = happyGoto action_45
action_69 _ = happyFail

action_70 (39) = happyShift action_46
action_70 (41) = happyShift action_47
action_70 (55) = happyShift action_48
action_70 (63) = happyShift action_49
action_70 (81) = happyShift action_50
action_70 (82) = happyShift action_51
action_70 (83) = happyShift action_52
action_70 (84) = happyShift action_53
action_70 (85) = happyShift action_8
action_70 (19) = happyGoto action_142
action_70 (20) = happyGoto action_42
action_70 (21) = happyGoto action_43
action_70 (22) = happyGoto action_44
action_70 (24) = happyGoto action_45
action_70 _ = happyFail

action_71 (39) = happyShift action_46
action_71 (41) = happyShift action_47
action_71 (55) = happyShift action_48
action_71 (63) = happyShift action_49
action_71 (81) = happyShift action_50
action_71 (82) = happyShift action_51
action_71 (83) = happyShift action_52
action_71 (84) = happyShift action_53
action_71 (85) = happyShift action_8
action_71 (19) = happyGoto action_141
action_71 (20) = happyGoto action_42
action_71 (21) = happyGoto action_43
action_71 (22) = happyGoto action_44
action_71 (24) = happyGoto action_45
action_71 _ = happyFail

action_72 (39) = happyShift action_46
action_72 (41) = happyShift action_47
action_72 (55) = happyShift action_48
action_72 (63) = happyShift action_49
action_72 (81) = happyShift action_50
action_72 (82) = happyShift action_51
action_72 (83) = happyShift action_52
action_72 (84) = happyShift action_53
action_72 (85) = happyShift action_8
action_72 (19) = happyGoto action_140
action_72 (20) = happyGoto action_42
action_72 (21) = happyGoto action_43
action_72 (22) = happyGoto action_44
action_72 (24) = happyGoto action_45
action_72 _ = happyFail

action_73 (39) = happyShift action_46
action_73 (41) = happyShift action_47
action_73 (55) = happyShift action_48
action_73 (63) = happyShift action_49
action_73 (81) = happyShift action_50
action_73 (82) = happyShift action_51
action_73 (83) = happyShift action_52
action_73 (84) = happyShift action_53
action_73 (85) = happyShift action_8
action_73 (19) = happyGoto action_139
action_73 (20) = happyGoto action_42
action_73 (21) = happyGoto action_43
action_73 (22) = happyGoto action_44
action_73 (24) = happyGoto action_45
action_73 _ = happyFail

action_74 (39) = happyShift action_46
action_74 (41) = happyShift action_47
action_74 (55) = happyShift action_48
action_74 (63) = happyShift action_49
action_74 (81) = happyShift action_50
action_74 (82) = happyShift action_51
action_74 (83) = happyShift action_52
action_74 (84) = happyShift action_53
action_74 (85) = happyShift action_8
action_74 (19) = happyGoto action_138
action_74 (20) = happyGoto action_42
action_74 (21) = happyGoto action_43
action_74 (22) = happyGoto action_44
action_74 (24) = happyGoto action_45
action_74 _ = happyFail

action_75 (39) = happyShift action_46
action_75 (41) = happyShift action_47
action_75 (55) = happyShift action_48
action_75 (63) = happyShift action_49
action_75 (81) = happyShift action_50
action_75 (82) = happyShift action_51
action_75 (83) = happyShift action_52
action_75 (84) = happyShift action_53
action_75 (85) = happyShift action_8
action_75 (19) = happyGoto action_137
action_75 (20) = happyGoto action_42
action_75 (21) = happyGoto action_43
action_75 (22) = happyGoto action_44
action_75 (24) = happyGoto action_45
action_75 _ = happyFail

action_76 (39) = happyShift action_46
action_76 (41) = happyShift action_47
action_76 (55) = happyShift action_48
action_76 (63) = happyShift action_49
action_76 (81) = happyShift action_50
action_76 (82) = happyShift action_51
action_76 (83) = happyShift action_52
action_76 (84) = happyShift action_53
action_76 (85) = happyShift action_8
action_76 (19) = happyGoto action_136
action_76 (20) = happyGoto action_42
action_76 (21) = happyGoto action_43
action_76 (22) = happyGoto action_44
action_76 (24) = happyGoto action_45
action_76 _ = happyFail

action_77 (39) = happyShift action_46
action_77 (41) = happyShift action_47
action_77 (55) = happyShift action_48
action_77 (63) = happyShift action_49
action_77 (81) = happyShift action_50
action_77 (82) = happyShift action_51
action_77 (83) = happyShift action_52
action_77 (84) = happyShift action_53
action_77 (85) = happyShift action_8
action_77 (19) = happyGoto action_135
action_77 (20) = happyGoto action_42
action_77 (21) = happyGoto action_43
action_77 (22) = happyGoto action_44
action_77 (24) = happyGoto action_45
action_77 _ = happyFail

action_78 (39) = happyShift action_46
action_78 (41) = happyShift action_47
action_78 (55) = happyShift action_48
action_78 (63) = happyShift action_49
action_78 (81) = happyShift action_50
action_78 (82) = happyShift action_51
action_78 (83) = happyShift action_52
action_78 (84) = happyShift action_53
action_78 (85) = happyShift action_8
action_78 (19) = happyGoto action_134
action_78 (20) = happyGoto action_42
action_78 (21) = happyGoto action_43
action_78 (22) = happyGoto action_44
action_78 (24) = happyGoto action_45
action_78 _ = happyFail

action_79 (39) = happyShift action_46
action_79 (41) = happyShift action_47
action_79 (55) = happyShift action_48
action_79 (63) = happyShift action_49
action_79 (81) = happyShift action_50
action_79 (82) = happyShift action_51
action_79 (83) = happyShift action_52
action_79 (84) = happyShift action_53
action_79 (85) = happyShift action_8
action_79 (19) = happyGoto action_133
action_79 (20) = happyGoto action_42
action_79 (21) = happyGoto action_43
action_79 (22) = happyGoto action_44
action_79 (24) = happyGoto action_45
action_79 _ = happyFail

action_80 (39) = happyShift action_46
action_80 (41) = happyShift action_47
action_80 (55) = happyShift action_48
action_80 (63) = happyShift action_49
action_80 (81) = happyShift action_50
action_80 (82) = happyShift action_51
action_80 (83) = happyShift action_52
action_80 (84) = happyShift action_53
action_80 (85) = happyShift action_8
action_80 (19) = happyGoto action_132
action_80 (20) = happyGoto action_42
action_80 (21) = happyGoto action_43
action_80 (22) = happyGoto action_44
action_80 (24) = happyGoto action_45
action_80 _ = happyFail

action_81 _ = happyReduce_64

action_82 (39) = happyShift action_46
action_82 (41) = happyShift action_47
action_82 (55) = happyShift action_48
action_82 (63) = happyShift action_49
action_82 (81) = happyShift action_50
action_82 (82) = happyShift action_51
action_82 (83) = happyShift action_52
action_82 (84) = happyShift action_53
action_82 (85) = happyShift action_8
action_82 (19) = happyGoto action_131
action_82 (20) = happyGoto action_42
action_82 (21) = happyGoto action_43
action_82 (22) = happyGoto action_44
action_82 (24) = happyGoto action_45
action_82 _ = happyFail

action_83 (39) = happyShift action_46
action_83 (41) = happyShift action_47
action_83 (55) = happyShift action_48
action_83 (63) = happyShift action_49
action_83 (81) = happyShift action_50
action_83 (82) = happyShift action_51
action_83 (83) = happyShift action_52
action_83 (84) = happyShift action_53
action_83 (85) = happyShift action_8
action_83 (19) = happyGoto action_130
action_83 (20) = happyGoto action_42
action_83 (21) = happyGoto action_43
action_83 (22) = happyGoto action_44
action_83 (24) = happyGoto action_45
action_83 _ = happyFail

action_84 (39) = happyShift action_46
action_84 (41) = happyShift action_47
action_84 (55) = happyShift action_48
action_84 (63) = happyShift action_49
action_84 (81) = happyShift action_50
action_84 (82) = happyShift action_51
action_84 (83) = happyShift action_52
action_84 (84) = happyShift action_53
action_84 (85) = happyShift action_8
action_84 (19) = happyGoto action_129
action_84 (20) = happyGoto action_42
action_84 (21) = happyGoto action_43
action_84 (22) = happyGoto action_44
action_84 (24) = happyGoto action_45
action_84 _ = happyFail

action_85 (39) = happyShift action_46
action_85 (41) = happyShift action_47
action_85 (55) = happyShift action_48
action_85 (63) = happyShift action_49
action_85 (81) = happyShift action_50
action_85 (82) = happyShift action_51
action_85 (83) = happyShift action_52
action_85 (84) = happyShift action_53
action_85 (85) = happyShift action_8
action_85 (19) = happyGoto action_128
action_85 (20) = happyGoto action_42
action_85 (21) = happyGoto action_43
action_85 (22) = happyGoto action_44
action_85 (24) = happyGoto action_45
action_85 _ = happyFail

action_86 (39) = happyShift action_46
action_86 (41) = happyShift action_47
action_86 (55) = happyShift action_48
action_86 (63) = happyShift action_49
action_86 (81) = happyShift action_50
action_86 (82) = happyShift action_51
action_86 (83) = happyShift action_52
action_86 (84) = happyShift action_53
action_86 (85) = happyShift action_8
action_86 (19) = happyGoto action_127
action_86 (20) = happyGoto action_42
action_86 (21) = happyGoto action_43
action_86 (22) = happyGoto action_44
action_86 (24) = happyGoto action_45
action_86 _ = happyFail

action_87 (39) = happyShift action_46
action_87 (41) = happyShift action_47
action_87 (55) = happyShift action_48
action_87 (63) = happyShift action_49
action_87 (81) = happyShift action_50
action_87 (82) = happyShift action_51
action_87 (83) = happyShift action_52
action_87 (84) = happyShift action_53
action_87 (85) = happyShift action_8
action_87 (19) = happyGoto action_126
action_87 (20) = happyGoto action_42
action_87 (21) = happyGoto action_43
action_87 (22) = happyGoto action_44
action_87 (24) = happyGoto action_45
action_87 _ = happyFail

action_88 (39) = happyShift action_46
action_88 (41) = happyShift action_47
action_88 (55) = happyShift action_48
action_88 (63) = happyShift action_49
action_88 (81) = happyShift action_50
action_88 (82) = happyShift action_51
action_88 (83) = happyShift action_52
action_88 (84) = happyShift action_53
action_88 (85) = happyShift action_8
action_88 (19) = happyGoto action_125
action_88 (20) = happyGoto action_42
action_88 (21) = happyGoto action_43
action_88 (22) = happyGoto action_44
action_88 (24) = happyGoto action_45
action_88 _ = happyFail

action_89 (30) = happyShift action_15
action_89 (45) = happyShift action_16
action_89 (48) = happyShift action_17
action_89 (50) = happyShift action_18
action_89 (51) = happyShift action_19
action_89 (52) = happyShift action_20
action_89 (78) = happyShift action_21
action_89 (80) = happyShift action_22
action_89 (85) = happyShift action_8
action_89 (8) = happyGoto action_124
action_89 (9) = happyGoto action_12
action_89 (10) = happyGoto action_13
action_89 (24) = happyGoto action_14
action_89 _ = happyReduce_7

action_90 (39) = happyShift action_46
action_90 (41) = happyShift action_47
action_90 (55) = happyShift action_48
action_90 (63) = happyShift action_49
action_90 (81) = happyShift action_50
action_90 (82) = happyShift action_51
action_90 (83) = happyShift action_52
action_90 (84) = happyShift action_53
action_90 (85) = happyShift action_8
action_90 (19) = happyGoto action_123
action_90 (20) = happyGoto action_42
action_90 (21) = happyGoto action_43
action_90 (22) = happyGoto action_44
action_90 (24) = happyGoto action_45
action_90 _ = happyFail

action_91 (30) = happyShift action_15
action_91 (45) = happyShift action_16
action_91 (48) = happyShift action_17
action_91 (50) = happyShift action_18
action_91 (51) = happyShift action_19
action_91 (52) = happyShift action_20
action_91 (78) = happyShift action_21
action_91 (80) = happyShift action_22
action_91 (85) = happyShift action_8
action_91 (8) = happyGoto action_122
action_91 (9) = happyGoto action_12
action_91 (10) = happyGoto action_13
action_91 (24) = happyGoto action_14
action_91 _ = happyReduce_7

action_92 (69) = happyShift action_81
action_92 _ = happyReduce_65

action_93 (43) = happyShift action_65
action_93 (62) = happyShift action_74
action_93 (63) = happyShift action_75
action_93 (64) = happyShift action_76
action_93 (65) = happyShift action_77
action_93 (66) = happyShift action_78
action_93 (67) = happyShift action_79
action_93 (68) = happyShift action_80
action_93 (69) = happyShift action_81
action_93 (70) = happyShift action_82
action_93 (71) = happyShift action_83
action_93 (72) = happyShift action_84
action_93 (73) = happyShift action_85
action_93 (74) = happyShift action_86
action_93 (75) = happyShift action_87
action_93 (76) = happyShift action_88
action_93 _ = happyReduce_67

action_94 (32) = happyShift action_97
action_94 _ = happyReduce_35

action_95 (33) = happyShift action_120
action_95 (42) = happyShift action_121
action_95 _ = happyFail

action_96 (40) = happyShift action_119
action_96 (43) = happyShift action_65
action_96 (53) = happyShift action_66
action_96 (54) = happyShift action_67
action_96 (56) = happyShift action_68
action_96 (57) = happyShift action_69
action_96 (58) = happyShift action_70
action_96 (59) = happyShift action_71
action_96 (60) = happyShift action_72
action_96 (61) = happyShift action_73
action_96 (62) = happyShift action_74
action_96 (63) = happyShift action_75
action_96 (64) = happyShift action_76
action_96 (65) = happyShift action_77
action_96 (66) = happyShift action_78
action_96 (67) = happyShift action_79
action_96 (68) = happyShift action_80
action_96 (69) = happyShift action_81
action_96 (70) = happyShift action_82
action_96 (71) = happyShift action_83
action_96 (72) = happyShift action_84
action_96 (73) = happyShift action_85
action_96 (74) = happyShift action_86
action_96 (75) = happyShift action_87
action_96 (76) = happyShift action_88
action_96 _ = happyFail

action_97 (39) = happyShift action_46
action_97 (41) = happyShift action_47
action_97 (55) = happyShift action_48
action_97 (63) = happyShift action_49
action_97 (81) = happyShift action_50
action_97 (82) = happyShift action_51
action_97 (83) = happyShift action_52
action_97 (84) = happyShift action_53
action_97 (85) = happyShift action_8
action_97 (19) = happyGoto action_118
action_97 (20) = happyGoto action_42
action_97 (21) = happyGoto action_43
action_97 (22) = happyGoto action_44
action_97 (24) = happyGoto action_45
action_97 _ = happyFail

action_98 (34) = happyShift action_29
action_98 (35) = happyShift action_30
action_98 (36) = happyShift action_31
action_98 (37) = happyShift action_32
action_98 (38) = happyShift action_33
action_98 (15) = happyGoto action_117
action_98 (25) = happyGoto action_28
action_98 _ = happyReduce_22

action_99 (30) = happyShift action_15
action_99 (45) = happyShift action_16
action_99 (48) = happyShift action_17
action_99 (50) = happyShift action_18
action_99 (51) = happyShift action_19
action_99 (52) = happyShift action_20
action_99 (78) = happyShift action_21
action_99 (80) = happyShift action_22
action_99 (85) = happyShift action_8
action_99 (8) = happyGoto action_116
action_99 (9) = happyGoto action_12
action_99 (10) = happyGoto action_13
action_99 (24) = happyGoto action_14
action_99 _ = happyReduce_7

action_100 (39) = happyShift action_46
action_100 (41) = happyShift action_47
action_100 (55) = happyShift action_48
action_100 (63) = happyShift action_49
action_100 (81) = happyShift action_50
action_100 (82) = happyShift action_51
action_100 (83) = happyShift action_52
action_100 (84) = happyShift action_53
action_100 (85) = happyShift action_8
action_100 (17) = happyGoto action_115
action_100 (19) = happyGoto action_41
action_100 (20) = happyGoto action_42
action_100 (21) = happyGoto action_43
action_100 (22) = happyGoto action_44
action_100 (24) = happyGoto action_45
action_100 _ = happyFail

action_101 (39) = happyShift action_46
action_101 (41) = happyShift action_47
action_101 (55) = happyShift action_48
action_101 (63) = happyShift action_49
action_101 (81) = happyShift action_50
action_101 (82) = happyShift action_51
action_101 (83) = happyShift action_52
action_101 (84) = happyShift action_53
action_101 (85) = happyShift action_8
action_101 (19) = happyGoto action_114
action_101 (20) = happyGoto action_42
action_101 (21) = happyGoto action_43
action_101 (22) = happyGoto action_44
action_101 (24) = happyGoto action_45
action_101 _ = happyFail

action_102 (39) = happyShift action_46
action_102 (41) = happyShift action_47
action_102 (55) = happyShift action_48
action_102 (63) = happyShift action_49
action_102 (81) = happyShift action_50
action_102 (82) = happyShift action_51
action_102 (83) = happyShift action_52
action_102 (84) = happyShift action_53
action_102 (85) = happyShift action_8
action_102 (19) = happyGoto action_113
action_102 (20) = happyGoto action_42
action_102 (21) = happyGoto action_43
action_102 (22) = happyGoto action_44
action_102 (24) = happyGoto action_45
action_102 _ = happyFail

action_103 (39) = happyShift action_46
action_103 (41) = happyShift action_47
action_103 (55) = happyShift action_48
action_103 (63) = happyShift action_49
action_103 (81) = happyShift action_50
action_103 (82) = happyShift action_51
action_103 (83) = happyShift action_52
action_103 (84) = happyShift action_53
action_103 (85) = happyShift action_8
action_103 (19) = happyGoto action_112
action_103 (20) = happyGoto action_42
action_103 (21) = happyGoto action_43
action_103 (22) = happyGoto action_44
action_103 (24) = happyGoto action_45
action_103 _ = happyFail

action_104 (39) = happyShift action_46
action_104 (41) = happyShift action_47
action_104 (55) = happyShift action_48
action_104 (63) = happyShift action_49
action_104 (81) = happyShift action_50
action_104 (82) = happyShift action_51
action_104 (83) = happyShift action_52
action_104 (84) = happyShift action_53
action_104 (85) = happyShift action_8
action_104 (19) = happyGoto action_111
action_104 (20) = happyGoto action_42
action_104 (21) = happyGoto action_43
action_104 (22) = happyGoto action_44
action_104 (24) = happyGoto action_45
action_104 _ = happyFail

action_105 (77) = happyShift action_110
action_105 _ = happyReduce_29

action_106 (34) = happyShift action_29
action_106 (35) = happyShift action_30
action_106 (36) = happyShift action_31
action_106 (37) = happyShift action_32
action_106 (38) = happyShift action_33
action_106 (15) = happyGoto action_109
action_106 (25) = happyGoto action_28
action_106 _ = happyFail

action_107 (30) = happyShift action_108
action_107 _ = happyFail

action_108 (34) = happyShift action_29
action_108 (35) = happyShift action_30
action_108 (36) = happyShift action_31
action_108 (37) = happyShift action_32
action_108 (38) = happyShift action_33
action_108 (25) = happyGoto action_161
action_108 _ = happyFail

action_109 _ = happyReduce_28

action_110 (39) = happyShift action_46
action_110 (41) = happyShift action_47
action_110 (55) = happyShift action_48
action_110 (63) = happyShift action_49
action_110 (81) = happyShift action_50
action_110 (82) = happyShift action_51
action_110 (83) = happyShift action_52
action_110 (84) = happyShift action_53
action_110 (85) = happyShift action_8
action_110 (19) = happyGoto action_160
action_110 (20) = happyGoto action_42
action_110 (21) = happyGoto action_43
action_110 (22) = happyGoto action_44
action_110 (24) = happyGoto action_45
action_110 _ = happyFail

action_111 (32) = happyShift action_159
action_111 (43) = happyShift action_65
action_111 (53) = happyShift action_66
action_111 (54) = happyShift action_67
action_111 (56) = happyShift action_68
action_111 (57) = happyShift action_69
action_111 (58) = happyShift action_70
action_111 (59) = happyShift action_71
action_111 (60) = happyShift action_72
action_111 (61) = happyShift action_73
action_111 (62) = happyShift action_74
action_111 (63) = happyShift action_75
action_111 (64) = happyShift action_76
action_111 (65) = happyShift action_77
action_111 (66) = happyShift action_78
action_111 (67) = happyShift action_79
action_111 (68) = happyShift action_80
action_111 (69) = happyShift action_81
action_111 (70) = happyShift action_82
action_111 (71) = happyShift action_83
action_111 (72) = happyShift action_84
action_111 (73) = happyShift action_85
action_111 (74) = happyShift action_86
action_111 (75) = happyShift action_87
action_111 (76) = happyShift action_88
action_111 _ = happyFail

action_112 (40) = happyShift action_158
action_112 (43) = happyShift action_65
action_112 (53) = happyShift action_66
action_112 (54) = happyShift action_67
action_112 (56) = happyShift action_68
action_112 (57) = happyShift action_69
action_112 (58) = happyShift action_70
action_112 (59) = happyShift action_71
action_112 (60) = happyShift action_72
action_112 (61) = happyShift action_73
action_112 (62) = happyShift action_74
action_112 (63) = happyShift action_75
action_112 (64) = happyShift action_76
action_112 (65) = happyShift action_77
action_112 (66) = happyShift action_78
action_112 (67) = happyShift action_79
action_112 (68) = happyShift action_80
action_112 (69) = happyShift action_81
action_112 (70) = happyShift action_82
action_112 (71) = happyShift action_83
action_112 (72) = happyShift action_84
action_112 (73) = happyShift action_85
action_112 (74) = happyShift action_86
action_112 (75) = happyShift action_87
action_112 (76) = happyShift action_88
action_112 _ = happyFail

action_113 (40) = happyShift action_157
action_113 (43) = happyShift action_65
action_113 (53) = happyShift action_66
action_113 (54) = happyShift action_67
action_113 (56) = happyShift action_68
action_113 (57) = happyShift action_69
action_113 (58) = happyShift action_70
action_113 (59) = happyShift action_71
action_113 (60) = happyShift action_72
action_113 (61) = happyShift action_73
action_113 (62) = happyShift action_74
action_113 (63) = happyShift action_75
action_113 (64) = happyShift action_76
action_113 (65) = happyShift action_77
action_113 (66) = happyShift action_78
action_113 (67) = happyShift action_79
action_113 (68) = happyShift action_80
action_113 (69) = happyShift action_81
action_113 (70) = happyShift action_82
action_113 (71) = happyShift action_83
action_113 (72) = happyShift action_84
action_113 (73) = happyShift action_85
action_113 (74) = happyShift action_86
action_113 (75) = happyShift action_87
action_113 (76) = happyShift action_88
action_113 _ = happyFail

action_114 (43) = happyShift action_65
action_114 (53) = happyShift action_66
action_114 (54) = happyShift action_67
action_114 (56) = happyShift action_68
action_114 (57) = happyShift action_69
action_114 (58) = happyShift action_70
action_114 (59) = happyShift action_71
action_114 (60) = happyShift action_72
action_114 (61) = happyShift action_73
action_114 (62) = happyShift action_74
action_114 (63) = happyShift action_75
action_114 (64) = happyShift action_76
action_114 (65) = happyShift action_77
action_114 (66) = happyShift action_78
action_114 (67) = happyShift action_79
action_114 (68) = happyShift action_80
action_114 (69) = happyShift action_81
action_114 (70) = happyShift action_82
action_114 (71) = happyShift action_83
action_114 (72) = happyShift action_84
action_114 (73) = happyShift action_85
action_114 (74) = happyShift action_86
action_114 (75) = happyShift action_87
action_114 (76) = happyShift action_88
action_114 _ = happyReduce_11

action_115 (32) = happyShift action_97
action_115 (44) = happyShift action_156
action_115 _ = happyFail

action_116 (28) = happyShift action_155
action_116 _ = happyFail

action_117 _ = happyReduce_24

action_118 (43) = happyShift action_65
action_118 (53) = happyShift action_66
action_118 (54) = happyShift action_67
action_118 (56) = happyShift action_68
action_118 (57) = happyShift action_69
action_118 (58) = happyShift action_70
action_118 (59) = happyShift action_71
action_118 (60) = happyShift action_72
action_118 (61) = happyShift action_73
action_118 (62) = happyShift action_74
action_118 (63) = happyShift action_75
action_118 (64) = happyShift action_76
action_118 (65) = happyShift action_77
action_118 (66) = happyShift action_78
action_118 (67) = happyShift action_79
action_118 (68) = happyShift action_80
action_118 (69) = happyShift action_81
action_118 (70) = happyShift action_82
action_118 (71) = happyShift action_83
action_118 (72) = happyShift action_84
action_118 (73) = happyShift action_85
action_118 (74) = happyShift action_86
action_118 (75) = happyShift action_87
action_118 (76) = happyShift action_88
action_118 _ = happyReduce_34

action_119 _ = happyReduce_68

action_120 (39) = happyShift action_46
action_120 (41) = happyShift action_47
action_120 (55) = happyShift action_48
action_120 (63) = happyShift action_49
action_120 (81) = happyShift action_50
action_120 (82) = happyShift action_51
action_120 (83) = happyShift action_52
action_120 (84) = happyShift action_53
action_120 (85) = happyShift action_8
action_120 (17) = happyGoto action_154
action_120 (19) = happyGoto action_41
action_120 (20) = happyGoto action_42
action_120 (21) = happyGoto action_43
action_120 (22) = happyGoto action_44
action_120 (24) = happyGoto action_45
action_120 _ = happyFail

action_121 _ = happyReduce_41

action_122 (28) = happyShift action_153
action_122 _ = happyFail

action_123 (43) = happyShift action_65
action_123 (49) = happyShift action_152
action_123 (53) = happyShift action_66
action_123 (54) = happyShift action_67
action_123 (56) = happyShift action_68
action_123 (57) = happyShift action_69
action_123 (58) = happyShift action_70
action_123 (59) = happyShift action_71
action_123 (60) = happyShift action_72
action_123 (61) = happyShift action_73
action_123 (62) = happyShift action_74
action_123 (63) = happyShift action_75
action_123 (64) = happyShift action_76
action_123 (65) = happyShift action_77
action_123 (66) = happyShift action_78
action_123 (67) = happyShift action_79
action_123 (68) = happyShift action_80
action_123 (69) = happyShift action_81
action_123 (70) = happyShift action_82
action_123 (71) = happyShift action_83
action_123 (72) = happyShift action_84
action_123 (73) = happyShift action_85
action_123 (74) = happyShift action_86
action_123 (75) = happyShift action_87
action_123 (76) = happyShift action_88
action_123 _ = happyFail

action_124 (28) = happyShift action_150
action_124 (46) = happyShift action_151
action_124 _ = happyFail

action_125 (43) = happyShift action_65
action_125 (69) = happyShift action_81
action_125 _ = happyReduce_55

action_126 (43) = happyShift action_65
action_126 (69) = happyShift action_81
action_126 _ = happyReduce_54

action_127 (43) = happyShift action_65
action_127 (69) = happyShift action_81
action_127 _ = happyReduce_53

action_128 (43) = happyShift action_65
action_128 (69) = happyShift action_81
action_128 _ = happyReduce_52

action_129 (43) = happyShift action_65
action_129 (69) = happyShift action_81
action_129 _ = happyReduce_51

action_130 (43) = happyShift action_65
action_130 (64) = happyShift action_76
action_130 (65) = happyShift action_77
action_130 (66) = happyShift action_78
action_130 (67) = happyShift action_79
action_130 (68) = happyShift action_80
action_130 (69) = happyShift action_81
action_130 (72) = happyShift action_84
action_130 (73) = happyShift action_85
action_130 (74) = happyShift action_86
action_130 (75) = happyShift action_87
action_130 (76) = happyShift action_88
action_130 _ = happyReduce_50

action_131 (43) = happyShift action_65
action_131 (64) = happyShift action_76
action_131 (65) = happyShift action_77
action_131 (66) = happyShift action_78
action_131 (67) = happyShift action_79
action_131 (68) = happyShift action_80
action_131 (69) = happyShift action_81
action_131 (72) = happyShift action_84
action_131 (73) = happyShift action_85
action_131 (74) = happyShift action_86
action_131 (75) = happyShift action_87
action_131 (76) = happyShift action_88
action_131 _ = happyReduce_49

action_132 (43) = happyShift action_65
action_132 (69) = happyShift action_81
action_132 _ = happyReduce_48

action_133 (43) = happyShift action_65
action_133 (69) = happyShift action_81
action_133 _ = happyReduce_47

action_134 (43) = happyShift action_65
action_134 (69) = happyShift action_81
action_134 _ = happyReduce_46

action_135 (43) = happyShift action_65
action_135 (69) = happyShift action_81
action_135 _ = happyReduce_45

action_136 (43) = happyShift action_65
action_136 (69) = happyShift action_81
action_136 _ = happyReduce_44

action_137 (43) = happyShift action_65
action_137 (64) = happyShift action_76
action_137 (65) = happyShift action_77
action_137 (66) = happyShift action_78
action_137 (67) = happyShift action_79
action_137 (68) = happyShift action_80
action_137 (69) = happyShift action_81
action_137 (72) = happyShift action_84
action_137 (73) = happyShift action_85
action_137 (74) = happyShift action_86
action_137 (75) = happyShift action_87
action_137 (76) = happyShift action_88
action_137 _ = happyReduce_43

action_138 (43) = happyShift action_65
action_138 (64) = happyShift action_76
action_138 (65) = happyShift action_77
action_138 (66) = happyShift action_78
action_138 (67) = happyShift action_79
action_138 (68) = happyShift action_80
action_138 (69) = happyShift action_81
action_138 (72) = happyShift action_84
action_138 (73) = happyShift action_85
action_138 (74) = happyShift action_86
action_138 (75) = happyShift action_87
action_138 (76) = happyShift action_88
action_138 _ = happyReduce_42

action_139 (43) = happyShift action_65
action_139 (56) = happyFail
action_139 (57) = happyFail
action_139 (58) = happyFail
action_139 (59) = happyFail
action_139 (60) = happyFail
action_139 (61) = happyFail
action_139 (62) = happyShift action_74
action_139 (63) = happyShift action_75
action_139 (64) = happyShift action_76
action_139 (65) = happyShift action_77
action_139 (66) = happyShift action_78
action_139 (67) = happyShift action_79
action_139 (68) = happyShift action_80
action_139 (69) = happyShift action_81
action_139 (70) = happyShift action_82
action_139 (71) = happyShift action_83
action_139 (72) = happyShift action_84
action_139 (73) = happyShift action_85
action_139 (74) = happyShift action_86
action_139 (75) = happyShift action_87
action_139 (76) = happyShift action_88
action_139 _ = happyReduce_62

action_140 (43) = happyShift action_65
action_140 (56) = happyFail
action_140 (57) = happyFail
action_140 (58) = happyFail
action_140 (59) = happyFail
action_140 (60) = happyFail
action_140 (61) = happyFail
action_140 (62) = happyShift action_74
action_140 (63) = happyShift action_75
action_140 (64) = happyShift action_76
action_140 (65) = happyShift action_77
action_140 (66) = happyShift action_78
action_140 (67) = happyShift action_79
action_140 (68) = happyShift action_80
action_140 (69) = happyShift action_81
action_140 (70) = happyShift action_82
action_140 (71) = happyShift action_83
action_140 (72) = happyShift action_84
action_140 (73) = happyShift action_85
action_140 (74) = happyShift action_86
action_140 (75) = happyShift action_87
action_140 (76) = happyShift action_88
action_140 _ = happyReduce_63

action_141 (43) = happyShift action_65
action_141 (56) = happyFail
action_141 (57) = happyFail
action_141 (58) = happyFail
action_141 (59) = happyFail
action_141 (60) = happyFail
action_141 (61) = happyFail
action_141 (62) = happyShift action_74
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
action_141 _ = happyReduce_60

action_142 (43) = happyShift action_65
action_142 (56) = happyFail
action_142 (57) = happyFail
action_142 (58) = happyFail
action_142 (59) = happyFail
action_142 (60) = happyFail
action_142 (61) = happyFail
action_142 (62) = happyShift action_74
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
action_142 _ = happyReduce_61

action_143 (43) = happyShift action_65
action_143 (56) = happyFail
action_143 (57) = happyFail
action_143 (58) = happyFail
action_143 (59) = happyFail
action_143 (60) = happyFail
action_143 (61) = happyFail
action_143 (62) = happyShift action_74
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
action_143 _ = happyReduce_59

action_144 (43) = happyShift action_65
action_144 (56) = happyFail
action_144 (57) = happyFail
action_144 (58) = happyFail
action_144 (59) = happyFail
action_144 (60) = happyFail
action_144 (61) = happyFail
action_144 (62) = happyShift action_74
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
action_144 _ = happyReduce_58

action_145 (43) = happyShift action_65
action_145 (53) = happyShift action_66
action_145 (56) = happyShift action_68
action_145 (57) = happyShift action_69
action_145 (58) = happyShift action_70
action_145 (59) = happyShift action_71
action_145 (60) = happyShift action_72
action_145 (61) = happyShift action_73
action_145 (62) = happyShift action_74
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
action_145 _ = happyReduce_56

action_146 (43) = happyShift action_65
action_146 (56) = happyShift action_68
action_146 (57) = happyShift action_69
action_146 (58) = happyShift action_70
action_146 (59) = happyShift action_71
action_146 (60) = happyShift action_72
action_146 (61) = happyShift action_73
action_146 (62) = happyShift action_74
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
action_146 _ = happyReduce_57

action_147 (32) = happyShift action_97
action_147 (44) = happyShift action_149
action_147 _ = happyFail

action_148 _ = happyReduce_12

action_149 _ = happyReduce_66

action_150 _ = happyReduce_15

action_151 (30) = happyShift action_15
action_151 (45) = happyShift action_16
action_151 (48) = happyShift action_17
action_151 (50) = happyShift action_18
action_151 (51) = happyShift action_19
action_151 (52) = happyShift action_20
action_151 (78) = happyShift action_21
action_151 (80) = happyShift action_22
action_151 (85) = happyShift action_8
action_151 (8) = happyGoto action_165
action_151 (9) = happyGoto action_12
action_151 (10) = happyGoto action_13
action_151 (24) = happyGoto action_14
action_151 _ = happyReduce_7

action_152 (30) = happyShift action_15
action_152 (45) = happyShift action_16
action_152 (48) = happyShift action_17
action_152 (50) = happyShift action_18
action_152 (51) = happyShift action_19
action_152 (52) = happyShift action_20
action_152 (78) = happyShift action_21
action_152 (80) = happyShift action_22
action_152 (85) = happyShift action_8
action_152 (8) = happyGoto action_164
action_152 (9) = happyGoto action_12
action_152 (10) = happyGoto action_13
action_152 (24) = happyGoto action_14
action_152 _ = happyReduce_7

action_153 _ = happyReduce_17

action_154 (32) = happyShift action_97
action_154 _ = happyReduce_36

action_155 _ = happyReduce_20

action_156 _ = happyReduce_74

action_157 _ = happyReduce_80

action_158 _ = happyReduce_79

action_159 (39) = happyShift action_46
action_159 (41) = happyShift action_47
action_159 (55) = happyShift action_48
action_159 (63) = happyShift action_49
action_159 (81) = happyShift action_50
action_159 (82) = happyShift action_51
action_159 (83) = happyShift action_52
action_159 (84) = happyShift action_53
action_159 (85) = happyShift action_8
action_159 (19) = happyGoto action_163
action_159 (20) = happyGoto action_42
action_159 (21) = happyGoto action_43
action_159 (22) = happyGoto action_44
action_159 (24) = happyGoto action_45
action_159 _ = happyFail

action_160 (43) = happyShift action_65
action_160 (53) = happyShift action_66
action_160 (54) = happyShift action_67
action_160 (56) = happyShift action_68
action_160 (57) = happyShift action_69
action_160 (58) = happyShift action_70
action_160 (59) = happyShift action_71
action_160 (60) = happyShift action_72
action_160 (61) = happyShift action_73
action_160 (62) = happyShift action_74
action_160 (63) = happyShift action_75
action_160 (64) = happyShift action_76
action_160 (65) = happyShift action_77
action_160 (66) = happyShift action_78
action_160 (67) = happyShift action_79
action_160 (68) = happyShift action_80
action_160 (69) = happyShift action_81
action_160 (70) = happyShift action_82
action_160 (71) = happyShift action_83
action_160 (72) = happyShift action_84
action_160 (73) = happyShift action_85
action_160 (74) = happyShift action_86
action_160 (75) = happyShift action_87
action_160 (76) = happyShift action_88
action_160 _ = happyReduce_30

action_161 (27) = happyShift action_162
action_161 _ = happyFail

action_162 (30) = happyShift action_15
action_162 (45) = happyShift action_16
action_162 (48) = happyShift action_17
action_162 (50) = happyShift action_18
action_162 (51) = happyShift action_19
action_162 (52) = happyShift action_20
action_162 (78) = happyShift action_21
action_162 (80) = happyShift action_22
action_162 (85) = happyShift action_8
action_162 (9) = happyGoto action_169
action_162 (10) = happyGoto action_13
action_162 (24) = happyGoto action_14
action_162 _ = happyFail

action_163 (40) = happyShift action_168
action_163 (43) = happyShift action_65
action_163 (53) = happyShift action_66
action_163 (54) = happyShift action_67
action_163 (56) = happyShift action_68
action_163 (57) = happyShift action_69
action_163 (58) = happyShift action_70
action_163 (59) = happyShift action_71
action_163 (60) = happyShift action_72
action_163 (61) = happyShift action_73
action_163 (62) = happyShift action_74
action_163 (63) = happyShift action_75
action_163 (64) = happyShift action_76
action_163 (65) = happyShift action_77
action_163 (66) = happyShift action_78
action_163 (67) = happyShift action_79
action_163 (68) = happyShift action_80
action_163 (69) = happyShift action_81
action_163 (70) = happyShift action_82
action_163 (71) = happyShift action_83
action_163 (72) = happyShift action_84
action_163 (73) = happyShift action_85
action_163 (74) = happyShift action_86
action_163 (75) = happyShift action_87
action_163 (76) = happyShift action_88
action_163 _ = happyFail

action_164 (28) = happyShift action_167
action_164 _ = happyFail

action_165 (28) = happyShift action_166
action_165 _ = happyFail

action_166 _ = happyReduce_14

action_167 _ = happyReduce_16

action_168 _ = happyReduce_78

action_169 (31) = happyShift action_170
action_169 _ = happyFail

action_170 (28) = happyShift action_171
action_170 (30) = happyShift action_15
action_170 (45) = happyShift action_16
action_170 (48) = happyShift action_17
action_170 (50) = happyShift action_18
action_170 (51) = happyShift action_19
action_170 (52) = happyShift action_20
action_170 (78) = happyShift action_21
action_170 (80) = happyShift action_22
action_170 (85) = happyShift action_8
action_170 (10) = happyGoto action_62
action_170 (24) = happyGoto action_14
action_170 _ = happyFail

action_171 _ = happyReduce_6

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
	(HappyAbsSyn25  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn11  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn24  happy_var_2) `HappyStk`
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
happyReduction_11 ((HappyAbsSyn19  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn23  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (StAssign happy_var_2 happy_var_4 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_12 = happyReduce 4 10 happyReduction_12
happyReduction_12 (_ `HappyStk`
	(HappyAbsSyn16  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn24  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (StFunctionCall happy_var_1 happy_var_3 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_13 = happySpecReduce_2  10 happyReduction_13
happyReduction_13 (HappyAbsSyn19  happy_var_2)
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
	(HappyAbsSyn19  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (StIf happy_var_2 happy_var_4 happy_var_6 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_15 = happyReduce 5 10 happyReduction_15
happyReduction_15 (_ `HappyStk`
	(HappyAbsSyn8  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn19  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (StIf happy_var_2 happy_var_4 empty <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_16 = happyReduce 7 10 happyReduction_16
happyReduction_16 (_ `HappyStk`
	(HappyAbsSyn8  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn19  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn24  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (StFor happy_var_2 happy_var_4 happy_var_6 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_17 = happyReduce 5 10 happyReduction_17
happyReduction_17 (_ `HappyStk`
	(HappyAbsSyn8  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn19  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (StWhile happy_var_2 happy_var_4 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_18 = happySpecReduce_2  10 happyReduction_18
happyReduction_18 (HappyAbsSyn24  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn10
		 (StRead happy_var_2 <$ happy_var_1
	)
happyReduction_18 _ _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_2  10 happyReduction_19
happyReduction_19 (HappyAbsSyn16  happy_var_2)
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
happyReduction_29 (HappyAbsSyn24  happy_var_2)
	(HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn15
		 (Dcl happy_var_1 happy_var_2 <$ happy_var_1
	)
happyReduction_29 _ _  = notHappyAtAll 

happyReduce_30 = happyReduce 4 15 happyReduction_30
happyReduction_30 ((HappyAbsSyn19  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn24  happy_var_2) `HappyStk`
	(HappyAbsSyn25  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn15
		 (DclInit happy_var_1 happy_var_2 happy_var_4 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_31 = happySpecReduce_0  16 happyReduction_31
happyReduction_31  =  HappyAbsSyn16
		 (empty
	)

happyReduce_32 = happySpecReduce_1  16 happyReduction_32
happyReduction_32 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_1
	)
happyReduction_32 _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_1  17 happyReduction_33
happyReduction_33 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn16
		 (singleton happy_var_1
	)
happyReduction_33 _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_3  17 happyReduction_34
happyReduction_34 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_1 |> happy_var_3
	)
happyReduction_34 _ _ _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_1  18 happyReduction_35
happyReduction_35 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn18
		 ([happy_var_1]
	)
happyReduction_35 _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_3  18 happyReduction_36
happyReduction_36 (HappyAbsSyn16  happy_var_3)
	_
	(HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn18
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_36 _ _ _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_1  19 happyReduction_37
happyReduction_37 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn19
		 (LitNumber happy_var_1 <$ happy_var_1
	)
happyReduction_37 _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_1  19 happyReduction_38
happyReduction_38 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn19
		 (LitBool happy_var_1 <$ happy_var_1
	)
happyReduction_38 _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_1  19 happyReduction_39
happyReduction_39 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn19
		 (LitString happy_var_1 <$ happy_var_1
	)
happyReduction_39 _  = notHappyAtAll 

happyReduce_40 = happySpecReduce_1  19 happyReduction_40
happyReduction_40 (HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn19
		 (VariableId happy_var_1 <$ happy_var_1
	)
happyReduction_40 _  = notHappyAtAll 

happyReduce_41 = happySpecReduce_3  19 happyReduction_41
happyReduction_41 _
	(HappyAbsSyn18  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn19
		 (LitMatrix happy_var_2 <$ happy_var_1
	)
happyReduction_41 _ _ _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_3  19 happyReduction_42
happyReduction_42 (HappyAbsSyn19  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (ExpBinary (OpSum <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_42 _ _ _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_3  19 happyReduction_43
happyReduction_43 (HappyAbsSyn19  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (ExpBinary (OpDiff <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_43 _ _ _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_3  19 happyReduction_44
happyReduction_44 (HappyAbsSyn19  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (ExpBinary (OpMul <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_44 _ _ _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_3  19 happyReduction_45
happyReduction_45 (HappyAbsSyn19  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (ExpBinary (OpDivEnt <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_45 _ _ _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_3  19 happyReduction_46
happyReduction_46 (HappyAbsSyn19  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (ExpBinary (OpModEnt <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_46 _ _ _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_3  19 happyReduction_47
happyReduction_47 (HappyAbsSyn19  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (ExpBinary (OpDiv <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_47 _ _ _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_3  19 happyReduction_48
happyReduction_48 (HappyAbsSyn19  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (ExpBinary (OpMod <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_48 _ _ _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_3  19 happyReduction_49
happyReduction_49 (HappyAbsSyn19  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (ExpBinary (OpCruzSum <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_49 _ _ _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_3  19 happyReduction_50
happyReduction_50 (HappyAbsSyn19  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (ExpBinary (OpCruzDiff <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_50 _ _ _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_3  19 happyReduction_51
happyReduction_51 (HappyAbsSyn19  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (ExpBinary (OpCruzMul <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_51 _ _ _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_3  19 happyReduction_52
happyReduction_52 (HappyAbsSyn19  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (ExpBinary (OpCruzDivEnt <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_52 _ _ _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_3  19 happyReduction_53
happyReduction_53 (HappyAbsSyn19  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (ExpBinary (OpCruzModEnt <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_53 _ _ _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_3  19 happyReduction_54
happyReduction_54 (HappyAbsSyn19  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (ExpBinary (OpCruzDiv <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_54 _ _ _  = notHappyAtAll 

happyReduce_55 = happySpecReduce_3  19 happyReduction_55
happyReduction_55 (HappyAbsSyn19  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (ExpBinary (OpCruzMod <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_55 _ _ _  = notHappyAtAll 

happyReduce_56 = happySpecReduce_3  19 happyReduction_56
happyReduction_56 (HappyAbsSyn19  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (ExpBinary (OpOr <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_56 _ _ _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_3  19 happyReduction_57
happyReduction_57 (HappyAbsSyn19  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (ExpBinary (OpAnd <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_57 _ _ _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_3  19 happyReduction_58
happyReduction_58 (HappyAbsSyn19  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (ExpBinary (OpEqual <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_58 _ _ _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_3  19 happyReduction_59
happyReduction_59 (HappyAbsSyn19  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (ExpBinary (OpUnequal <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_59 _ _ _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_3  19 happyReduction_60
happyReduction_60 (HappyAbsSyn19  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (ExpBinary (OpLess <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_60 _ _ _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_3  19 happyReduction_61
happyReduction_61 (HappyAbsSyn19  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (ExpBinary (OpLessEq <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_61 _ _ _  = notHappyAtAll 

happyReduce_62 = happySpecReduce_3  19 happyReduction_62
happyReduction_62 (HappyAbsSyn19  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (ExpBinary (OpGreat <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_62 _ _ _  = notHappyAtAll 

happyReduce_63 = happySpecReduce_3  19 happyReduction_63
happyReduction_63 (HappyAbsSyn19  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (ExpBinary (OpGreatEq <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_63 _ _ _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_2  19 happyReduction_64
happyReduction_64 (HappyTerminal happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (ExpUnary (OpTranspose <$ happy_var_2) happy_var_1 <$ happy_var_1
	)
happyReduction_64 _ _  = notHappyAtAll 

happyReduce_65 = happySpecReduce_2  19 happyReduction_65
happyReduction_65 (HappyAbsSyn19  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn19
		 (ExpUnary (OpNegative <$ happy_var_1) happy_var_2 <$ happy_var_1
	)
happyReduction_65 _ _  = notHappyAtAll 

happyReduce_66 = happyReduce 4 19 happyReduction_66
happyReduction_66 (_ `HappyStk`
	(HappyAbsSyn16  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn19  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn19
		 (Proy happy_var_1 happy_var_3 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_67 = happySpecReduce_2  19 happyReduction_67
happyReduction_67 (HappyAbsSyn19  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn19
		 (ExpUnary (OpNot <$ happy_var_1) happy_var_2 <$ happy_var_1
	)
happyReduction_67 _ _  = notHappyAtAll 

happyReduce_68 = happySpecReduce_3  19 happyReduction_68
happyReduction_68 _
	(HappyAbsSyn19  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn19
		 (lexInfo happy_var_2 <$ happy_var_1
	)
happyReduction_68 _ _ _  = notHappyAtAll 

happyReduce_69 = happySpecReduce_1  20 happyReduction_69
happyReduction_69 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn20
		 (unTkNumber `fmap` happy_var_1
	)
happyReduction_69 _  = notHappyAtAll 

happyReduce_70 = happySpecReduce_1  21 happyReduction_70
happyReduction_70 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn21
		 (unTkBoolean `fmap` happy_var_1
	)
happyReduction_70 _  = notHappyAtAll 

happyReduce_71 = happySpecReduce_1  21 happyReduction_71
happyReduction_71 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn21
		 (unTkBoolean `fmap` happy_var_1
	)
happyReduction_71 _  = notHappyAtAll 

happyReduce_72 = happySpecReduce_1  22 happyReduction_72
happyReduction_72 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn22
		 (unTkString `fmap` happy_var_1
	)
happyReduction_72 _  = notHappyAtAll 

happyReduce_73 = happySpecReduce_1  23 happyReduction_73
happyReduction_73 (HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn23
		 (VariableAccess happy_var_1 <$ happy_var_1
	)
happyReduction_73 _  = notHappyAtAll 

happyReduce_74 = happyReduce 4 23 happyReduction_74
happyReduction_74 (_ `HappyStk`
	(HappyAbsSyn16  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn24  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn23
		 (MatrixAccess happy_var_1 happy_var_3 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_75 = happySpecReduce_1  24 happyReduction_75
happyReduction_75 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn24
		 (unTkId `fmap` happy_var_1
	)
happyReduction_75 _  = notHappyAtAll 

happyReduce_76 = happySpecReduce_1  25 happyReduction_76
happyReduction_76 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn25
		 (Bool <$ happy_var_1
	)
happyReduction_76 _  = notHappyAtAll 

happyReduce_77 = happySpecReduce_1  25 happyReduction_77
happyReduction_77 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn25
		 (Double <$ happy_var_1
	)
happyReduction_77 _  = notHappyAtAll 

happyReduce_78 = happyReduce 6 25 happyReduction_78
happyReduction_78 (_ `HappyStk`
	(HappyAbsSyn19  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn19  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn25
		 (Matrix happy_var_3 happy_var_5 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_79 = happyReduce 4 25 happyReduction_79
happyReduction_79 (_ `HappyStk`
	(HappyAbsSyn19  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn25
		 (Row happy_var_3 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_80 = happyReduce 4 25 happyReduction_80
happyReduction_80 (_ `HappyStk`
	(HappyAbsSyn19  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn25
		 (Col happy_var_3 <$ happy_var_1
	) `HappyStk` happyRest

happyNewToken action sts stk
	= lexWrap(\tk -> 
	let cont i = action i i tk (HappyState action) sts stk in
	case tk of {
	Lex TkEOF _ -> action 86 86 tk (HappyState action) sts stk;
	Lex TkProgram      _ -> cont 26;
	Lex TkBegin        _ -> cont 27;
	Lex TkEnd          _ -> cont 28;
	Lex TkFunction     _ -> cont 29;
	Lex TkReturn       _ -> cont 30;
	Lex TkSemicolon    _ -> cont 31;
	Lex TkComma        _ -> cont 32;
	Lex TkDoublePoint  _ -> cont 33;
	Lex TkBooleanType  _ -> cont 34;
	Lex TkNumberType   _ -> cont 35;
	Lex TkMatrixType   _ -> cont 36;
	Lex TkRowType      _ -> cont 37;
	Lex TkColType      _ -> cont 38;
	Lex TkLParen       _ -> cont 39;
	Lex TkRParen       _ -> cont 40;
	Lex TkLLlaves      _ -> cont 41;
	Lex TkRLlaves      _ -> cont 42;
	Lex TkLCorche      _ -> cont 43;
	Lex TkRCorche      _ -> cont 44;
	Lex TkIf           _ -> cont 45;
	Lex TkElse         _ -> cont 46;
	Lex TkThen         _ -> cont 47;
	Lex TkFor          _ -> cont 48;
	Lex TkDo           _ -> cont 49;
	Lex TkWhile        _ -> cont 50;
	Lex TkPrint        _ -> cont 51;
	Lex TkRead         _ -> cont 52;
	Lex TkAnd          _ -> cont 53;
	Lex TkOr           _ -> cont 54;
	Lex TkNot          _ -> cont 55;
	Lex TkEqual        _ -> cont 56;
	Lex TkUnequal      _ -> cont 57;
	Lex TkLessEq       _ -> cont 58;
	Lex TkLess         _ -> cont 59;
	Lex TkGreatEq      _ -> cont 60;
	Lex TkGreat        _ -> cont 61;
	Lex TkSum          _ -> cont 62;
	Lex TkDiff         _ -> cont 63;
	Lex TkMul          _ -> cont 64;
	Lex TkDivEnt       _ -> cont 65;
	Lex TkModEnt       _ -> cont 66;
	Lex TkDiv          _ -> cont 67;
	Lex TkMod          _ -> cont 68;
	Lex TkTrans        _ -> cont 69;
	Lex TkCruzSum      _ -> cont 70;
	Lex TkCruzDiff     _ -> cont 71;
	Lex TkCruzMul      _ -> cont 72;
	Lex TkCruzDivEnt   _ -> cont 73;
	Lex TkCruzModEnt   _ -> cont 74;
	Lex TkCruzDiv      _ -> cont 75;
	Lex TkCruzMod      _ -> cont 76;
	Lex TkAssign       _ -> cont 77;
	Lex TkUse          _ -> cont 78;
	Lex TkIn           _ -> cont 79;
	Lex TkSet          _ -> cont 80;
	Lex (TkNumber _)   _ -> cont 81;
	Lex (TkBoolean _)  _ -> cont 82;
	Lex (TkBoolean _)  _ -> cont 83;
	Lex (TkString _)   _ -> cont 84;
	Lex (TkId     _)   _ -> cont 85;
	_ -> happyError' tk
	})

happyError_ 86 tk = happyError' tk
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
    StPrintList exps -> fmap (\exp -> StPrint exp <$ stL) exps
    _ -> singleton stL

lexWrap :: (Lexeme Token -> Alex a) -> Alex a
lexWrap = (alexMonadScanTokens >>=)

parseError :: Lexeme Token -> Alex a
parseError (Lex t p) = fail $ "Error de Sintaxis, Token: " ++ 
                            show t ++ " " ++ show p ++ "\n"

parseProgram :: String ->  (Seq LexicalError, Program)
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

{-# LINE 13 "templates/GenericTemplate.hs" #-}

{-# LINE 45 "templates/GenericTemplate.hs" #-}








{-# LINE 66 "templates/GenericTemplate.hs" #-}

{-# LINE 76 "templates/GenericTemplate.hs" #-}

{-# LINE 85 "templates/GenericTemplate.hs" #-}

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

{-# LINE 154 "templates/GenericTemplate.hs" #-}

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
     let i = (case x of { HappyErrorToken (i) -> i }) in
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
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n - ((1) :: Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n - ((1)::Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction

{-# LINE 255 "templates/GenericTemplate.hs" #-}
happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery ((1) is the error token)

-- parse error if we are in recovery and we fail again
happyFail (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
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

{-# LINE 321 "templates/GenericTemplate.hs" #-}
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
