import com.redhat.ceylon.ide.netbeans.editor {
    CeylonSemanticAnalyzer,
    codeFormatter
}
import com.redhat.ceylon.ide.netbeans.structure {
    ceylonStructureScanner
}

import org.netbeans.api.lexer {
    Language
}
import org.netbeans.modules.csl.spi {
    DefaultLanguageConfig,
	languageRegistration
}
import org.netbeans.modules.csl.api {
    StructureScanner,
    Formatter
}

shared String mimeType = "text/x-ceylon";

languageRegistration {
	mimeType = {"text/x-ceylon"};
}
shared class CeylonLanguage() extends DefaultLanguageConfig() {
    
    shared default actual Language<CeylonTokenId> lexerLanguage
            => ceylonLanguageHierarchy.language();
    
    shared default actual NBCeylonParser parser => NBCeylonParser();

    displayName => "Ceylon";
    
    hasStructureScanner() => true;
    shared default actual StructureScanner structureScanner
            => ceylonStructureScanner;
    
    shared actual CeylonSemanticAnalyzer semanticAnalyzer
            => CeylonSemanticAnalyzer();
    
    hasFormatter() => true;
    shared default actual Formatter formatter => codeFormatter;
}
