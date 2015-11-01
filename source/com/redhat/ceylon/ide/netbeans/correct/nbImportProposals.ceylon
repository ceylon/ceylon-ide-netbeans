import com.redhat.ceylon.ide.common.correct {
    ImportProposals
}
import com.redhat.ceylon.ide.common.util {
    Indents
}
import com.redhat.ceylon.ide.netbeans.complete {
    CeylonCompletionItem
}

import javax.swing.text {
    Document,
    JTextComponent
}

import org.openide.filesystems {
    FileObject
}
import org.openide.text {
    NbDocument
}

object nbImportProposals 
        satisfies ImportProposals<FileObject, CeylonCompletionItem, Document, InsertEdit, TextEdit, TextChange>
                & NbDocumentChanges {
    
    shared actual TextChange createImportChange(FileObject file) => TextChange(NbDocument.getDocument(file));
    
    shared actual Indents<Document> indents => nbIndents;
    
    shared actual CeylonCompletionItem newImportProposal(String description, TextChange correctionChange) {
        return object extends CeylonCompletionItem(description, description, 0, "") {
            shared actual void defaultAction(JTextComponent? jtc) {
                correctionChange.applyChanges();
            }
        };
    }
}
