import com.redhat.ceylon.ide.common.correct {
    ChangeReferenceQuickFix
}
import org.openide.filesystems {
    FileObject
}
import org.netbeans.api.project {
    Project
}
import javax.swing.text {
    Document
}
import com.redhat.ceylon.ide.netbeans.complete {
    CeylonCompletionItem
}
import com.redhat.ceylon.ide.common.refactoring {
    DefaultRegion
}
import org.netbeans.spi.editor.hints {
    Fix,
    ChangeInfo
}

object nbChangeReferenceFix
        satisfies ChangeReferenceQuickFix<FileObject,Project,Document,InsertEdit,TextEdit,TextChange,NbQuickFixData,DefaultRegion,CeylonCompletionItem> 
                & NbDocumentChanges
                & AbstractFix {
    
    shared actual void newChangeReferenceProposal(NbQuickFixData data, String desc,
        TextChange change, DefaultRegion selection) {
        
        data.fixes.add(object satisfies Fix {
            shared actual ChangeInfo implement() {
                change.applyChanges();
                return ChangeInfo();
            }
            
            shared actual String text => desc;
        });
    }
    
}
