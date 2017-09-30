import org.eclipse.ceylon.compiler.typechecker.parser {
    CeylonLexer
}

import org.netbeans.api.lexer {
    Token,
    PartType
}
import org.netbeans.spi.lexer {
    Lexer,
    LexerRestartInfo
}

class NbCeylonLexer(LexerRestartInfo<CeylonTokenId> info) satisfies Lexer<CeylonTokenId> {
    
    value charStream = AntlrCharStream(info.input(), "Ceylon");
    value ceylonLexer = CeylonLexer(charStream);
    
    shared actual Token<CeylonTokenId>? nextToken() {
        value token = ceylonLexer.nextToken();
        Token<CeylonTokenId>? resultToken;
        
        if (token.type != CeylonLexer.eof) {
            value tokenId = ceylonLanguageHierarchy.getToken(token.type);
            resultToken = info.tokenFactory().createToken(tokenId);
        } else if (info.input().readLength() > 0) {
            value tokenId = ceylonLanguageHierarchy.getToken(ceylonLanguageHierarchy.badToken);
            resultToken = info.tokenFactory().createToken(tokenId, 
                info.input().readLength(), PartType.middle);
        } else {
            resultToken = null;
        }
        
        return resultToken;
    }
    
    release() => noop();
    
    state() => null;
}
