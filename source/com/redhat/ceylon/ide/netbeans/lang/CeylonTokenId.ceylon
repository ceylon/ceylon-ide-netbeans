import org.netbeans.api.lexer {
    TokenId
}

shared class CeylonTokenId(String myName, String category, Integer myOrdinal) satisfies TokenId {
    
    shared actual String name() => myName;
    
    shared actual Integer ordinal() => myOrdinal;
    
    shared actual String primaryCategory() => category;
}
