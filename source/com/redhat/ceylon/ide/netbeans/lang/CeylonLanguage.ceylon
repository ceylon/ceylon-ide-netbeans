import com.redhat.ceylon.ide.netbeans.editor {
	CeylonSemanticAnalyzer,
	codeFormatter
}
import com.redhat.ceylon.ide.netbeans.structure {
	ceylonStructureScanner
}

import org.netbeans.modules.csl.spi {
	DefaultLanguageConfig,
	languageRegistration
}

shared String mimeType = "text/x-ceylon";

languageRegistration {
	mimeType = {"text/x-ceylon"};
}
shared class CeylonLanguage() extends DefaultLanguageConfig() {
    
    lexerLanguage => ceylonLanguageHierarchy.language();
    parser => NBCeylonParser();
    displayName => "Ceylon";
    hasStructureScanner() => true;
    structureScanner => ceylonStructureScanner;
    semanticAnalyzer => CeylonSemanticAnalyzer();
    hasFormatter() => true;
    formatter => codeFormatter;
}
