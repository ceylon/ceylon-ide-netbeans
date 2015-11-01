import com.redhat.ceylon.ide.common.correct {
    CreateParameterQuickFix
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
import com.redhat.ceylon.ide.common.doc {
    Icons
}
import com.redhat.ceylon.model.typechecker.model {
    Declaration,
    Type
}
import org.netbeans.spi.editor.hints {
    Fix,
    ChangeInfo
}

object nbCreateParameterFix
        satisfies CreateParameterQuickFix<FileObject,Project,Document,InsertEdit,TextEdit,TextChange,DefaultRegion,NbQuickFixData,CeylonCompletionItem>
                & NbDocumentChanges
                & AbstractFix {
    
    shared actual void newCreateParameterProposal(NbQuickFixData data, String desc, Declaration dec,
        Type? type, DefaultRegion selection, Icons image, TextChange change, Integer exitPos) {

        data.fixes.add(object satisfies Fix {
            shared actual ChangeInfo implement() {
                change.applyChanges();
                return ChangeInfo();
            }
            
            shared actual String text => desc;
        });
    }
}
