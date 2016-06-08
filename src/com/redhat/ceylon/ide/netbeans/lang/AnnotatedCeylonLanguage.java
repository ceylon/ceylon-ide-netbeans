package com.redhat.ceylon.ide.netbeans.lang;

import org.netbeans.api.lexer.Language;
import org.netbeans.modules.csl.api.Formatter;
import org.netbeans.modules.csl.api.StructureScanner;
import org.netbeans.modules.csl.spi.LanguageRegistration;

// That stupid annotation processor can't detect methods in superclasses,
// so we have to override some of them to correctly fill the XML layer.
@LanguageRegistration(mimeType = AnnotatedCeylonLanguage.MIME_TYPE)
public class AnnotatedCeylonLanguage extends CeylonLanguage {
    public static final String MIME_TYPE = "text/x-ceylon";
    
 
    @Override
    public StructureScanner getStructureScanner() {
        return super.getStructureScanner();
    }

    @Override
    public Language<CeylonTokenId> getLexerLanguage() {
        return super.getLexerLanguage();
    }   

    @Override
    public NBCeylonParser getParser() {
        return super.getParser();
    }
    

    @Override
    public Formatter getFormatter() {
        return super.getFormatter();
    }
}
