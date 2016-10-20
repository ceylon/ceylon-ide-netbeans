import com.redhat.ceylon.ide.common.imports {
	AbstractImportsCleaner
}
import com.redhat.ceylon.ide.netbeans.model {
	findParseController
}
import com.redhat.ceylon.model.typechecker.model {
	Declaration
}

import java.awt.event {
	ActionEvent
}

import javax.swing.text {
	JTextComponent
}

import org.netbeans.api.editor {
	editorActionRegistration
}
import org.netbeans.editor {
	BaseAction
}

editorActionRegistration { 
	name = "Organize Imports";
	mimeType = "text/x-ceylon";
	menuPath = "Source";
	menuPosition = 2340;
	menuText = "Organize Imports"; 
}
shared class OrganizeImportsActions() extends BaseAction()
        satisfies AbstractImportsCleaner {
    
    shared actual void actionPerformed(ActionEvent actionEvent, JTextComponent comp) {
        if (exists cpc = findParseController(comp.document),
            exists lastAnalysis = cpc.lastAnalysis) {
            
            cleanImports(lastAnalysis.lastCompilationUnit, cpc.commonDocument);
        }
    }
    
    shared actual Declaration? select(List<Declaration> proposals)
            => proposals.first; // TODO
    
}
