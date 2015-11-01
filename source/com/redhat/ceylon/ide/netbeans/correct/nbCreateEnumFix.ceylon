import com.redhat.ceylon.ide.common.correct {
    CreateEnumQuickFix
}
import com.redhat.ceylon.ide.common.doc {
    Icons
}
import com.redhat.ceylon.ide.common.refactoring {
    DefaultRegion
}
import com.redhat.ceylon.ide.netbeans.complete {
    CeylonCompletionItem
}

import javax.swing.text {
    Document
}

import org.netbeans.api.project {
    Project
}
import org.netbeans.spi.editor.hints {
    Fix,
    ChangeInfo
}
import org.openide.filesystems {
    FileObject
}

object nbCreateEnumFix
        satisfies CreateEnumQuickFix<FileObject,Document,InsertEdit,TextEdit,TextChange,DefaultRegion,Project,NbQuickFixData,CeylonCompletionItem>
                & NbDocumentChanges
                & AbstractFix {

    shared actual void consumeNewQuickFix(String desc, Icons image, Integer offset,
        TextChange change, NbQuickFixData data) {
        
        data.fixes.add(object satisfies Fix {
            shared actual ChangeInfo implement() {
                change.applyChanges();
                return ChangeInfo();
            }
            
            shared actual String text => desc;
        });
    }
    
    shared actual Integer getDocLength(Document doc) => doc.length;
}