import ceylon.interop.java {
    CeylonList
}

import com.redhat.ceylon.compiler.typechecker.context {
    PhasedUnit
}
import com.redhat.ceylon.ide.common.completion {
    IdeCompletionManager
}
import com.redhat.ceylon.ide.common.correct {
    AbstractQuickFix,
    ImportProposals
}
import com.redhat.ceylon.ide.common.refactoring {
    DefaultRegion
}
import com.redhat.ceylon.ide.common.util {
    Indents
}
import com.redhat.ceylon.ide.netbeans.complete {
    CeylonCompletionItem,
    nbCompletionManager
}
import com.redhat.ceylon.ide.netbeans.model {
    ceylonBuilder
}

import java.io {
    File
}

import javax.swing.text {
    Document
}

import org.netbeans.api.project {
    Project
}
import org.openide.filesystems {
    FileObject,
    FileUtil
}
import org.openide.text {
    NbDocument
}

interface AbstractFix satisfies AbstractQuickFix<FileObject, Document, InsertEdit, TextEdit, TextChange, DefaultRegion, Project, CeylonCompletionItem> {
    
    shared actual IdeCompletionManager<out Anything,out Anything,out CeylonCompletionItem,Document> completionManager
            => nbCompletionManager;
    
    shared actual Integer getTextEditOffset(TextEdit change) => change.start;
    
    shared actual List<PhasedUnit> getUnits(Project p) {
        value tc = ceylonBuilder.getOrCreateTypeChecker(p);
        return CeylonList(tc.phasedUnits.phasedUnits);
    }
    
    shared actual ImportProposals<out Anything,out Anything,Document,InsertEdit,TextEdit,TextChange> importProposals => nbImportProposals;
    
    shared actual Indents<Document> indents => nbIndents;
    
    shared actual DefaultRegion newRegion(Integer start, Integer length) => DefaultRegion(start, length);
    
    shared actual TextChange newTextChange(String desc, PhasedUnit|FileObject|Document u) {
        if (is Document u) {
            return TextChange(u);
        }
        if (is FileObject u) {
            return TextChange(NbDocument.getDocument(u));
        }
        
        return TextChange(NbDocument.getDocument(FileUtil.toFileObject(File(u.unit.fullPath))));
    }
    
}