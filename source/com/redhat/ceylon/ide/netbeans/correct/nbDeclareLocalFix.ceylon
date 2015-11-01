import com.redhat.ceylon.ide.common.correct {
    DeclareLocalQuickFix
}
import org.openide.filesystems {
    FileObject
}
import javax.swing.text {
    Document
}
import com.redhat.ceylon.ide.netbeans.complete {
    CeylonCompletionItem
}
import org.netbeans.api.project {
    Project
}
import com.redhat.ceylon.ide.common.refactoring {
    DefaultRegion
}
import com.redhat.ceylon.compiler.typechecker.tree {
    Tree
}
import org.netbeans.spi.editor.hints {
    Fix,
    ChangeInfo
}

// TODO linked mode
object nbDeclareLocalFix
        satisfies DeclareLocalQuickFix<FileObject,Document,InsertEdit,TextEdit,TextChange,Object,CeylonCompletionItem,Project,NbQuickFixData,DefaultRegion>
                & NbDocumentChanges
                & AbstractFix {
    
    shared actual void addEditableRegion(Object lm, Document doc, Integer start, Integer len, Integer exitSeqNumber, CeylonCompletionItem[] proposals) {}
    
    shared actual void installLinkedMode(Document doc, Object lm, Object owner, Integer exitSeqNumber, Integer exitPosition) {}

    shared actual Object newLinkedMode() => "";
    
    shared actual void newDeclareLocalQuickFix(NbQuickFixData data, String desc,
        TextChange change, Tree.Term term, Tree.BaseMemberExpression bme) {
        
        data.fixes.add(object satisfies Fix {
            shared actual ChangeInfo implement() {
                change.applyChanges();
                return ChangeInfo();
            }
            
            shared actual String text => desc;
        });
    }
}
