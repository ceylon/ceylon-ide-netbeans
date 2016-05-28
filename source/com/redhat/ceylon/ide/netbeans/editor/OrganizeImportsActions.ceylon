import com.redhat.ceylon.ide.common.imports {
    AbstractImportsCleaner
}
import com.redhat.ceylon.ide.netbeans.correct {
    NbDocument
}
import com.redhat.ceylon.ide.netbeans.model {
    CeylonParseController
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
        value cpc = CeylonParseController.get(comp.document);
        cleanImports(cpc.lastCompilationUnit, NbDocument(comp.document));
    }
    
    shared actual Declaration? select(List<Declaration> proposals)
            => proposals.first; // TODO
    
}
