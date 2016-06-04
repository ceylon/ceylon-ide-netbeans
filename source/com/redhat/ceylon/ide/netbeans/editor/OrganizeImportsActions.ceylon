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

import org.netbeans.editor {
    BaseAction
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
