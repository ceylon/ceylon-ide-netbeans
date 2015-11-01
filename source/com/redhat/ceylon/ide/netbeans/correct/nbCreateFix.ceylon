import com.redhat.ceylon.ide.common.correct {
    CreateQuickFix,
    CreateParameterQuickFix
}
import org.openide.filesystems {
    FileObject
}
import org.netbeans.api.project {
    Project
}
import javax.swing.text {
    Document,
    StyledDocument
}
import com.redhat.ceylon.ide.common.refactoring {
    DefaultRegion
}
import com.redhat.ceylon.ide.netbeans.complete {
    CeylonCompletionItem
}
import com.redhat.ceylon.ide.common.doc {
    Icons
}
import com.redhat.ceylon.model.typechecker.model {
    Unit,
    Type,
    Scope
}
import org.netbeans.spi.editor.hints {
    Fix,
    ChangeInfo
}
import org.openide.text {
    NbDocument
}

object nbCreateFix
        satisfies CreateQuickFix<FileObject,Project,Document,InsertEdit,TextEdit,TextChange,DefaultRegion,NbQuickFixData,CeylonCompletionItem>
                & NbDocumentChanges
                & AbstractFix {

    shared actual CreateParameterQuickFix<FileObject,Project,Document,InsertEdit,TextEdit,TextChange,DefaultRegion,NbQuickFixData,CeylonCompletionItem> createParameterQuickFix
            => nbCreateParameterFix;
    
    shared actual Integer getLineOfOffset(Document doc, Integer offset) {
        assert(is StyledDocument doc);
        return NbDocument.findLineNumber(doc, offset);
    }
    
    shared actual void newCreateQuickFix(NbQuickFixData data, String desc, Scope scope,
        Unit unit, Type? returnType, Icons image, TextChange change, Integer exitPos, DefaultRegion selection) {
        
        data.fixes.add(object satisfies Fix {
            shared actual ChangeInfo implement() {
                change.applyChanges();
                return ChangeInfo();
            }
            
            shared actual String text => desc;
        });
    }
}
