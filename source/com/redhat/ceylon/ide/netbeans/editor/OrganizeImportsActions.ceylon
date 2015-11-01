import org.netbeans.editor {
    BaseAction
}
import java.awt.event {
    ActionEvent
}
import javax.swing.text {
    JTextComponent,
    Document
}
import com.redhat.ceylon.ide.common.imports {
    AbstractImportsCleaner
}
import com.redhat.ceylon.ide.netbeans.correct {
    InsertEdit,
    TextEdit,
    TextChange,
    NbDocumentChanges,
    nbIndents
}
import com.redhat.ceylon.ide.common.util {
    Indents
}
import com.redhat.ceylon.ide.netbeans.model {
    CeylonParseController
}
import com.redhat.ceylon.model.typechecker.model {
    Declaration
}

shared class OrganizeImportsActions() extends BaseAction()
        satisfies AbstractImportsCleaner<Document, InsertEdit, TextEdit, TextChange>
                & NbDocumentChanges {
    
    shared actual void actionPerformed(ActionEvent actionEvent, JTextComponent comp) {
        value cpc = CeylonParseController.get(comp.document);
        value change = TextChange(comp.document);
        cleanImports(cpc.lastCompilationUnit, comp.document, change);
        
        change.applyChanges();
    }
    
    shared actual String getDocContent(Document doc, Integer start, Integer length)
            => doc.getText(start, length);
    
    shared actual Indents<Document> indents => nbIndents;
    
    shared actual Declaration? select(List<Declaration> proposals)
            => proposals.first; // TODO
    
}
