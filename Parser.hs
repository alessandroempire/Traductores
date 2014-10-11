{-# OPTIONS_GHC -w #-}
module Parser
    ( parseProgram
    ) 
    where

import          Control.Monad (unless)
import          Data.Functor ((<$>),(<$))
import          Data.Maybe (fromJust, isJust)
import          Data.Sequence hiding (length)
import          Data.Foldable (concatMap)
import          Prelude hiding (concatMap, foldr, zip)

import          Lexer

-- parser produced by Happy Version 1.18.10

data HappyAbsSyn 
	= HappyTerminal (Lexeme Token)
	| HappyErrorToken Int
	| HappyAbsSyn4 (Program)
	| HappyAbsSyn5 (StatementSeq)
	| HappyAbsSyn6 (Lexeme Statement)
	| HappyAbsSyn7 (DeclarationSeq)
	| HappyAbsSyn11 (Lexeme Declaration)
	| HappyAbsSyn12 (Seq (Lexeme Expression))
	| HappyAbsSyn14 ([Seq (Lexeme Expression)])
	| HappyAbsSyn15 (Lexeme Double)
	| HappyAbsSyn16 (Lexeme Bool)
	| HappyAbsSyn17 (Lexeme String)
	| HappyAbsSyn18 (Lexeme Access)
	| HappyAbsSyn19 (Lexeme Identifier)
	| HappyAbsSyn20 (Lexeme TypeId)
	| HappyAbsSyn21 (Lexeme Expression)

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
 action_157 :: () => Int -> ({-HappyReduction (Alex) = -}
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
 happyReduce_73 :: () => ({-HappyReduction (Alex) = -}
	   Int 
	-> (Lexeme Token)
	-> HappyState (Lexeme Token) (HappyStk HappyAbsSyn -> (Alex) HappyAbsSyn)
	-> [HappyState (Lexeme Token) (HappyStk HappyAbsSyn -> (Alex) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> (Alex) HappyAbsSyn)

action_0 (22) = happyShift action_15
action_0 (26) = happyShift action_5
action_0 (41) = happyShift action_6
action_0 (44) = happyShift action_7
action_0 (46) = happyShift action_8
action_0 (47) = happyShift action_9
action_0 (48) = happyShift action_10
action_0 (74) = happyShift action_11
action_0 (76) = happyShift action_12
action_0 (81) = happyShift action_13
action_0 (4) = happyGoto action_14
action_0 (5) = happyGoto action_2
action_0 (6) = happyGoto action_3
action_0 (19) = happyGoto action_4
action_0 _ = happyFail

action_1 (26) = happyShift action_5
action_1 (41) = happyShift action_6
action_1 (44) = happyShift action_7
action_1 (46) = happyShift action_8
action_1 (47) = happyShift action_9
action_1 (48) = happyShift action_10
action_1 (74) = happyShift action_11
action_1 (76) = happyShift action_12
action_1 (81) = happyShift action_13
action_1 (5) = happyGoto action_2
action_1 (6) = happyGoto action_3
action_1 (19) = happyGoto action_4
action_1 _ = happyFail

action_2 (27) = happyShift action_48
action_2 _ = happyFail

action_3 _ = happyReduce_3

action_4 (35) = happyShift action_47
action_4 _ = happyFail

action_5 (35) = happyShift action_35
action_5 (37) = happyShift action_36
action_5 (51) = happyShift action_37
action_5 (59) = happyShift action_38
action_5 (77) = happyShift action_39
action_5 (78) = happyShift action_40
action_5 (79) = happyShift action_41
action_5 (80) = happyShift action_42
action_5 (81) = happyShift action_13
action_5 (15) = happyGoto action_30
action_5 (16) = happyGoto action_31
action_5 (17) = happyGoto action_32
action_5 (18) = happyGoto action_33
action_5 (19) = happyGoto action_18
action_5 (21) = happyGoto action_46
action_5 _ = happyFail

action_6 (35) = happyShift action_35
action_6 (37) = happyShift action_36
action_6 (51) = happyShift action_37
action_6 (59) = happyShift action_38
action_6 (77) = happyShift action_39
action_6 (78) = happyShift action_40
action_6 (79) = happyShift action_41
action_6 (80) = happyShift action_42
action_6 (81) = happyShift action_13
action_6 (15) = happyGoto action_30
action_6 (16) = happyGoto action_31
action_6 (17) = happyGoto action_32
action_6 (18) = happyGoto action_33
action_6 (19) = happyGoto action_18
action_6 (21) = happyGoto action_45
action_6 _ = happyFail

action_7 (81) = happyShift action_13
action_7 (19) = happyGoto action_44
action_7 _ = happyFail

action_8 (35) = happyShift action_35
action_8 (37) = happyShift action_36
action_8 (51) = happyShift action_37
action_8 (59) = happyShift action_38
action_8 (77) = happyShift action_39
action_8 (78) = happyShift action_40
action_8 (79) = happyShift action_41
action_8 (80) = happyShift action_42
action_8 (81) = happyShift action_13
action_8 (15) = happyGoto action_30
action_8 (16) = happyGoto action_31
action_8 (17) = happyGoto action_32
action_8 (18) = happyGoto action_33
action_8 (19) = happyGoto action_18
action_8 (21) = happyGoto action_43
action_8 _ = happyFail

action_9 (35) = happyShift action_35
action_9 (37) = happyShift action_36
action_9 (51) = happyShift action_37
action_9 (59) = happyShift action_38
action_9 (77) = happyShift action_39
action_9 (78) = happyShift action_40
action_9 (79) = happyShift action_41
action_9 (80) = happyShift action_42
action_9 (81) = happyShift action_13
action_9 (13) = happyGoto action_29
action_9 (15) = happyGoto action_30
action_9 (16) = happyGoto action_31
action_9 (17) = happyGoto action_32
action_9 (18) = happyGoto action_33
action_9 (19) = happyGoto action_18
action_9 (21) = happyGoto action_34
action_9 _ = happyFail

action_10 (81) = happyShift action_13
action_10 (18) = happyGoto action_28
action_10 (19) = happyGoto action_18
action_10 _ = happyFail

action_11 (30) = happyShift action_23
action_11 (31) = happyShift action_24
action_11 (32) = happyShift action_25
action_11 (33) = happyShift action_26
action_11 (34) = happyShift action_27
action_11 (7) = happyGoto action_19
action_11 (8) = happyGoto action_20
action_11 (11) = happyGoto action_21
action_11 (20) = happyGoto action_22
action_11 _ = happyReduce_15

action_12 (81) = happyShift action_13
action_12 (18) = happyGoto action_17
action_12 (19) = happyGoto action_18
action_12 _ = happyFail

action_13 _ = happyReduce_36

action_14 (82) = happyAccept
action_14 _ = happyFail

action_15 (26) = happyShift action_5
action_15 (41) = happyShift action_6
action_15 (44) = happyShift action_7
action_15 (46) = happyShift action_8
action_15 (47) = happyShift action_9
action_15 (48) = happyShift action_10
action_15 (74) = happyShift action_11
action_15 (76) = happyShift action_12
action_15 (81) = happyShift action_13
action_15 (5) = happyGoto action_16
action_15 (6) = happyGoto action_3
action_15 (19) = happyGoto action_4
action_15 _ = happyFail

action_16 (27) = happyShift action_93
action_16 _ = happyFail

action_17 (73) = happyShift action_92
action_17 _ = happyFail

action_18 _ = happyReduce_35

action_19 (75) = happyShift action_91
action_19 _ = happyFail

action_20 (27) = happyShift action_90
action_20 _ = happyFail

action_21 _ = happyReduce_17

action_22 (81) = happyShift action_13
action_22 (19) = happyGoto action_89
action_22 _ = happyFail

action_23 _ = happyReduce_37

action_24 _ = happyReduce_38

action_25 (35) = happyShift action_88
action_25 _ = happyFail

action_26 (35) = happyShift action_87
action_26 _ = happyFail

action_27 (35) = happyShift action_86
action_27 _ = happyFail

action_28 _ = happyReduce_12

action_29 (28) = happyShift action_85
action_29 _ = happyReduce_13

action_30 _ = happyReduce_42

action_31 _ = happyReduce_43

action_32 _ = happyReduce_44

action_33 _ = happyReduce_45

action_34 (39) = happyShift action_53
action_34 (49) = happyShift action_54
action_34 (50) = happyShift action_55
action_34 (52) = happyShift action_56
action_34 (53) = happyShift action_57
action_34 (54) = happyShift action_58
action_34 (55) = happyShift action_59
action_34 (56) = happyShift action_60
action_34 (57) = happyShift action_61
action_34 (58) = happyShift action_62
action_34 (59) = happyShift action_63
action_34 (60) = happyShift action_64
action_34 (61) = happyShift action_65
action_34 (62) = happyShift action_66
action_34 (63) = happyShift action_67
action_34 (64) = happyShift action_68
action_34 (65) = happyShift action_69
action_34 (66) = happyShift action_70
action_34 (67) = happyShift action_71
action_34 (68) = happyShift action_72
action_34 (69) = happyShift action_73
action_34 (70) = happyShift action_74
action_34 (71) = happyShift action_75
action_34 (72) = happyShift action_76
action_34 _ = happyReduce_27

action_35 (35) = happyShift action_35
action_35 (37) = happyShift action_36
action_35 (51) = happyShift action_37
action_35 (59) = happyShift action_38
action_35 (77) = happyShift action_39
action_35 (78) = happyShift action_40
action_35 (79) = happyShift action_41
action_35 (80) = happyShift action_42
action_35 (81) = happyShift action_13
action_35 (15) = happyGoto action_30
action_35 (16) = happyGoto action_31
action_35 (17) = happyGoto action_32
action_35 (18) = happyGoto action_33
action_35 (19) = happyGoto action_18
action_35 (21) = happyGoto action_84
action_35 _ = happyFail

action_36 (35) = happyShift action_35
action_36 (37) = happyShift action_36
action_36 (51) = happyShift action_37
action_36 (59) = happyShift action_38
action_36 (77) = happyShift action_39
action_36 (78) = happyShift action_40
action_36 (79) = happyShift action_41
action_36 (80) = happyShift action_42
action_36 (81) = happyShift action_13
action_36 (13) = happyGoto action_82
action_36 (14) = happyGoto action_83
action_36 (15) = happyGoto action_30
action_36 (16) = happyGoto action_31
action_36 (17) = happyGoto action_32
action_36 (18) = happyGoto action_33
action_36 (19) = happyGoto action_18
action_36 (21) = happyGoto action_34
action_36 _ = happyFail

action_37 (35) = happyShift action_35
action_37 (37) = happyShift action_36
action_37 (51) = happyShift action_37
action_37 (59) = happyShift action_38
action_37 (77) = happyShift action_39
action_37 (78) = happyShift action_40
action_37 (79) = happyShift action_41
action_37 (80) = happyShift action_42
action_37 (81) = happyShift action_13
action_37 (15) = happyGoto action_30
action_37 (16) = happyGoto action_31
action_37 (17) = happyGoto action_32
action_37 (18) = happyGoto action_33
action_37 (19) = happyGoto action_18
action_37 (21) = happyGoto action_81
action_37 _ = happyFail

action_38 (35) = happyShift action_35
action_38 (37) = happyShift action_36
action_38 (51) = happyShift action_37
action_38 (59) = happyShift action_38
action_38 (77) = happyShift action_39
action_38 (78) = happyShift action_40
action_38 (79) = happyShift action_41
action_38 (80) = happyShift action_42
action_38 (81) = happyShift action_13
action_38 (15) = happyGoto action_30
action_38 (16) = happyGoto action_31
action_38 (17) = happyGoto action_32
action_38 (18) = happyGoto action_33
action_38 (19) = happyGoto action_18
action_38 (21) = happyGoto action_80
action_38 _ = happyFail

action_39 _ = happyReduce_31

action_40 _ = happyReduce_32

action_41 _ = happyReduce_33

action_42 _ = happyReduce_34

action_43 (39) = happyShift action_53
action_43 (45) = happyShift action_79
action_43 (49) = happyShift action_54
action_43 (50) = happyShift action_55
action_43 (52) = happyShift action_56
action_43 (53) = happyShift action_57
action_43 (54) = happyShift action_58
action_43 (55) = happyShift action_59
action_43 (56) = happyShift action_60
action_43 (57) = happyShift action_61
action_43 (58) = happyShift action_62
action_43 (59) = happyShift action_63
action_43 (60) = happyShift action_64
action_43 (61) = happyShift action_65
action_43 (62) = happyShift action_66
action_43 (63) = happyShift action_67
action_43 (64) = happyShift action_68
action_43 (65) = happyShift action_69
action_43 (66) = happyShift action_70
action_43 (67) = happyShift action_71
action_43 (68) = happyShift action_72
action_43 (69) = happyShift action_73
action_43 (70) = happyShift action_74
action_43 (71) = happyShift action_75
action_43 (72) = happyShift action_76
action_43 _ = happyFail

action_44 (75) = happyShift action_78
action_44 _ = happyFail

action_45 (39) = happyShift action_53
action_45 (43) = happyShift action_77
action_45 (49) = happyShift action_54
action_45 (50) = happyShift action_55
action_45 (52) = happyShift action_56
action_45 (53) = happyShift action_57
action_45 (54) = happyShift action_58
action_45 (55) = happyShift action_59
action_45 (56) = happyShift action_60
action_45 (57) = happyShift action_61
action_45 (58) = happyShift action_62
action_45 (59) = happyShift action_63
action_45 (60) = happyShift action_64
action_45 (61) = happyShift action_65
action_45 (62) = happyShift action_66
action_45 (63) = happyShift action_67
action_45 (64) = happyShift action_68
action_45 (65) = happyShift action_69
action_45 (66) = happyShift action_70
action_45 (67) = happyShift action_71
action_45 (68) = happyShift action_72
action_45 (69) = happyShift action_73
action_45 (70) = happyShift action_74
action_45 (71) = happyShift action_75
action_45 (72) = happyShift action_76
action_45 _ = happyFail

action_46 (39) = happyShift action_53
action_46 (49) = happyShift action_54
action_46 (50) = happyShift action_55
action_46 (52) = happyShift action_56
action_46 (53) = happyShift action_57
action_46 (54) = happyShift action_58
action_46 (55) = happyShift action_59
action_46 (56) = happyShift action_60
action_46 (57) = happyShift action_61
action_46 (58) = happyShift action_62
action_46 (59) = happyShift action_63
action_46 (60) = happyShift action_64
action_46 (61) = happyShift action_65
action_46 (62) = happyShift action_66
action_46 (63) = happyShift action_67
action_46 (64) = happyShift action_68
action_46 (65) = happyShift action_69
action_46 (66) = happyShift action_70
action_46 (67) = happyShift action_71
action_46 (68) = happyShift action_72
action_46 (69) = happyShift action_73
action_46 (70) = happyShift action_74
action_46 (71) = happyShift action_75
action_46 (72) = happyShift action_76
action_46 _ = happyReduce_7

action_47 (35) = happyShift action_35
action_47 (37) = happyShift action_36
action_47 (51) = happyShift action_37
action_47 (59) = happyShift action_38
action_47 (77) = happyShift action_39
action_47 (78) = happyShift action_40
action_47 (79) = happyShift action_41
action_47 (80) = happyShift action_42
action_47 (81) = happyShift action_13
action_47 (12) = happyGoto action_51
action_47 (13) = happyGoto action_52
action_47 (15) = happyGoto action_30
action_47 (16) = happyGoto action_31
action_47 (17) = happyGoto action_32
action_47 (18) = happyGoto action_33
action_47 (19) = happyGoto action_18
action_47 (21) = happyGoto action_34
action_47 _ = happyReduce_25

action_48 (22) = happyShift action_50
action_48 (26) = happyShift action_5
action_48 (41) = happyShift action_6
action_48 (44) = happyShift action_7
action_48 (46) = happyShift action_8
action_48 (47) = happyShift action_9
action_48 (48) = happyShift action_10
action_48 (74) = happyShift action_11
action_48 (76) = happyShift action_12
action_48 (81) = happyShift action_13
action_48 (6) = happyGoto action_49
action_48 (19) = happyGoto action_4
action_48 _ = happyFail

action_49 _ = happyReduce_4

action_50 (26) = happyShift action_5
action_50 (41) = happyShift action_6
action_50 (44) = happyShift action_7
action_50 (46) = happyShift action_8
action_50 (47) = happyShift action_9
action_50 (48) = happyShift action_10
action_50 (74) = happyShift action_11
action_50 (76) = happyShift action_12
action_50 (81) = happyShift action_13
action_50 (5) = happyGoto action_133
action_50 (6) = happyGoto action_3
action_50 (19) = happyGoto action_4
action_50 _ = happyFail

action_51 (36) = happyShift action_132
action_51 _ = happyFail

action_52 (28) = happyShift action_85
action_52 _ = happyReduce_26

action_53 (35) = happyShift action_35
action_53 (37) = happyShift action_36
action_53 (51) = happyShift action_37
action_53 (59) = happyShift action_38
action_53 (77) = happyShift action_39
action_53 (78) = happyShift action_40
action_53 (79) = happyShift action_41
action_53 (80) = happyShift action_42
action_53 (81) = happyShift action_13
action_53 (13) = happyGoto action_131
action_53 (15) = happyGoto action_30
action_53 (16) = happyGoto action_31
action_53 (17) = happyGoto action_32
action_53 (18) = happyGoto action_33
action_53 (19) = happyGoto action_18
action_53 (21) = happyGoto action_34
action_53 _ = happyFail

action_54 (35) = happyShift action_35
action_54 (37) = happyShift action_36
action_54 (51) = happyShift action_37
action_54 (59) = happyShift action_38
action_54 (77) = happyShift action_39
action_54 (78) = happyShift action_40
action_54 (79) = happyShift action_41
action_54 (80) = happyShift action_42
action_54 (81) = happyShift action_13
action_54 (15) = happyGoto action_30
action_54 (16) = happyGoto action_31
action_54 (17) = happyGoto action_32
action_54 (18) = happyGoto action_33
action_54 (19) = happyGoto action_18
action_54 (21) = happyGoto action_130
action_54 _ = happyFail

action_55 (35) = happyShift action_35
action_55 (37) = happyShift action_36
action_55 (51) = happyShift action_37
action_55 (59) = happyShift action_38
action_55 (77) = happyShift action_39
action_55 (78) = happyShift action_40
action_55 (79) = happyShift action_41
action_55 (80) = happyShift action_42
action_55 (81) = happyShift action_13
action_55 (15) = happyGoto action_30
action_55 (16) = happyGoto action_31
action_55 (17) = happyGoto action_32
action_55 (18) = happyGoto action_33
action_55 (19) = happyGoto action_18
action_55 (21) = happyGoto action_129
action_55 _ = happyFail

action_56 (35) = happyShift action_35
action_56 (37) = happyShift action_36
action_56 (51) = happyShift action_37
action_56 (59) = happyShift action_38
action_56 (77) = happyShift action_39
action_56 (78) = happyShift action_40
action_56 (79) = happyShift action_41
action_56 (80) = happyShift action_42
action_56 (81) = happyShift action_13
action_56 (15) = happyGoto action_30
action_56 (16) = happyGoto action_31
action_56 (17) = happyGoto action_32
action_56 (18) = happyGoto action_33
action_56 (19) = happyGoto action_18
action_56 (21) = happyGoto action_128
action_56 _ = happyFail

action_57 (35) = happyShift action_35
action_57 (37) = happyShift action_36
action_57 (51) = happyShift action_37
action_57 (59) = happyShift action_38
action_57 (77) = happyShift action_39
action_57 (78) = happyShift action_40
action_57 (79) = happyShift action_41
action_57 (80) = happyShift action_42
action_57 (81) = happyShift action_13
action_57 (15) = happyGoto action_30
action_57 (16) = happyGoto action_31
action_57 (17) = happyGoto action_32
action_57 (18) = happyGoto action_33
action_57 (19) = happyGoto action_18
action_57 (21) = happyGoto action_127
action_57 _ = happyFail

action_58 (35) = happyShift action_35
action_58 (37) = happyShift action_36
action_58 (51) = happyShift action_37
action_58 (59) = happyShift action_38
action_58 (77) = happyShift action_39
action_58 (78) = happyShift action_40
action_58 (79) = happyShift action_41
action_58 (80) = happyShift action_42
action_58 (81) = happyShift action_13
action_58 (15) = happyGoto action_30
action_58 (16) = happyGoto action_31
action_58 (17) = happyGoto action_32
action_58 (18) = happyGoto action_33
action_58 (19) = happyGoto action_18
action_58 (21) = happyGoto action_126
action_58 _ = happyFail

action_59 (35) = happyShift action_35
action_59 (37) = happyShift action_36
action_59 (51) = happyShift action_37
action_59 (59) = happyShift action_38
action_59 (77) = happyShift action_39
action_59 (78) = happyShift action_40
action_59 (79) = happyShift action_41
action_59 (80) = happyShift action_42
action_59 (81) = happyShift action_13
action_59 (15) = happyGoto action_30
action_59 (16) = happyGoto action_31
action_59 (17) = happyGoto action_32
action_59 (18) = happyGoto action_33
action_59 (19) = happyGoto action_18
action_59 (21) = happyGoto action_125
action_59 _ = happyFail

action_60 (35) = happyShift action_35
action_60 (37) = happyShift action_36
action_60 (51) = happyShift action_37
action_60 (59) = happyShift action_38
action_60 (77) = happyShift action_39
action_60 (78) = happyShift action_40
action_60 (79) = happyShift action_41
action_60 (80) = happyShift action_42
action_60 (81) = happyShift action_13
action_60 (15) = happyGoto action_30
action_60 (16) = happyGoto action_31
action_60 (17) = happyGoto action_32
action_60 (18) = happyGoto action_33
action_60 (19) = happyGoto action_18
action_60 (21) = happyGoto action_124
action_60 _ = happyFail

action_61 (35) = happyShift action_35
action_61 (37) = happyShift action_36
action_61 (51) = happyShift action_37
action_61 (59) = happyShift action_38
action_61 (77) = happyShift action_39
action_61 (78) = happyShift action_40
action_61 (79) = happyShift action_41
action_61 (80) = happyShift action_42
action_61 (81) = happyShift action_13
action_61 (15) = happyGoto action_30
action_61 (16) = happyGoto action_31
action_61 (17) = happyGoto action_32
action_61 (18) = happyGoto action_33
action_61 (19) = happyGoto action_18
action_61 (21) = happyGoto action_123
action_61 _ = happyFail

action_62 (35) = happyShift action_35
action_62 (37) = happyShift action_36
action_62 (51) = happyShift action_37
action_62 (59) = happyShift action_38
action_62 (77) = happyShift action_39
action_62 (78) = happyShift action_40
action_62 (79) = happyShift action_41
action_62 (80) = happyShift action_42
action_62 (81) = happyShift action_13
action_62 (15) = happyGoto action_30
action_62 (16) = happyGoto action_31
action_62 (17) = happyGoto action_32
action_62 (18) = happyGoto action_33
action_62 (19) = happyGoto action_18
action_62 (21) = happyGoto action_122
action_62 _ = happyFail

action_63 (35) = happyShift action_35
action_63 (37) = happyShift action_36
action_63 (51) = happyShift action_37
action_63 (59) = happyShift action_38
action_63 (77) = happyShift action_39
action_63 (78) = happyShift action_40
action_63 (79) = happyShift action_41
action_63 (80) = happyShift action_42
action_63 (81) = happyShift action_13
action_63 (15) = happyGoto action_30
action_63 (16) = happyGoto action_31
action_63 (17) = happyGoto action_32
action_63 (18) = happyGoto action_33
action_63 (19) = happyGoto action_18
action_63 (21) = happyGoto action_121
action_63 _ = happyFail

action_64 (35) = happyShift action_35
action_64 (37) = happyShift action_36
action_64 (51) = happyShift action_37
action_64 (59) = happyShift action_38
action_64 (77) = happyShift action_39
action_64 (78) = happyShift action_40
action_64 (79) = happyShift action_41
action_64 (80) = happyShift action_42
action_64 (81) = happyShift action_13
action_64 (15) = happyGoto action_30
action_64 (16) = happyGoto action_31
action_64 (17) = happyGoto action_32
action_64 (18) = happyGoto action_33
action_64 (19) = happyGoto action_18
action_64 (21) = happyGoto action_120
action_64 _ = happyFail

action_65 (35) = happyShift action_35
action_65 (37) = happyShift action_36
action_65 (51) = happyShift action_37
action_65 (59) = happyShift action_38
action_65 (77) = happyShift action_39
action_65 (78) = happyShift action_40
action_65 (79) = happyShift action_41
action_65 (80) = happyShift action_42
action_65 (81) = happyShift action_13
action_65 (15) = happyGoto action_30
action_65 (16) = happyGoto action_31
action_65 (17) = happyGoto action_32
action_65 (18) = happyGoto action_33
action_65 (19) = happyGoto action_18
action_65 (21) = happyGoto action_119
action_65 _ = happyFail

action_66 (35) = happyShift action_35
action_66 (37) = happyShift action_36
action_66 (51) = happyShift action_37
action_66 (59) = happyShift action_38
action_66 (77) = happyShift action_39
action_66 (78) = happyShift action_40
action_66 (79) = happyShift action_41
action_66 (80) = happyShift action_42
action_66 (81) = happyShift action_13
action_66 (15) = happyGoto action_30
action_66 (16) = happyGoto action_31
action_66 (17) = happyGoto action_32
action_66 (18) = happyGoto action_33
action_66 (19) = happyGoto action_18
action_66 (21) = happyGoto action_118
action_66 _ = happyFail

action_67 (35) = happyShift action_35
action_67 (37) = happyShift action_36
action_67 (51) = happyShift action_37
action_67 (59) = happyShift action_38
action_67 (77) = happyShift action_39
action_67 (78) = happyShift action_40
action_67 (79) = happyShift action_41
action_67 (80) = happyShift action_42
action_67 (81) = happyShift action_13
action_67 (15) = happyGoto action_30
action_67 (16) = happyGoto action_31
action_67 (17) = happyGoto action_32
action_67 (18) = happyGoto action_33
action_67 (19) = happyGoto action_18
action_67 (21) = happyGoto action_117
action_67 _ = happyFail

action_68 (35) = happyShift action_35
action_68 (37) = happyShift action_36
action_68 (51) = happyShift action_37
action_68 (59) = happyShift action_38
action_68 (77) = happyShift action_39
action_68 (78) = happyShift action_40
action_68 (79) = happyShift action_41
action_68 (80) = happyShift action_42
action_68 (81) = happyShift action_13
action_68 (15) = happyGoto action_30
action_68 (16) = happyGoto action_31
action_68 (17) = happyGoto action_32
action_68 (18) = happyGoto action_33
action_68 (19) = happyGoto action_18
action_68 (21) = happyGoto action_116
action_68 _ = happyFail

action_69 _ = happyReduce_69

action_70 (35) = happyShift action_35
action_70 (37) = happyShift action_36
action_70 (51) = happyShift action_37
action_70 (59) = happyShift action_38
action_70 (77) = happyShift action_39
action_70 (78) = happyShift action_40
action_70 (79) = happyShift action_41
action_70 (80) = happyShift action_42
action_70 (81) = happyShift action_13
action_70 (15) = happyGoto action_30
action_70 (16) = happyGoto action_31
action_70 (17) = happyGoto action_32
action_70 (18) = happyGoto action_33
action_70 (19) = happyGoto action_18
action_70 (21) = happyGoto action_115
action_70 _ = happyFail

action_71 (35) = happyShift action_35
action_71 (37) = happyShift action_36
action_71 (51) = happyShift action_37
action_71 (59) = happyShift action_38
action_71 (77) = happyShift action_39
action_71 (78) = happyShift action_40
action_71 (79) = happyShift action_41
action_71 (80) = happyShift action_42
action_71 (81) = happyShift action_13
action_71 (15) = happyGoto action_30
action_71 (16) = happyGoto action_31
action_71 (17) = happyGoto action_32
action_71 (18) = happyGoto action_33
action_71 (19) = happyGoto action_18
action_71 (21) = happyGoto action_114
action_71 _ = happyFail

action_72 (35) = happyShift action_35
action_72 (37) = happyShift action_36
action_72 (51) = happyShift action_37
action_72 (59) = happyShift action_38
action_72 (77) = happyShift action_39
action_72 (78) = happyShift action_40
action_72 (79) = happyShift action_41
action_72 (80) = happyShift action_42
action_72 (81) = happyShift action_13
action_72 (15) = happyGoto action_30
action_72 (16) = happyGoto action_31
action_72 (17) = happyGoto action_32
action_72 (18) = happyGoto action_33
action_72 (19) = happyGoto action_18
action_72 (21) = happyGoto action_113
action_72 _ = happyFail

action_73 (35) = happyShift action_35
action_73 (37) = happyShift action_36
action_73 (51) = happyShift action_37
action_73 (59) = happyShift action_38
action_73 (77) = happyShift action_39
action_73 (78) = happyShift action_40
action_73 (79) = happyShift action_41
action_73 (80) = happyShift action_42
action_73 (81) = happyShift action_13
action_73 (15) = happyGoto action_30
action_73 (16) = happyGoto action_31
action_73 (17) = happyGoto action_32
action_73 (18) = happyGoto action_33
action_73 (19) = happyGoto action_18
action_73 (21) = happyGoto action_112
action_73 _ = happyFail

action_74 (35) = happyShift action_35
action_74 (37) = happyShift action_36
action_74 (51) = happyShift action_37
action_74 (59) = happyShift action_38
action_74 (77) = happyShift action_39
action_74 (78) = happyShift action_40
action_74 (79) = happyShift action_41
action_74 (80) = happyShift action_42
action_74 (81) = happyShift action_13
action_74 (15) = happyGoto action_30
action_74 (16) = happyGoto action_31
action_74 (17) = happyGoto action_32
action_74 (18) = happyGoto action_33
action_74 (19) = happyGoto action_18
action_74 (21) = happyGoto action_111
action_74 _ = happyFail

action_75 (35) = happyShift action_35
action_75 (37) = happyShift action_36
action_75 (51) = happyShift action_37
action_75 (59) = happyShift action_38
action_75 (77) = happyShift action_39
action_75 (78) = happyShift action_40
action_75 (79) = happyShift action_41
action_75 (80) = happyShift action_42
action_75 (81) = happyShift action_13
action_75 (15) = happyGoto action_30
action_75 (16) = happyGoto action_31
action_75 (17) = happyGoto action_32
action_75 (18) = happyGoto action_33
action_75 (19) = happyGoto action_18
action_75 (21) = happyGoto action_110
action_75 _ = happyFail

action_76 (35) = happyShift action_35
action_76 (37) = happyShift action_36
action_76 (51) = happyShift action_37
action_76 (59) = happyShift action_38
action_76 (77) = happyShift action_39
action_76 (78) = happyShift action_40
action_76 (79) = happyShift action_41
action_76 (80) = happyShift action_42
action_76 (81) = happyShift action_13
action_76 (15) = happyGoto action_30
action_76 (16) = happyGoto action_31
action_76 (17) = happyGoto action_32
action_76 (18) = happyGoto action_33
action_76 (19) = happyGoto action_18
action_76 (21) = happyGoto action_109
action_76 _ = happyFail

action_77 (26) = happyShift action_5
action_77 (41) = happyShift action_6
action_77 (44) = happyShift action_7
action_77 (46) = happyShift action_8
action_77 (47) = happyShift action_9
action_77 (48) = happyShift action_10
action_77 (74) = happyShift action_11
action_77 (76) = happyShift action_12
action_77 (81) = happyShift action_13
action_77 (5) = happyGoto action_108
action_77 (6) = happyGoto action_3
action_77 (19) = happyGoto action_4
action_77 _ = happyFail

action_78 (35) = happyShift action_35
action_78 (37) = happyShift action_36
action_78 (51) = happyShift action_37
action_78 (59) = happyShift action_38
action_78 (77) = happyShift action_39
action_78 (78) = happyShift action_40
action_78 (79) = happyShift action_41
action_78 (80) = happyShift action_42
action_78 (81) = happyShift action_13
action_78 (15) = happyGoto action_30
action_78 (16) = happyGoto action_31
action_78 (17) = happyGoto action_32
action_78 (18) = happyGoto action_33
action_78 (19) = happyGoto action_18
action_78 (21) = happyGoto action_107
action_78 _ = happyFail

action_79 (26) = happyShift action_5
action_79 (41) = happyShift action_6
action_79 (44) = happyShift action_7
action_79 (46) = happyShift action_8
action_79 (47) = happyShift action_9
action_79 (48) = happyShift action_10
action_79 (74) = happyShift action_11
action_79 (76) = happyShift action_12
action_79 (81) = happyShift action_13
action_79 (5) = happyGoto action_106
action_79 (6) = happyGoto action_3
action_79 (19) = happyGoto action_4
action_79 _ = happyFail

action_80 (39) = happyShift action_53
action_80 _ = happyReduce_70

action_81 (39) = happyShift action_53
action_81 (52) = happyShift action_56
action_81 (53) = happyShift action_57
action_81 (54) = happyShift action_58
action_81 (55) = happyShift action_59
action_81 (56) = happyShift action_60
action_81 (57) = happyShift action_61
action_81 (58) = happyShift action_62
action_81 (59) = happyShift action_63
action_81 (60) = happyShift action_64
action_81 (61) = happyShift action_65
action_81 (62) = happyShift action_66
action_81 (63) = happyShift action_67
action_81 (64) = happyShift action_68
action_81 (65) = happyShift action_69
action_81 (66) = happyShift action_70
action_81 (67) = happyShift action_71
action_81 (68) = happyShift action_72
action_81 (69) = happyShift action_73
action_81 (70) = happyShift action_74
action_81 (71) = happyShift action_75
action_81 (72) = happyShift action_76
action_81 _ = happyReduce_72

action_82 (28) = happyShift action_85
action_82 _ = happyReduce_29

action_83 (29) = happyShift action_104
action_83 (38) = happyShift action_105
action_83 _ = happyFail

action_84 (36) = happyShift action_103
action_84 (39) = happyShift action_53
action_84 (49) = happyShift action_54
action_84 (50) = happyShift action_55
action_84 (52) = happyShift action_56
action_84 (53) = happyShift action_57
action_84 (54) = happyShift action_58
action_84 (55) = happyShift action_59
action_84 (56) = happyShift action_60
action_84 (57) = happyShift action_61
action_84 (58) = happyShift action_62
action_84 (59) = happyShift action_63
action_84 (60) = happyShift action_64
action_84 (61) = happyShift action_65
action_84 (62) = happyShift action_66
action_84 (63) = happyShift action_67
action_84 (64) = happyShift action_68
action_84 (65) = happyShift action_69
action_84 (66) = happyShift action_70
action_84 (67) = happyShift action_71
action_84 (68) = happyShift action_72
action_84 (69) = happyShift action_73
action_84 (70) = happyShift action_74
action_84 (71) = happyShift action_75
action_84 (72) = happyShift action_76
action_84 _ = happyFail

action_85 (35) = happyShift action_35
action_85 (37) = happyShift action_36
action_85 (51) = happyShift action_37
action_85 (59) = happyShift action_38
action_85 (77) = happyShift action_39
action_85 (78) = happyShift action_40
action_85 (79) = happyShift action_41
action_85 (80) = happyShift action_42
action_85 (81) = happyShift action_13
action_85 (15) = happyGoto action_30
action_85 (16) = happyGoto action_31
action_85 (17) = happyGoto action_32
action_85 (18) = happyGoto action_33
action_85 (19) = happyGoto action_18
action_85 (21) = happyGoto action_102
action_85 _ = happyFail

action_86 (35) = happyShift action_35
action_86 (37) = happyShift action_36
action_86 (51) = happyShift action_37
action_86 (59) = happyShift action_38
action_86 (77) = happyShift action_39
action_86 (78) = happyShift action_40
action_86 (79) = happyShift action_41
action_86 (80) = happyShift action_42
action_86 (81) = happyShift action_13
action_86 (15) = happyGoto action_30
action_86 (16) = happyGoto action_31
action_86 (17) = happyGoto action_32
action_86 (18) = happyGoto action_33
action_86 (19) = happyGoto action_18
action_86 (21) = happyGoto action_101
action_86 _ = happyFail

action_87 (35) = happyShift action_35
action_87 (37) = happyShift action_36
action_87 (51) = happyShift action_37
action_87 (59) = happyShift action_38
action_87 (77) = happyShift action_39
action_87 (78) = happyShift action_40
action_87 (79) = happyShift action_41
action_87 (80) = happyShift action_42
action_87 (81) = happyShift action_13
action_87 (15) = happyGoto action_30
action_87 (16) = happyGoto action_31
action_87 (17) = happyGoto action_32
action_87 (18) = happyGoto action_33
action_87 (19) = happyGoto action_18
action_87 (21) = happyGoto action_100
action_87 _ = happyFail

action_88 (35) = happyShift action_35
action_88 (37) = happyShift action_36
action_88 (51) = happyShift action_37
action_88 (59) = happyShift action_38
action_88 (77) = happyShift action_39
action_88 (78) = happyShift action_40
action_88 (79) = happyShift action_41
action_88 (80) = happyShift action_42
action_88 (81) = happyShift action_13
action_88 (13) = happyGoto action_99
action_88 (15) = happyGoto action_30
action_88 (16) = happyGoto action_31
action_88 (17) = happyGoto action_32
action_88 (18) = happyGoto action_33
action_88 (19) = happyGoto action_18
action_88 (21) = happyGoto action_34
action_88 _ = happyFail

action_89 (73) = happyShift action_98
action_89 _ = happyReduce_23

action_90 (30) = happyShift action_23
action_90 (31) = happyShift action_24
action_90 (32) = happyShift action_25
action_90 (33) = happyShift action_26
action_90 (34) = happyShift action_27
action_90 (11) = happyGoto action_97
action_90 (20) = happyGoto action_22
action_90 _ = happyReduce_16

action_91 (26) = happyShift action_5
action_91 (41) = happyShift action_6
action_91 (44) = happyShift action_7
action_91 (46) = happyShift action_8
action_91 (47) = happyShift action_9
action_91 (48) = happyShift action_10
action_91 (74) = happyShift action_11
action_91 (76) = happyShift action_12
action_91 (81) = happyShift action_13
action_91 (5) = happyGoto action_96
action_91 (6) = happyGoto action_3
action_91 (19) = happyGoto action_4
action_91 _ = happyFail

action_92 (35) = happyShift action_35
action_92 (37) = happyShift action_36
action_92 (51) = happyShift action_37
action_92 (59) = happyShift action_38
action_92 (77) = happyShift action_39
action_92 (78) = happyShift action_40
action_92 (79) = happyShift action_41
action_92 (80) = happyShift action_42
action_92 (81) = happyShift action_13
action_92 (15) = happyGoto action_30
action_92 (16) = happyGoto action_31
action_92 (17) = happyGoto action_32
action_92 (18) = happyGoto action_33
action_92 (19) = happyGoto action_18
action_92 (21) = happyGoto action_95
action_92 _ = happyFail

action_93 (24) = happyShift action_94
action_93 (26) = happyShift action_5
action_93 (41) = happyShift action_6
action_93 (44) = happyShift action_7
action_93 (46) = happyShift action_8
action_93 (47) = happyShift action_9
action_93 (48) = happyShift action_10
action_93 (74) = happyShift action_11
action_93 (76) = happyShift action_12
action_93 (81) = happyShift action_13
action_93 (6) = happyGoto action_49
action_93 (19) = happyGoto action_4
action_93 _ = happyFail

action_94 (27) = happyShift action_145
action_94 _ = happyFail

action_95 (39) = happyShift action_53
action_95 (49) = happyShift action_54
action_95 (50) = happyShift action_55
action_95 (52) = happyShift action_56
action_95 (53) = happyShift action_57
action_95 (54) = happyShift action_58
action_95 (55) = happyShift action_59
action_95 (56) = happyShift action_60
action_95 (57) = happyShift action_61
action_95 (58) = happyShift action_62
action_95 (59) = happyShift action_63
action_95 (60) = happyShift action_64
action_95 (61) = happyShift action_65
action_95 (62) = happyShift action_66
action_95 (63) = happyShift action_67
action_95 (64) = happyShift action_68
action_95 (65) = happyShift action_69
action_95 (66) = happyShift action_70
action_95 (67) = happyShift action_71
action_95 (68) = happyShift action_72
action_95 (69) = happyShift action_73
action_95 (70) = happyShift action_74
action_95 (71) = happyShift action_75
action_95 (72) = happyShift action_76
action_95 _ = happyReduce_5

action_96 (27) = happyShift action_144
action_96 _ = happyFail

action_97 _ = happyReduce_18

action_98 (35) = happyShift action_35
action_98 (37) = happyShift action_36
action_98 (51) = happyShift action_37
action_98 (59) = happyShift action_38
action_98 (77) = happyShift action_39
action_98 (78) = happyShift action_40
action_98 (79) = happyShift action_41
action_98 (80) = happyShift action_42
action_98 (81) = happyShift action_13
action_98 (15) = happyGoto action_30
action_98 (16) = happyGoto action_31
action_98 (17) = happyGoto action_32
action_98 (18) = happyGoto action_33
action_98 (19) = happyGoto action_18
action_98 (21) = happyGoto action_143
action_98 _ = happyFail

action_99 (28) = happyShift action_85
action_99 (36) = happyShift action_142
action_99 _ = happyFail

action_100 (36) = happyShift action_141
action_100 (39) = happyShift action_53
action_100 (49) = happyShift action_54
action_100 (50) = happyShift action_55
action_100 (52) = happyShift action_56
action_100 (53) = happyShift action_57
action_100 (54) = happyShift action_58
action_100 (55) = happyShift action_59
action_100 (56) = happyShift action_60
action_100 (57) = happyShift action_61
action_100 (58) = happyShift action_62
action_100 (59) = happyShift action_63
action_100 (60) = happyShift action_64
action_100 (61) = happyShift action_65
action_100 (62) = happyShift action_66
action_100 (63) = happyShift action_67
action_100 (64) = happyShift action_68
action_100 (65) = happyShift action_69
action_100 (66) = happyShift action_70
action_100 (67) = happyShift action_71
action_100 (68) = happyShift action_72
action_100 (69) = happyShift action_73
action_100 (70) = happyShift action_74
action_100 (71) = happyShift action_75
action_100 (72) = happyShift action_76
action_100 _ = happyFail

action_101 (36) = happyShift action_140
action_101 (39) = happyShift action_53
action_101 (49) = happyShift action_54
action_101 (50) = happyShift action_55
action_101 (52) = happyShift action_56
action_101 (53) = happyShift action_57
action_101 (54) = happyShift action_58
action_101 (55) = happyShift action_59
action_101 (56) = happyShift action_60
action_101 (57) = happyShift action_61
action_101 (58) = happyShift action_62
action_101 (59) = happyShift action_63
action_101 (60) = happyShift action_64
action_101 (61) = happyShift action_65
action_101 (62) = happyShift action_66
action_101 (63) = happyShift action_67
action_101 (64) = happyShift action_68
action_101 (65) = happyShift action_69
action_101 (66) = happyShift action_70
action_101 (67) = happyShift action_71
action_101 (68) = happyShift action_72
action_101 (69) = happyShift action_73
action_101 (70) = happyShift action_74
action_101 (71) = happyShift action_75
action_101 (72) = happyShift action_76
action_101 _ = happyFail

action_102 (39) = happyShift action_53
action_102 (49) = happyShift action_54
action_102 (50) = happyShift action_55
action_102 (52) = happyShift action_56
action_102 (53) = happyShift action_57
action_102 (54) = happyShift action_58
action_102 (55) = happyShift action_59
action_102 (56) = happyShift action_60
action_102 (57) = happyShift action_61
action_102 (58) = happyShift action_62
action_102 (59) = happyShift action_63
action_102 (60) = happyShift action_64
action_102 (61) = happyShift action_65
action_102 (62) = happyShift action_66
action_102 (63) = happyShift action_67
action_102 (64) = happyShift action_68
action_102 (65) = happyShift action_69
action_102 (66) = happyShift action_70
action_102 (67) = happyShift action_71
action_102 (68) = happyShift action_72
action_102 (69) = happyShift action_73
action_102 (70) = happyShift action_74
action_102 (71) = happyShift action_75
action_102 (72) = happyShift action_76
action_102 _ = happyReduce_28

action_103 _ = happyReduce_73

action_104 (35) = happyShift action_35
action_104 (37) = happyShift action_36
action_104 (51) = happyShift action_37
action_104 (59) = happyShift action_38
action_104 (77) = happyShift action_39
action_104 (78) = happyShift action_40
action_104 (79) = happyShift action_41
action_104 (80) = happyShift action_42
action_104 (81) = happyShift action_13
action_104 (13) = happyGoto action_139
action_104 (15) = happyGoto action_30
action_104 (16) = happyGoto action_31
action_104 (17) = happyGoto action_32
action_104 (18) = happyGoto action_33
action_104 (19) = happyGoto action_18
action_104 (21) = happyGoto action_34
action_104 _ = happyFail

action_105 _ = happyReduce_46

action_106 (27) = happyShift action_138
action_106 _ = happyFail

action_107 (39) = happyShift action_53
action_107 (45) = happyShift action_137
action_107 (49) = happyShift action_54
action_107 (50) = happyShift action_55
action_107 (52) = happyShift action_56
action_107 (53) = happyShift action_57
action_107 (54) = happyShift action_58
action_107 (55) = happyShift action_59
action_107 (56) = happyShift action_60
action_107 (57) = happyShift action_61
action_107 (58) = happyShift action_62
action_107 (59) = happyShift action_63
action_107 (60) = happyShift action_64
action_107 (61) = happyShift action_65
action_107 (62) = happyShift action_66
action_107 (63) = happyShift action_67
action_107 (64) = happyShift action_68
action_107 (65) = happyShift action_69
action_107 (66) = happyShift action_70
action_107 (67) = happyShift action_71
action_107 (68) = happyShift action_72
action_107 (69) = happyShift action_73
action_107 (70) = happyShift action_74
action_107 (71) = happyShift action_75
action_107 (72) = happyShift action_76
action_107 _ = happyFail

action_108 (27) = happyShift action_136
action_108 _ = happyFail

action_109 (39) = happyShift action_53
action_109 (58) = happyShift action_62
action_109 (59) = happyShift action_63
action_109 (60) = happyShift action_64
action_109 (61) = happyShift action_65
action_109 (62) = happyShift action_66
action_109 (63) = happyShift action_67
action_109 (64) = happyShift action_68
action_109 (65) = happyShift action_69
action_109 _ = happyReduce_60

action_110 (39) = happyShift action_53
action_110 (58) = happyShift action_62
action_110 (59) = happyShift action_63
action_110 (60) = happyShift action_64
action_110 (61) = happyShift action_65
action_110 (62) = happyShift action_66
action_110 (63) = happyShift action_67
action_110 (64) = happyShift action_68
action_110 (65) = happyShift action_69
action_110 _ = happyReduce_59

action_111 (39) = happyShift action_53
action_111 (58) = happyShift action_62
action_111 (59) = happyShift action_63
action_111 (60) = happyShift action_64
action_111 (61) = happyShift action_65
action_111 (62) = happyShift action_66
action_111 (63) = happyShift action_67
action_111 (64) = happyShift action_68
action_111 (65) = happyShift action_69
action_111 _ = happyReduce_58

action_112 (39) = happyShift action_53
action_112 (58) = happyShift action_62
action_112 (59) = happyShift action_63
action_112 (60) = happyShift action_64
action_112 (61) = happyShift action_65
action_112 (62) = happyShift action_66
action_112 (63) = happyShift action_67
action_112 (64) = happyShift action_68
action_112 (65) = happyShift action_69
action_112 _ = happyReduce_57

action_113 (39) = happyShift action_53
action_113 (58) = happyShift action_62
action_113 (59) = happyShift action_63
action_113 (60) = happyShift action_64
action_113 (61) = happyShift action_65
action_113 (62) = happyShift action_66
action_113 (63) = happyShift action_67
action_113 (64) = happyShift action_68
action_113 (65) = happyShift action_69
action_113 _ = happyReduce_56

action_114 (39) = happyShift action_53
action_114 (58) = happyShift action_62
action_114 (59) = happyShift action_63
action_114 (60) = happyShift action_64
action_114 (61) = happyShift action_65
action_114 (62) = happyShift action_66
action_114 (63) = happyShift action_67
action_114 (64) = happyShift action_68
action_114 (65) = happyShift action_69
action_114 (68) = happyShift action_72
action_114 (69) = happyShift action_73
action_114 (70) = happyShift action_74
action_114 (71) = happyShift action_75
action_114 (72) = happyShift action_76
action_114 _ = happyReduce_55

action_115 (39) = happyShift action_53
action_115 (58) = happyShift action_62
action_115 (59) = happyShift action_63
action_115 (60) = happyShift action_64
action_115 (61) = happyShift action_65
action_115 (62) = happyShift action_66
action_115 (63) = happyShift action_67
action_115 (64) = happyShift action_68
action_115 (65) = happyShift action_69
action_115 (68) = happyShift action_72
action_115 (69) = happyShift action_73
action_115 (70) = happyShift action_74
action_115 (71) = happyShift action_75
action_115 (72) = happyShift action_76
action_115 _ = happyReduce_54

action_116 (39) = happyShift action_53
action_116 (65) = happyShift action_69
action_116 _ = happyReduce_53

action_117 (39) = happyShift action_53
action_117 (65) = happyShift action_69
action_117 _ = happyReduce_52

action_118 (39) = happyShift action_53
action_118 (65) = happyShift action_69
action_118 _ = happyReduce_51

action_119 (39) = happyShift action_53
action_119 (65) = happyShift action_69
action_119 _ = happyReduce_50

action_120 (39) = happyShift action_53
action_120 (65) = happyShift action_69
action_120 _ = happyReduce_49

action_121 (39) = happyShift action_53
action_121 (60) = happyShift action_64
action_121 (61) = happyShift action_65
action_121 (62) = happyShift action_66
action_121 (63) = happyShift action_67
action_121 (64) = happyShift action_68
action_121 (65) = happyShift action_69
action_121 _ = happyReduce_48

action_122 (39) = happyShift action_53
action_122 (60) = happyShift action_64
action_122 (61) = happyShift action_65
action_122 (62) = happyShift action_66
action_122 (63) = happyShift action_67
action_122 (64) = happyShift action_68
action_122 (65) = happyShift action_69
action_122 _ = happyReduce_47

action_123 (39) = happyShift action_53
action_123 (52) = happyFail
action_123 (53) = happyFail
action_123 (54) = happyFail
action_123 (55) = happyFail
action_123 (56) = happyFail
action_123 (57) = happyFail
action_123 (58) = happyShift action_62
action_123 (59) = happyShift action_63
action_123 (60) = happyShift action_64
action_123 (61) = happyShift action_65
action_123 (62) = happyShift action_66
action_123 (63) = happyShift action_67
action_123 (64) = happyShift action_68
action_123 (65) = happyShift action_69
action_123 (66) = happyShift action_70
action_123 (67) = happyShift action_71
action_123 (68) = happyShift action_72
action_123 (69) = happyShift action_73
action_123 (70) = happyShift action_74
action_123 (71) = happyShift action_75
action_123 (72) = happyShift action_76
action_123 _ = happyReduce_67

action_124 (39) = happyShift action_53
action_124 (52) = happyFail
action_124 (53) = happyFail
action_124 (54) = happyFail
action_124 (55) = happyFail
action_124 (56) = happyFail
action_124 (57) = happyFail
action_124 (58) = happyShift action_62
action_124 (59) = happyShift action_63
action_124 (60) = happyShift action_64
action_124 (61) = happyShift action_65
action_124 (62) = happyShift action_66
action_124 (63) = happyShift action_67
action_124 (64) = happyShift action_68
action_124 (65) = happyShift action_69
action_124 (66) = happyShift action_70
action_124 (67) = happyShift action_71
action_124 (68) = happyShift action_72
action_124 (69) = happyShift action_73
action_124 (70) = happyShift action_74
action_124 (71) = happyShift action_75
action_124 (72) = happyShift action_76
action_124 _ = happyReduce_68

action_125 (39) = happyShift action_53
action_125 (52) = happyFail
action_125 (53) = happyFail
action_125 (54) = happyFail
action_125 (55) = happyFail
action_125 (56) = happyFail
action_125 (57) = happyFail
action_125 (58) = happyShift action_62
action_125 (59) = happyShift action_63
action_125 (60) = happyShift action_64
action_125 (61) = happyShift action_65
action_125 (62) = happyShift action_66
action_125 (63) = happyShift action_67
action_125 (64) = happyShift action_68
action_125 (65) = happyShift action_69
action_125 (66) = happyShift action_70
action_125 (67) = happyShift action_71
action_125 (68) = happyShift action_72
action_125 (69) = happyShift action_73
action_125 (70) = happyShift action_74
action_125 (71) = happyShift action_75
action_125 (72) = happyShift action_76
action_125 _ = happyReduce_65

action_126 (39) = happyShift action_53
action_126 (52) = happyFail
action_126 (53) = happyFail
action_126 (54) = happyFail
action_126 (55) = happyFail
action_126 (56) = happyFail
action_126 (57) = happyFail
action_126 (58) = happyShift action_62
action_126 (59) = happyShift action_63
action_126 (60) = happyShift action_64
action_126 (61) = happyShift action_65
action_126 (62) = happyShift action_66
action_126 (63) = happyShift action_67
action_126 (64) = happyShift action_68
action_126 (65) = happyShift action_69
action_126 (66) = happyShift action_70
action_126 (67) = happyShift action_71
action_126 (68) = happyShift action_72
action_126 (69) = happyShift action_73
action_126 (70) = happyShift action_74
action_126 (71) = happyShift action_75
action_126 (72) = happyShift action_76
action_126 _ = happyReduce_66

action_127 (39) = happyShift action_53
action_127 (52) = happyFail
action_127 (53) = happyFail
action_127 (54) = happyFail
action_127 (55) = happyFail
action_127 (56) = happyFail
action_127 (57) = happyFail
action_127 (58) = happyShift action_62
action_127 (59) = happyShift action_63
action_127 (60) = happyShift action_64
action_127 (61) = happyShift action_65
action_127 (62) = happyShift action_66
action_127 (63) = happyShift action_67
action_127 (64) = happyShift action_68
action_127 (65) = happyShift action_69
action_127 (66) = happyShift action_70
action_127 (67) = happyShift action_71
action_127 (68) = happyShift action_72
action_127 (69) = happyShift action_73
action_127 (70) = happyShift action_74
action_127 (71) = happyShift action_75
action_127 (72) = happyShift action_76
action_127 _ = happyReduce_64

action_128 (39) = happyShift action_53
action_128 (52) = happyFail
action_128 (53) = happyFail
action_128 (54) = happyFail
action_128 (55) = happyFail
action_128 (56) = happyFail
action_128 (57) = happyFail
action_128 (58) = happyShift action_62
action_128 (59) = happyShift action_63
action_128 (60) = happyShift action_64
action_128 (61) = happyShift action_65
action_128 (62) = happyShift action_66
action_128 (63) = happyShift action_67
action_128 (64) = happyShift action_68
action_128 (65) = happyShift action_69
action_128 (66) = happyShift action_70
action_128 (67) = happyShift action_71
action_128 (68) = happyShift action_72
action_128 (69) = happyShift action_73
action_128 (70) = happyShift action_74
action_128 (71) = happyShift action_75
action_128 (72) = happyShift action_76
action_128 _ = happyReduce_63

action_129 (39) = happyShift action_53
action_129 (49) = happyShift action_54
action_129 (52) = happyShift action_56
action_129 (53) = happyShift action_57
action_129 (54) = happyShift action_58
action_129 (55) = happyShift action_59
action_129 (56) = happyShift action_60
action_129 (57) = happyShift action_61
action_129 (58) = happyShift action_62
action_129 (59) = happyShift action_63
action_129 (60) = happyShift action_64
action_129 (61) = happyShift action_65
action_129 (62) = happyShift action_66
action_129 (63) = happyShift action_67
action_129 (64) = happyShift action_68
action_129 (65) = happyShift action_69
action_129 (66) = happyShift action_70
action_129 (67) = happyShift action_71
action_129 (68) = happyShift action_72
action_129 (69) = happyShift action_73
action_129 (70) = happyShift action_74
action_129 (71) = happyShift action_75
action_129 (72) = happyShift action_76
action_129 _ = happyReduce_61

action_130 (39) = happyShift action_53
action_130 (52) = happyShift action_56
action_130 (53) = happyShift action_57
action_130 (54) = happyShift action_58
action_130 (55) = happyShift action_59
action_130 (56) = happyShift action_60
action_130 (57) = happyShift action_61
action_130 (58) = happyShift action_62
action_130 (59) = happyShift action_63
action_130 (60) = happyShift action_64
action_130 (61) = happyShift action_65
action_130 (62) = happyShift action_66
action_130 (63) = happyShift action_67
action_130 (64) = happyShift action_68
action_130 (65) = happyShift action_69
action_130 (66) = happyShift action_70
action_130 (67) = happyShift action_71
action_130 (68) = happyShift action_72
action_130 (69) = happyShift action_73
action_130 (70) = happyShift action_74
action_130 (71) = happyShift action_75
action_130 (72) = happyShift action_76
action_130 _ = happyReduce_62

action_131 (28) = happyShift action_85
action_131 (40) = happyShift action_135
action_131 _ = happyFail

action_132 _ = happyReduce_6

action_133 (27) = happyShift action_134
action_133 _ = happyFail

action_134 (24) = happyShift action_151
action_134 (26) = happyShift action_5
action_134 (41) = happyShift action_6
action_134 (44) = happyShift action_7
action_134 (46) = happyShift action_8
action_134 (47) = happyShift action_9
action_134 (48) = happyShift action_10
action_134 (74) = happyShift action_11
action_134 (76) = happyShift action_12
action_134 (81) = happyShift action_13
action_134 (6) = happyGoto action_49
action_134 (19) = happyGoto action_4
action_134 _ = happyFail

action_135 _ = happyReduce_71

action_136 (24) = happyShift action_149
action_136 (26) = happyShift action_5
action_136 (41) = happyShift action_6
action_136 (42) = happyShift action_150
action_136 (44) = happyShift action_7
action_136 (46) = happyShift action_8
action_136 (47) = happyShift action_9
action_136 (48) = happyShift action_10
action_136 (74) = happyShift action_11
action_136 (76) = happyShift action_12
action_136 (81) = happyShift action_13
action_136 (6) = happyGoto action_49
action_136 (19) = happyGoto action_4
action_136 _ = happyFail

action_137 (26) = happyShift action_5
action_137 (41) = happyShift action_6
action_137 (44) = happyShift action_7
action_137 (46) = happyShift action_8
action_137 (47) = happyShift action_9
action_137 (48) = happyShift action_10
action_137 (74) = happyShift action_11
action_137 (76) = happyShift action_12
action_137 (81) = happyShift action_13
action_137 (5) = happyGoto action_148
action_137 (6) = happyGoto action_3
action_137 (19) = happyGoto action_4
action_137 _ = happyFail

action_138 (24) = happyShift action_147
action_138 (26) = happyShift action_5
action_138 (41) = happyShift action_6
action_138 (44) = happyShift action_7
action_138 (46) = happyShift action_8
action_138 (47) = happyShift action_9
action_138 (48) = happyShift action_10
action_138 (74) = happyShift action_11
action_138 (76) = happyShift action_12
action_138 (81) = happyShift action_13
action_138 (6) = happyGoto action_49
action_138 (19) = happyGoto action_4
action_138 _ = happyFail

action_139 (28) = happyShift action_85
action_139 _ = happyReduce_30

action_140 _ = happyReduce_41

action_141 _ = happyReduce_40

action_142 _ = happyReduce_39

action_143 (39) = happyShift action_53
action_143 (49) = happyShift action_54
action_143 (50) = happyShift action_55
action_143 (52) = happyShift action_56
action_143 (53) = happyShift action_57
action_143 (54) = happyShift action_58
action_143 (55) = happyShift action_59
action_143 (56) = happyShift action_60
action_143 (57) = happyShift action_61
action_143 (58) = happyShift action_62
action_143 (59) = happyShift action_63
action_143 (60) = happyShift action_64
action_143 (61) = happyShift action_65
action_143 (62) = happyShift action_66
action_143 (63) = happyShift action_67
action_143 (64) = happyShift action_68
action_143 (65) = happyShift action_69
action_143 (66) = happyShift action_70
action_143 (67) = happyShift action_71
action_143 (68) = happyShift action_72
action_143 (69) = happyShift action_73
action_143 (70) = happyShift action_74
action_143 (71) = happyShift action_75
action_143 (72) = happyShift action_76
action_143 _ = happyReduce_24

action_144 (24) = happyShift action_146
action_144 (26) = happyShift action_5
action_144 (41) = happyShift action_6
action_144 (44) = happyShift action_7
action_144 (46) = happyShift action_8
action_144 (47) = happyShift action_9
action_144 (48) = happyShift action_10
action_144 (74) = happyShift action_11
action_144 (76) = happyShift action_12
action_144 (81) = happyShift action_13
action_144 (6) = happyGoto action_49
action_144 (19) = happyGoto action_4
action_144 _ = happyFail

action_145 _ = happyReduce_2

action_146 _ = happyReduce_14

action_147 _ = happyReduce_11

action_148 (27) = happyShift action_154
action_148 _ = happyFail

action_149 _ = happyReduce_9

action_150 (26) = happyShift action_5
action_150 (41) = happyShift action_6
action_150 (44) = happyShift action_7
action_150 (46) = happyShift action_8
action_150 (47) = happyShift action_9
action_150 (48) = happyShift action_10
action_150 (74) = happyShift action_11
action_150 (76) = happyShift action_12
action_150 (81) = happyShift action_13
action_150 (5) = happyGoto action_153
action_150 (6) = happyGoto action_3
action_150 (19) = happyGoto action_4
action_150 _ = happyFail

action_151 (27) = happyShift action_152
action_151 _ = happyFail

action_152 _ = happyReduce_1

action_153 (27) = happyShift action_156
action_153 _ = happyFail

action_154 (24) = happyShift action_155
action_154 (26) = happyShift action_5
action_154 (41) = happyShift action_6
action_154 (44) = happyShift action_7
action_154 (46) = happyShift action_8
action_154 (47) = happyShift action_9
action_154 (48) = happyShift action_10
action_154 (74) = happyShift action_11
action_154 (76) = happyShift action_12
action_154 (81) = happyShift action_13
action_154 (6) = happyGoto action_49
action_154 (19) = happyGoto action_4
action_154 _ = happyFail

action_155 _ = happyReduce_10

action_156 (24) = happyShift action_157
action_156 (26) = happyShift action_5
action_156 (41) = happyShift action_6
action_156 (44) = happyShift action_7
action_156 (46) = happyShift action_8
action_156 (47) = happyShift action_9
action_156 (48) = happyShift action_10
action_156 (74) = happyShift action_11
action_156 (76) = happyShift action_12
action_156 (81) = happyShift action_13
action_156 (6) = happyGoto action_49
action_156 (19) = happyGoto action_4
action_156 _ = happyFail

action_157 _ = happyReduce_8

happyReduce_1 = happyReduce 7 4 happyReduction_1
happyReduction_1 (_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn5  happy_var_4) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn5  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn4
		 (Program happy_var_1 happy_var_4
	) `HappyStk` happyRest

happyReduce_2 = happyReduce 5 4 happyReduction_2
happyReduction_2 (_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn5  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn4
		 (Program empty happy_var_2
	) `HappyStk` happyRest

happyReduce_3 = happySpecReduce_1  5 happyReduction_3
happyReduction_3 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn5
		 (expandStatement happy_var_1
	)
happyReduction_3 _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_3  5 happyReduction_4
happyReduction_4 (HappyAbsSyn6  happy_var_3)
	_
	(HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn5
		 (happy_var_1 >< expandStatement happy_var_3
	)
happyReduction_4 _ _ _  = notHappyAtAll 

happyReduce_5 = happyReduce 4 6 happyReduction_5
happyReduction_5 ((HappyAbsSyn21  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn18  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (StAssign happy_var_2 happy_var_4 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_6 = happyReduce 4 6 happyReduction_6
happyReduction_6 (_ `HappyStk`
	(HappyAbsSyn12  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn19  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (StFunctionCall happy_var_1 happy_var_3 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_7 = happySpecReduce_2  6 happyReduction_7
happyReduction_7 (HappyAbsSyn21  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn6
		 (StReturn happy_var_2 <$ happy_var_1
	)
happyReduction_7 _ _  = notHappyAtAll 

happyReduce_8 = happyReduce 9 6 happyReduction_8
happyReduction_8 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn5  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn5  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (StIf happy_var_2 happy_var_4 happy_var_7 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_9 = happyReduce 6 6 happyReduction_9
happyReduction_9 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn5  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (StIf happy_var_2 happy_var_4 empty <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_10 = happyReduce 8 6 happyReduction_10
happyReduction_10 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn5  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn19  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (StFor happy_var_2 happy_var_4 happy_var_6 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_11 = happyReduce 6 6 happyReduction_11
happyReduction_11 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn5  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (StWhile happy_var_2 happy_var_4 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_12 = happySpecReduce_2  6 happyReduction_12
happyReduction_12 (HappyAbsSyn18  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn6
		 (StRead happy_var_2 <$ happy_var_1
	)
happyReduction_12 _ _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_2  6 happyReduction_13
happyReduction_13 (HappyAbsSyn12  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn6
		 (StPrintList happy_var_2 <$ happy_var_1
	)
happyReduction_13 _ _  = notHappyAtAll 

happyReduce_14 = happyReduce 6 6 happyReduction_14
happyReduction_14 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn5  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn7  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (StBlock happy_var_2 happy_var_4 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_15 = happySpecReduce_0  7 happyReduction_15
happyReduction_15  =  HappyAbsSyn7
		 (empty
	)

happyReduce_16 = happySpecReduce_2  7 happyReduction_16
happyReduction_16 _
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn7
		 (happy_var_1
	)
happyReduction_16 _ _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_1  8 happyReduction_17
happyReduction_17 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn7
		 (singleton happy_var_1
	)
happyReduction_17 _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_3  8 happyReduction_18
happyReduction_18 (HappyAbsSyn11  happy_var_3)
	_
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn7
		 (happy_var_1 |> happy_var_3
	)
happyReduction_18 _ _ _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_0  9 happyReduction_19
happyReduction_19  =  HappyAbsSyn7
		 (empty
	)

happyReduce_20 = happySpecReduce_1  9 happyReduction_20
happyReduction_20 (HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn7
		 (happy_var_1
	)
happyReduction_20 _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_1  10 happyReduction_21
happyReduction_21 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn7
		 (singleton happy_var_1
	)
happyReduction_21 _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_3  10 happyReduction_22
happyReduction_22 (HappyAbsSyn11  happy_var_3)
	_
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn7
		 (happy_var_1 |> happy_var_3
	)
happyReduction_22 _ _ _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_2  11 happyReduction_23
happyReduction_23 (HappyAbsSyn19  happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn11
		 (Dcl happy_var_1 happy_var_2 <$ happy_var_1
	)
happyReduction_23 _ _  = notHappyAtAll 

happyReduce_24 = happyReduce 4 11 happyReduction_24
happyReduction_24 ((HappyAbsSyn21  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn19  happy_var_2) `HappyStk`
	(HappyAbsSyn20  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn11
		 (DclInit happy_var_1 happy_var_2 happy_var_4 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_25 = happySpecReduce_0  12 happyReduction_25
happyReduction_25  =  HappyAbsSyn12
		 (empty
	)

happyReduce_26 = happySpecReduce_1  12 happyReduction_26
happyReduction_26 (HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (happy_var_1
	)
happyReduction_26 _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_1  13 happyReduction_27
happyReduction_27 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn12
		 (singleton happy_var_1
	)
happyReduction_27 _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_3  13 happyReduction_28
happyReduction_28 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (happy_var_1 |> happy_var_3
	)
happyReduction_28 _ _ _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_1  14 happyReduction_29
happyReduction_29 (HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn14
		 ([happy_var_1]
	)
happyReduction_29 _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_3  14 happyReduction_30
happyReduction_30 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_30 _ _ _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_1  15 happyReduction_31
happyReduction_31 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn15
		 (unTkNumber `fmap` happy_var_1
	)
happyReduction_31 _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_1  16 happyReduction_32
happyReduction_32 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn16
		 (unTkBoolean `fmap` happy_var_1
	)
happyReduction_32 _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_1  16 happyReduction_33
happyReduction_33 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn16
		 (unTkBoolean `fmap` happy_var_1
	)
happyReduction_33 _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_1  17 happyReduction_34
happyReduction_34 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn17
		 (unTkString `fmap` happy_var_1
	)
happyReduction_34 _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_1  18 happyReduction_35
happyReduction_35 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn18
		 (VariableAccess happy_var_1 <$ happy_var_1
	)
happyReduction_35 _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_1  19 happyReduction_36
happyReduction_36 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn19
		 (unTkId `fmap` happy_var_1
	)
happyReduction_36 _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_1  20 happyReduction_37
happyReduction_37 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn20
		 (Bool <$ happy_var_1
	)
happyReduction_37 _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_1  20 happyReduction_38
happyReduction_38 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn20
		 (Double <$ happy_var_1
	)
happyReduction_38 _  = notHappyAtAll 

happyReduce_39 = happyReduce 4 20 happyReduction_39
happyReduction_39 (_ `HappyStk`
	(HappyAbsSyn12  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (Matrix happy_var_3 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_40 = happyReduce 4 20 happyReduction_40
happyReduction_40 (_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (Row happy_var_3 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_41 = happyReduce 4 20 happyReduction_41
happyReduction_41 (_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (Col happy_var_3 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_42 = happySpecReduce_1  21 happyReduction_42
happyReduction_42 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn21
		 (LitNumber happy_var_1 <$ happy_var_1
	)
happyReduction_42 _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_1  21 happyReduction_43
happyReduction_43 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn21
		 (LitBool happy_var_1 <$ happy_var_1
	)
happyReduction_43 _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_1  21 happyReduction_44
happyReduction_44 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn21
		 (LitString happy_var_1 <$ happy_var_1
	)
happyReduction_44 _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_1  21 happyReduction_45
happyReduction_45 (HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn21
		 (Variable happy_var_1 <$ happy_var_1
	)
happyReduction_45 _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_3  21 happyReduction_46
happyReduction_46 _
	(HappyAbsSyn14  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn21
		 (LitMatrix happy_var_2 <$ happy_var_1
	)
happyReduction_46 _ _ _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_3  21 happyReduction_47
happyReduction_47 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (ExpBinary (OpSum <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_47 _ _ _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_3  21 happyReduction_48
happyReduction_48 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (ExpBinary (OpDiff <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_48 _ _ _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_3  21 happyReduction_49
happyReduction_49 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (ExpBinary (OpMul <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_49 _ _ _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_3  21 happyReduction_50
happyReduction_50 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (ExpBinary (OpDivEnt <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_50 _ _ _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_3  21 happyReduction_51
happyReduction_51 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (ExpBinary (OpModEnt <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_51 _ _ _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_3  21 happyReduction_52
happyReduction_52 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (ExpBinary (OpDiv <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_52 _ _ _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_3  21 happyReduction_53
happyReduction_53 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (ExpBinary (OpMod <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_53 _ _ _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_3  21 happyReduction_54
happyReduction_54 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (ExpBinary (OpCruzSum <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_54 _ _ _  = notHappyAtAll 

happyReduce_55 = happySpecReduce_3  21 happyReduction_55
happyReduction_55 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (ExpBinary (OpCruzDiff <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_55 _ _ _  = notHappyAtAll 

happyReduce_56 = happySpecReduce_3  21 happyReduction_56
happyReduction_56 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (ExpBinary (OpCruzMul <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_56 _ _ _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_3  21 happyReduction_57
happyReduction_57 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (ExpBinary (OpCruzDivEnt <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_57 _ _ _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_3  21 happyReduction_58
happyReduction_58 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (ExpBinary (OpCruzModEnt <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_58 _ _ _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_3  21 happyReduction_59
happyReduction_59 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (ExpBinary (OpCruzDiv <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_59 _ _ _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_3  21 happyReduction_60
happyReduction_60 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (ExpBinary (OpCruzMod <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_60 _ _ _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_3  21 happyReduction_61
happyReduction_61 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (ExpBinary (OpOr <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_61 _ _ _  = notHappyAtAll 

happyReduce_62 = happySpecReduce_3  21 happyReduction_62
happyReduction_62 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (ExpBinary (OpAnd <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_62 _ _ _  = notHappyAtAll 

happyReduce_63 = happySpecReduce_3  21 happyReduction_63
happyReduction_63 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (ExpBinary (OpEqual <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_63 _ _ _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_3  21 happyReduction_64
happyReduction_64 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (ExpBinary (OpUnequal <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_64 _ _ _  = notHappyAtAll 

happyReduce_65 = happySpecReduce_3  21 happyReduction_65
happyReduction_65 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (ExpBinary (OpLess <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_65 _ _ _  = notHappyAtAll 

happyReduce_66 = happySpecReduce_3  21 happyReduction_66
happyReduction_66 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (ExpBinary (OpLessEq <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_66 _ _ _  = notHappyAtAll 

happyReduce_67 = happySpecReduce_3  21 happyReduction_67
happyReduction_67 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (ExpBinary (OpGreat <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_67 _ _ _  = notHappyAtAll 

happyReduce_68 = happySpecReduce_3  21 happyReduction_68
happyReduction_68 (HappyAbsSyn21  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (ExpBinary (OpGreatEq <$ happy_var_2) happy_var_1 happy_var_3 <$ happy_var_1
	)
happyReduction_68 _ _ _  = notHappyAtAll 

happyReduce_69 = happySpecReduce_2  21 happyReduction_69
happyReduction_69 (HappyTerminal happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (ExpUnary (OpTranspose <$ happy_var_2) happy_var_1 <$ happy_var_1
	)
happyReduction_69 _ _  = notHappyAtAll 

happyReduce_70 = happySpecReduce_2  21 happyReduction_70
happyReduction_70 (HappyAbsSyn21  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn21
		 (ExpUnary (OpNegative <$ happy_var_1) happy_var_2 <$ happy_var_1
	)
happyReduction_70 _ _  = notHappyAtAll 

happyReduce_71 = happyReduce 4 21 happyReduction_71
happyReduction_71 (_ `HappyStk`
	(HappyAbsSyn12  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn21
		 (Proy happy_var_1 happy_var_3 <$ happy_var_1
	) `HappyStk` happyRest

happyReduce_72 = happySpecReduce_2  21 happyReduction_72
happyReduction_72 (HappyAbsSyn21  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn21
		 (ExpUnary (OpNot <$ happy_var_1) happy_var_2 <$ happy_var_1
	)
happyReduction_72 _ _  = notHappyAtAll 

happyReduce_73 = happySpecReduce_3  21 happyReduction_73
happyReduction_73 _
	(HappyAbsSyn21  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn21
		 (lexInfo happy_var_2 <$ happy_var_1
	)
happyReduction_73 _ _ _  = notHappyAtAll 

happyNewToken action sts stk
	= lexWrap(\tk -> 
	let cont i = action i i tk (HappyState action) sts stk in
	case tk of {
	Lex TkEOF _ -> action 82 82 tk (HappyState action) sts stk;
	Lex TkProgram      _ -> cont 22;
	Lex TkBegin        _ -> cont 23;
	Lex TkEnd          _ -> cont 24;
	Lex TkFunction     _ -> cont 25;
	Lex TkReturn       _ -> cont 26;
	Lex TkSemicolon    _ -> cont 27;
	Lex TkComma        _ -> cont 28;
	Lex TkDoublePoint  _ -> cont 29;
	Lex TkBooleanType  _ -> cont 30;
	Lex TkNumberType   _ -> cont 31;
	Lex TkMatrixType   _ -> cont 32;
	Lex TkRowType      _ -> cont 33;
	Lex TkColType      _ -> cont 34;
	Lex TkLParen       _ -> cont 35;
	Lex TkRParen       _ -> cont 36;
	Lex TkLLlaves      _ -> cont 37;
	Lex TkRLlaves      _ -> cont 38;
	Lex TkLCorche      _ -> cont 39;
	Lex TkRCorche      _ -> cont 40;
	Lex TkIf           _ -> cont 41;
	Lex TkElse         _ -> cont 42;
	Lex TkThen         _ -> cont 43;
	Lex TkFor          _ -> cont 44;
	Lex TkDo           _ -> cont 45;
	Lex TkWhile        _ -> cont 46;
	Lex TkPrint        _ -> cont 47;
	Lex TkRead         _ -> cont 48;
	Lex TkAnd          _ -> cont 49;
	Lex TkOr           _ -> cont 50;
	Lex TkNot          _ -> cont 51;
	Lex TkEqual        _ -> cont 52;
	Lex TkUnequal      _ -> cont 53;
	Lex TkLessEq       _ -> cont 54;
	Lex TkLess         _ -> cont 55;
	Lex TkGreatEq      _ -> cont 56;
	Lex TkGreat        _ -> cont 57;
	Lex TkSum          _ -> cont 58;
	Lex TkDiff         _ -> cont 59;
	Lex TkMul          _ -> cont 60;
	Lex TkDivEnt       _ -> cont 61;
	Lex TkModEnt       _ -> cont 62;
	Lex TkDiv          _ -> cont 63;
	Lex TkMod          _ -> cont 64;
	Lex TkTrans        _ -> cont 65;
	Lex TkCruzSum      _ -> cont 66;
	Lex TkCruzDiff     _ -> cont 67;
	Lex TkCruzMul      _ -> cont 68;
	Lex TkCruzDivEnt   _ -> cont 69;
	Lex TkCruzModEnt   _ -> cont 70;
	Lex TkCruzDiv      _ -> cont 71;
	Lex TkCruzMod      _ -> cont 72;
	Lex TkAssign       _ -> cont 73;
	Lex TkUse          _ -> cont 74;
	Lex TkIn           _ -> cont 75;
	Lex TkSet          _ -> cont 76;
	Lex (TkNumber _)   _ -> cont 77;
	Lex (TkBoolean _)  _ -> cont 78;
	Lex (TkBoolean _)  _ -> cont 79;
	Lex (TkString _)   _ -> cont 80;
	Lex (TkId     _)   _ -> cont 81;
	_ -> happyError' tk
	})

happyError_ 82 tk = happyError' tk
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


data Program = Program StatementSeq StatementSeq

instance Show Program where
    show (Program funS stB) = concatMap ((++) "\n" . show . lexInfo) funS ++ "\nprogram\n\t" ++ concatMap ((++) "\n" . show . lexInfo) stB ++ "\nend"

type DeclarationSeq = Seq (Lexeme Declaration)    

data Declaration 
    = Dcl (Lexeme TypeId) (Lexeme Identifier)
    | DclInit (Lexeme TypeId) (Lexeme Identifier) (Lexeme Expression)

instance Show Declaration where
    show dcl = case dcl of
         Dcl tL idL -> show (lexInfo tL) ++ "  " ++ lexInfo idL
         DclInit tL idL expL -> show (lexInfo tL) ++ "  " ++ lexInfo idL ++ "= " ++ show (lexInfo expL) 

type Identifier = String

data TypeId 
    = Bool 
    | Double
    | Matrix (Seq (Lexeme Expression))
    | Row (Lexeme Expression)
    | Col (Lexeme Expression)

instance Show TypeId where
    show t = case t of
        Bool -> "Bool"
        Double -> "Number"
        Matrix expLs -> "Matrix("  ++ concatMap (show . lexInfo) expLs ++ ")"
        Row exp -> "Row(" ++ show (lexInfo exp) ++ ")"
        Col exp -> "Col(" ++ show (lexInfo exp) ++ ")"

type StatementSeq = Seq (Lexeme Statement)

data Statement
    = StNoop
    | StAssign (Lexeme Access) (Lexeme Expression)
    | StFunctionDef (Lexeme Identifier) DeclarationSeq (Lexeme TypeId) StatementSeq
    | StFunctionCall (Lexeme Identifier) (Seq (Lexeme Expression))
    | StReturn (Lexeme Expression)
    | StRead (Lexeme Access)
    | StPrint (Lexeme Expression)
    | StPrintList (Seq (Lexeme Expression))
    | StIf (Lexeme Expression) StatementSeq StatementSeq
    | StFor (Lexeme Identifier) (Lexeme Expression) StatementSeq
    | StWhile (Lexeme Expression) StatementSeq
    | StBlock DeclarationSeq StatementSeq

instance Show Statement where
    show st = case st of
        StAssign accL expL -> "set " ++ show (lexInfo accL) ++ " = " ++ show (lexInfo expL)
        StFunctionDef idnL _ _ _ -> "function " ++ lexInfo idnL
        StFunctionCall idnL expLs -> lexInfo idnL ++ "(" ++ concatMap (show . lexInfo) expLs ++ ")"
        StReturn expL -> "return " ++ show (lexInfo expL)
        StRead accL -> "read " ++ show (lexInfo accL)
        StPrint expL -> "print " ++ show (lexInfo expL)
        StIf expL _ _ -> "if " ++ show (lexInfo expL) ++ " then .. end"
        StFor idnL expL _ -> "for " ++ lexInfo idnL ++ " in " ++ show (lexInfo expL) ++ " do .. end"
        StWhile expL _ -> "while " ++ show (lexInfo expL) ++ "do .. end"
        StBlock dclLs stLs -> "\tuse\n\t" ++ concatMap ((++) "\n\t\t" . show . lexInfo) dclLs ++ 
                             "\n\tin\n\t " ++  concatMap ( (++) "\n\t\t" . show . lexInfo) stLs ++ "\n\tend"

data Expression
    = LitNumber (Lexeme Double)
    | LitBool (Lexeme Bool)
    | LitString (Lexeme String)
    | Variable (Lexeme Access)
    | LitMatrix [Seq (Lexeme Expression)]
    | Proy (Lexeme Expression) (Seq (Lexeme Expression))
    | ExpBinary (Lexeme Binary) (Lexeme Expression) (Lexeme Expression)
    | ExpUnary (Lexeme Unary) (Lexeme Expression)

instance Show Expression where
    show exp = case exp of
        LitNumber vL -> show (lexInfo vL)
        LitBool vL -> show (lexInfo vL)
        LitString strL -> show (lexInfo strL)
        Variable accL -> show (lexInfo accL)
        LitMatrix expS -> "{ Literal matricial }"
        Proy expL expLs -> show (lexInfo expL) ++ "[" ++ concatMap (show . lexInfo) expLs ++ "]"        
        ExpBinary opL lExpL rExpL -> show (lexInfo lExpL) ++ " " ++ show (lexInfo opL) ++ " " ++ show (lexInfo rExpL)
        ExpUnary opL expL -> show (lexInfo opL) ++ " " ++ show (lexInfo expL)

data Binary
    = OpSum | OpDiff | OpMul | OpDivEnt | OpModEnt | OpDiv | OpMod
    | OpCruzSum | OpCruzDiff | OpCruzMul | OpCruzDivEnt | OpCruzModEnt
    | OpCruzDiv | OpCruzMod
    | OpEqual | OpUnequal | OpLess | OpLessEq | OpGreat | OpGreatEq
    | OpOr | OpAnd

instance Show Binary where
    show bexp = case bexp of
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

data Unary 
    = OpNegative
    | OpNot
    | OpTranspose

instance Show Unary where
    show uexp = case uexp of
        OpNegative   -> "-"
        OpNot        -> "not"
        OpTranspose  -> "transpose"

data Access 
    = VariableAccess (Lexeme Identifier)

instance Show Access where
    show acc = case acc of
        VariableAccess idnL -> lexInfo idnL

expandStatement :: Lexeme Statement -> StatementSeq
expandStatement stL = case lexInfo stL of
    StNoop -> empty
    StPrintList exps -> fmap (\exp -> StPrint exp <$ stL) exps
    _ -> singleton stL

lexWrap :: (Lexeme Token -> Alex a) -> Alex a
lexWrap = (alexMonadScanTokens >>=)

parseError :: Lexeme Token -> Alex a
parseError (Lex t p) = fail $ "Error de Sintaxis, Token: " ++ show t ++ " " ++ showPosn p ++ "\n"

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
