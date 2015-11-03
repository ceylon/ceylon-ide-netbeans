package com.redhat.ceylon.ide.netbeans.lang;

import com.redhat.ceylon.ide.netbeans.editor.CeylonSemanticAnalyzer;
import com.redhat.ceylon.ide.netbeans.editor.codeFormatter_;
import com.redhat.ceylon.ide.netbeans.structure.ceylonStructureScanner_;
import org.netbeans.api.lexer.Language;
import org.netbeans.modules.csl.api.Formatter;
import org.netbeans.modules.csl.api.SemanticAnalyzer;
import org.netbeans.modules.csl.api.StructureScanner;
import org.netbeans.modules.csl.spi.DefaultLanguageConfig;
import org.netbeans.modules.csl.spi.LanguageRegistration;
import org.netbeans.modules.parsing.spi.Parser;

@LanguageRegistration(mimeType = AnnotatedCeylonLanguage.MIME_TYPE)
public class AnnotatedCeylonLanguage extends DefaultLanguageConfig {
    public static final String MIME_TYPE = "text/x-ceylon";

    @Override
    public Language getLexerLanguage() {
        return ceylonLanguageHierarchy_.get_().language();
    }   

    @Override
    public Parser getParser() {
        return new NBCeylonParser();
    }

    @Override
    public String getDisplayName() {
        return "Ceylon";
    }

    @Override
    public boolean hasStructureScanner() {
        return true;
    }

    @Override
    public StructureScanner getStructureScanner() {
        return ceylonStructureScanner_.get_();
    }

    @Override
    public SemanticAnalyzer getSemanticAnalyzer() {
        return new CeylonSemanticAnalyzer();
    }

    @Override
    public boolean hasFormatter() {
        return true;
    }

    @Override
    public Formatter getFormatter() {
        return codeFormatter_.get_();
    }
}
