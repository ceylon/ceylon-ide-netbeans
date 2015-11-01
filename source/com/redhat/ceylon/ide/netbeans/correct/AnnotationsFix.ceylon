import com.redhat.ceylon.ide.common.correct {
    AddAnnotationQuickFix,
    RemoveAnnotationQuickFix
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
import com.redhat.ceylon.model.typechecker.model {
    Referenceable,
    Declaration
}
import org.netbeans.spi.editor.hints {
    Fix,
    ChangeInfo
}
import com.redhat.ceylon.ide.common.imports {
    AbstractModuleImportUtil
}

object annotationsFix
        satisfies AddAnnotationQuickFix<FileObject,Document,InsertEdit,TextEdit,TextChange,DefaultRegion,Project,NbQuickFixData,CeylonCompletionItem>
                & RemoveAnnotationQuickFix<FileObject,Document,InsertEdit,TextEdit,TextChange,DefaultRegion,Project,NbQuickFixData,CeylonCompletionItem>
                & NbDocumentChanges & AbstractFix {
    
    shared actual void newAddAnnotationQuickFix(Referenceable dec, String text, 
        String desc, Integer offset, TextChange change, DefaultRegion? selection, NbQuickFixData data) {
        
        data.fixes.add(object satisfies Fix {
            shared actual ChangeInfo implement() {
                change.applyChanges();
                return ChangeInfo();
            }
            
            shared actual String text => desc;
        });
    }
    
    
    shared actual void newRemoveAnnotationQuickFix(Declaration dec, String annotation,
        String desc, Integer offset, TextChange change, DefaultRegion selection, NbQuickFixData data) {

        data.fixes.add(object satisfies Fix {
            shared actual ChangeInfo implement() {
                change.applyChanges();
                return ChangeInfo();
            }
            
            shared actual String text => desc;
        });
    }
    shared actual AbstractModuleImportUtil<FileObject,Project,Document,InsertEdit,TextEdit,TextChange> moduleImportUtil => nothing;
    
    shared actual void newCorrectionQuickFix(String desc, TextChange change, DefaultRegion? selection) {
        // ?? TODO
    }
    
}
