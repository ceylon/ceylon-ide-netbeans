import ceylon.collection {
	HashMap
}
import ceylon.interop.java {
	CeylonIterable
}

import com.redhat.ceylon.compiler.typechecker.parser {
	CeylonLexer
}

import java.util {
	Collection,
	Arrays
}

import org.netbeans.spi.lexer {
	LanguageHierarchy,
	LexerRestartInfo
}

shared object ceylonLanguageHierarchy extends LanguageHierarchy<CeylonTokenId>() {
    
    shared Integer badToken = 1337;
    
    Collection<CeylonTokenId> tokens = Arrays.asList(
        CeylonTokenId("ADD_SPECIFY", "other", CeylonLexer.\iADD_SPECIFY),
        CeylonTokenId("AIDENTIFIER", "other", CeylonLexer.\iAIDENTIFIER),
        CeylonTokenId("ALIAS", "keyword", CeylonLexer.\iALIAS),
        CeylonTokenId("AND_OP", "other", CeylonLexer.\iAND_OP),
        CeylonTokenId("AND_SPECIFY", "other", CeylonLexer.\iAND_SPECIFY),
        CeylonTokenId("ASSEMBLY", "keyword", CeylonLexer.\iASSEMBLY),
        CeylonTokenId("ASSERT", "keyword", CeylonLexer.\iASSERT),
        CeylonTokenId("ASSIGN", "keyword", CeylonLexer.\iASSIGN),
        CeylonTokenId("ASTRING_LITERAL", "annotationStringAttribute", CeylonLexer.\iASTRING_LITERAL),
        CeylonTokenId("AVERBATIM_STRING", "annotationStringAttribute", CeylonLexer.\iAVERBATIM_STRING),
        CeylonTokenId("BACKTICK", "typeLiteralAttribute", CeylonLexer.\iBACKTICK),
        CeylonTokenId("BREAK", "keyword", CeylonLexer.\iBREAK),
        CeylonTokenId("BinaryDigit", "other", CeylonLexer.\iBinaryDigit),
        CeylonTokenId("BinaryDigits", "other", CeylonLexer.\iBinaryDigits),
        CeylonTokenId("CASE_CLAUSE", "keyword", CeylonLexer.\iCASE_CLAUSE),
        CeylonTokenId("CASE_TYPES", "keyword", CeylonLexer.\iCASE_TYPES),
        CeylonTokenId("CATCH_CLAUSE", "keyword", CeylonLexer.\iCATCH_CLAUSE),
        CeylonTokenId("CHAR_LITERAL", "charAttribute", CeylonLexer.\iCHAR_LITERAL),
        CeylonTokenId("CLASS_DEFINITION", "keyword", CeylonLexer.\iCLASS_DEFINITION),
        CeylonTokenId("COMMA", "other", CeylonLexer.\iCOMMA),
        CeylonTokenId("COMPARE_OP", "other", CeylonLexer.\iCOMPARE_OP),
        CeylonTokenId("COMPILER_ANNOTATION", "other", CeylonLexer.\iCOMPILER_ANNOTATION),
        CeylonTokenId("COMPLEMENT_OP", "other", CeylonLexer.\iCOMPLEMENT_OP),
        CeylonTokenId("COMPLEMENT_SPECIFY", "other", CeylonLexer.\iCOMPLEMENT_SPECIFY),
        CeylonTokenId("COMPUTE", "other", CeylonLexer.\iCOMPUTE),
        CeylonTokenId("CONTINUE", "keyword", CeylonLexer.\iCONTINUE),
        CeylonTokenId("CharPart", "other", CeylonLexer.\iCharPart),
        CeylonTokenId("DECREMENT_OP", "other", CeylonLexer.\iDECREMENT_OP),
        CeylonTokenId("DIFFERENCE_OP", "other", CeylonLexer.\iDIFFERENCE_OP),
        CeylonTokenId("DIVIDE_SPECIFY", "other", CeylonLexer.\iDIVIDE_SPECIFY),
        CeylonTokenId("DYNAMIC", "keyword", CeylonLexer.\iDYNAMIC),
        CeylonTokenId("Digit", "other", CeylonLexer.\iDigit),
        CeylonTokenId("Digits", "other", CeylonLexer.\iDigits),
        CeylonTokenId("ELLIPSIS", "other", CeylonLexer.\iELLIPSIS),
        CeylonTokenId("ELSE_CLAUSE", "keyword", CeylonLexer.\iELSE_CLAUSE),
        CeylonTokenId("ENTRY_OP", "other", CeylonLexer.\iENTRY_OP),
        CeylonTokenId("EQUAL_OP", "other", CeylonLexer.\iEQUAL_OP),
        CeylonTokenId("EXISTS", "keyword", CeylonLexer.\iEXISTS),
        CeylonTokenId("EXTENDS", "keyword", CeylonLexer.\iEXTENDS),
        CeylonTokenId("EscapeSequence", "other", CeylonLexer.\iEscapeSequence),
        CeylonTokenId("Exponent", "other", CeylonLexer.\iExponent),
        CeylonTokenId("FINALLY_CLAUSE", "keyword", CeylonLexer.\iFINALLY_CLAUSE),
        CeylonTokenId("FLOAT_LITERAL", "numberAttribute", CeylonLexer.\iFLOAT_LITERAL),
        CeylonTokenId("FOR_CLAUSE", "keyword", CeylonLexer.\iFOR_CLAUSE),
        CeylonTokenId("FUNCTION_MODIFIER", "keyword", CeylonLexer.\iFUNCTION_MODIFIER),
        CeylonTokenId("FractionalMagnitude", "other", CeylonLexer.\iFractionalMagnitude),
        CeylonTokenId("IDENTICAL_OP", "other", CeylonLexer.\iIDENTICAL_OP),
        CeylonTokenId("IF_CLAUSE", "keyword", CeylonLexer.\iIF_CLAUSE),
        CeylonTokenId("IMPORT", "keyword", CeylonLexer.\iIMPORT),
        CeylonTokenId("INCREMENT_OP", "other", CeylonLexer.\iINCREMENT_OP),
        CeylonTokenId("INTERFACE_DEFINITION", "keyword", CeylonLexer.\iINTERFACE_DEFINITION),
        CeylonTokenId("INTERSECTION_OP", "other", CeylonLexer.\iINTERSECTION_OP),
        CeylonTokenId("INTERSECT_SPECIFY", "other", CeylonLexer.\iINTERSECT_SPECIFY),
        CeylonTokenId("IN_OP", "keyword", CeylonLexer.\iIN_OP),
        CeylonTokenId("IS_OP", "keyword", CeylonLexer.\iIS_OP),
        CeylonTokenId("IdentifierPart", "other", CeylonLexer.\iIdentifierPart),
        CeylonTokenId("IdentifierStart", "other", CeylonLexer.\iIdentifierStart),
        CeylonTokenId("LARGER_OP", "other", CeylonLexer.\iLARGER_OP),
        CeylonTokenId("LARGE_AS_OP", "other", CeylonLexer.\iLARGE_AS_OP),
        CeylonTokenId("LBRACE", "braceAttribute", CeylonLexer.\iLBRACE),
        CeylonTokenId("LBRACKET", "other", CeylonLexer.\iLBRACKET),
        CeylonTokenId("LET", "keyword", CeylonLexer.\iLET),
        CeylonTokenId("LIDENTIFIER", "identifierAttribute", CeylonLexer.\iLIDENTIFIER),
        CeylonTokenId("LINE_COMMENT", "comment", CeylonLexer.\iLINE_COMMENT),
        CeylonTokenId("LIdentifierPrefix", "identifierAttribute", CeylonLexer.\iLIdentifierPrefix),
        CeylonTokenId("LPAREN", "other", CeylonLexer.\iLPAREN),
        CeylonTokenId("Letter", "other", CeylonLexer.\iLetter),
        CeylonTokenId("MEMBER_OP", "other", CeylonLexer.\iMEMBER_OP),
        CeylonTokenId("MODULE", "keyword", CeylonLexer.\iMODULE),
        CeylonTokenId("MULTIPLY_SPECIFY", "other", CeylonLexer.\iMULTIPLY_SPECIFY),
        CeylonTokenId("MULTI_COMMENT", "comment", CeylonLexer.\iMULTI_COMMENT),
        CeylonTokenId("Magnitude", "other", CeylonLexer.\iMagnitude),
        CeylonTokenId("NATURAL_LITERAL", "numberAttribute", CeylonLexer.\iNATURAL_LITERAL),
        CeylonTokenId("NEW", "keyword", CeylonLexer.\iNEW),
        CeylonTokenId("NONEMPTY", "keyword", CeylonLexer.\iNONEMPTY),
        CeylonTokenId("NOT_EQUAL_OP", "other", CeylonLexer.\iNOT_EQUAL_OP),
        CeylonTokenId("NOT_OP", "other", CeylonLexer.\iNOT_OP),
        CeylonTokenId("OBJECT_DEFINITION", "keyword", CeylonLexer.\iOBJECT_DEFINITION),
        CeylonTokenId("OPTIONAL", "other", CeylonLexer.\iOPTIONAL),
        CeylonTokenId("OR_OP", "other", CeylonLexer.\iOR_OP),
        CeylonTokenId("OR_SPECIFY", "other", CeylonLexer.\iOR_SPECIFY),
        CeylonTokenId("OUT", "keyword", CeylonLexer.\iOUT),
        CeylonTokenId("OUTER", "keyword", CeylonLexer.\iOUTER),
        CeylonTokenId("PACKAGE", "keyword", CeylonLexer.\iPACKAGE),
        CeylonTokenId("PIDENTIFIER", "other", CeylonLexer.\iPIDENTIFIER),
        CeylonTokenId("POWER_OP", "other", CeylonLexer.\iPOWER_OP),
        CeylonTokenId("PRODUCT_OP", "other", CeylonLexer.\iPRODUCT_OP),
        CeylonTokenId("QUOTIENT_OP", "other", CeylonLexer.\iQUOTIENT_OP),
        CeylonTokenId("RANGE_OP", "other", CeylonLexer.\iRANGE_OP),
        CeylonTokenId("RBRACE", "braceAttribute", CeylonLexer.\iRBRACE),
        CeylonTokenId("RBRACKET", "other", CeylonLexer.\iRBRACKET),
        CeylonTokenId("REMAINDER_OP", "other", CeylonLexer.\iREMAINDER_OP),
        CeylonTokenId("REMAINDER_SPECIFY", "other", CeylonLexer.\iREMAINDER_SPECIFY),
        CeylonTokenId("RETURN", "keyword", CeylonLexer.\iRETURN),
        CeylonTokenId("RPAREN", "other", CeylonLexer.\iRPAREN),
        CeylonTokenId("SAFE_MEMBER_OP", "other", CeylonLexer.\iSAFE_MEMBER_OP),
        CeylonTokenId("SATISFIES", "keyword", CeylonLexer.\iSATISFIES),
        CeylonTokenId("SCALE_OP", "other", CeylonLexer.\iSCALE_OP),
        CeylonTokenId("SEGMENT_OP", "semiAttribute", CeylonLexer.\iSEGMENT_OP),
        CeylonTokenId("SEMICOLON", "semiAttribute", CeylonLexer.\iSEMICOLON),
        CeylonTokenId("SMALLER_OP", "other", CeylonLexer.\iSMALLER_OP),
        CeylonTokenId("SMALL_AS_OP", "other", CeylonLexer.\iSMALL_AS_OP),
        CeylonTokenId("SPECIFY", "other", CeylonLexer.\iSPECIFY),
        CeylonTokenId("SPREAD_OP", "other", CeylonLexer.\iSPREAD_OP),
        CeylonTokenId("STRING_END", "stringAttribute", CeylonLexer.\iSTRING_END),
        CeylonTokenId("STRING_LITERAL", "stringAttribute", CeylonLexer.\iSTRING_LITERAL),
        CeylonTokenId("STRING_MID", "stringAttribute", CeylonLexer.\iSTRING_MID),
        CeylonTokenId("STRING_START", "stringAttribute", CeylonLexer.\iSTRING_START),
        CeylonTokenId("SUBTRACT_SPECIFY", "other", CeylonLexer.\iSUBTRACT_SPECIFY),
        CeylonTokenId("SUM_OP", "other", CeylonLexer.\iSUM_OP),
        CeylonTokenId("SUPER", "keyword", CeylonLexer.\iSUPER),
        CeylonTokenId("SWITCH_CLAUSE", "keyword", CeylonLexer.\iSWITCH_CLAUSE),
        CeylonTokenId("StringPart", "other", CeylonLexer.\iStringPart),
        CeylonTokenId("THEN_CLAUSE", "keyword", CeylonLexer.\iTHEN_CLAUSE),
        CeylonTokenId("THIS", "keyword", CeylonLexer.\iTHIS),
        CeylonTokenId("THROW", "keyword", CeylonLexer.\iTHROW),
        CeylonTokenId("TRY_CLAUSE", "keyword", CeylonLexer.\iTRY_CLAUSE),
        CeylonTokenId("TYPE_CONSTRAINT", "keyword", CeylonLexer.\iTYPE_CONSTRAINT),
        CeylonTokenId("UIDENTIFIER", "typeAttribute", CeylonLexer.\iUIDENTIFIER),
        CeylonTokenId("UIdentifierPrefix", "other", CeylonLexer.\iUIdentifierPrefix),
        CeylonTokenId("UNION_OP", "other", CeylonLexer.\iUNION_OP),
        CeylonTokenId("UNION_SPECIFY", "other", CeylonLexer.\iUNION_SPECIFY),
        CeylonTokenId("VALUE_MODIFIER", "keyword", CeylonLexer.\iVALUE_MODIFIER),
        CeylonTokenId("VERBATIM_STRING", "stringAttribute", CeylonLexer.\iVERBATIM_STRING),
        CeylonTokenId("VOID_MODIFIER", "keyword", CeylonLexer.\iVOID_MODIFIER),
        CeylonTokenId("WHILE_CLAUSE", "keyword", CeylonLexer.\iWHILE_CLAUSE),
        CeylonTokenId("WS", "whitespace", CeylonLexer.\iWS),
        CeylonTokenId("BAD_TOKEN", "badcode", badToken)
    );
    
    value tokensById = HashMap {
        entries => CeylonIterable(tokens).map((tok) => tok.ordinal() -> tok);
     };
    
    shared CeylonTokenId? getToken(Integer id)
            => tokensById.get(id);
    
    createLexer(LexerRestartInfo<CeylonTokenId> info)
            => NbCeylonLexer(info);
    
    createTokenIds()
             => tokens;
    
    mimeType() => package.mimeType;
}
