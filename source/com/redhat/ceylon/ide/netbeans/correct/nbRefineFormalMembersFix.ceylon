import com.redhat.ceylon.ide.common.correct {
    RefineFormalMembersQuickFix
}
import org.openide.filesystems {
    FileObject
}
import javax.swing.text {
    Document
}
import com.redhat.ceylon.ide.common.refactoring {
    DefaultRegion
}
import org.netbeans.api.project {
    Project
}
import com.redhat.ceylon.ide.netbeans.complete {
    CeylonCompletionItem
}
import org.netbeans.spi.editor.hints {
    Fix,
    ChangeInfo
}
import org.netbeans.api.editor {
    EditorRegistry
}

object nbRefineFormalMembersFix
        satisfies RefineFormalMembersQuickFix<FileObject,Document,InsertEdit,TextEdit,TextChange,DefaultRegion,Project,NbQuickFixData,CeylonCompletionItem>
                & NbDocumentChanges
                & AbstractFix {
    
    shared actual Character getDocChar(Document doc, Integer offset)
            => doc.getText(offset, 1).first else ' ';
    
    shared actual void newRefineFormalMembersProposal(NbQuickFixData data, String desc) {
        data.fixes.add(object satisfies Fix {
            shared actual ChangeInfo? implement() {
                value editor = EditorRegistry.focusedComponent();
                if (exists change = refineFormalMembers(data, editor.document, editor.caretPosition)) {
                    change.applyChanges();
                }
                return null;
            }
            
            shared actual String text => desc;
        });
    }
}
