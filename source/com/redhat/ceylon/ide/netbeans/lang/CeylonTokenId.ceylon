import org.netbeans.api.lexer {
    TokenId
}

shared class CeylonTokenId(String myName, String category, Integer myOrdinal) satisfies TokenId {
    
    name() => myName;
    
    ordinal() => myOrdinal;
    
    primaryCategory() => category;
}
