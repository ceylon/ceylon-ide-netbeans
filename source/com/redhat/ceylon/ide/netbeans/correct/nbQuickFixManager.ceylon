import ceylon.collection {
    MutableList
}
import ceylon.interop.java {
    CeylonIterable
}

import com.redhat.ceylon.compiler.typechecker.tree {
    Message,
    Tree,
    Node
}
import com.redhat.ceylon.ide.common.correct {
    IdeQuickFixManager,
    QuickFixData,
    CreateEnumQuickFix,
    ImportProposals,
    AddAnnotationQuickFix,
    DeclareLocalQuickFix,
    CreateQuickFix,
    RefineFormalMembersQuickFix,
    RemoveAnnotationQuickFix,
    ChangeReferenceQuickFix
}
import com.redhat.ceylon.ide.common.refactoring {
    DefaultRegion
}
import com.redhat.ceylon.ide.netbeans.complete {
    CeylonCompletionItem
}

import java.util {
    Collection
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

shared object nbQuickFixManager
        extends IdeQuickFixManager<Document,InsertEdit,TextEdit,TextChange,DefaultRegion,Project,FileObject,CeylonCompletionItem,NbQuickFixData,Object>() {
    
    shared actual AddAnnotationQuickFix<FileObject,Document,InsertEdit,TextEdit,TextChange,DefaultRegion,Project,NbQuickFixData,CeylonCompletionItem> addAnnotations
            => annotationsFix;
    
    shared actual void addImportProposals(Collection<CeylonCompletionItem> proposals, NbQuickFixData data) {
        for (proposal in CeylonIterable(proposals)) {
            data.fixes.add(object satisfies Fix {
                shared actual ChangeInfo implement() {
                    proposal.defaultAction(null);
                    return ChangeInfo();
                }
                
                shared actual String text => proposal.desc;
            });
        }
    }
    
    shared actual ChangeReferenceQuickFix<FileObject,Project,Document,InsertEdit,TextEdit,TextChange,NbQuickFixData,DefaultRegion,CeylonCompletionItem> changeReferenceQuickFix
            => nbChangeReferenceFix;
    
    shared actual CreateEnumQuickFix<FileObject,Document,InsertEdit,TextEdit,TextChange,DefaultRegion,Project,NbQuickFixData,CeylonCompletionItem> createEnumQuickFix
            => nbCreateEnumFix;
    
    shared actual CreateQuickFix<FileObject,Project,Document,InsertEdit,TextEdit,TextChange,DefaultRegion,NbQuickFixData,CeylonCompletionItem> createQuickFix
            => nbCreateFix;
    
    shared actual DeclareLocalQuickFix<FileObject,Document,InsertEdit,TextEdit,TextChange,Object,CeylonCompletionItem,Project,NbQuickFixData,DefaultRegion> declareLocalQuickFix
            => nbDeclareLocalFix;
    
    shared actual ImportProposals<FileObject,CeylonCompletionItem,Document,InsertEdit,TextEdit,TextChange> importProposals
            => nbImportProposals;
    
    shared actual RefineFormalMembersQuickFix<FileObject,Document,InsertEdit,TextEdit,TextChange,DefaultRegion,Project,NbQuickFixData,CeylonCompletionItem> refineFormalMembersQuickFix
            => nbRefineFormalMembersFix;
    
    shared actual RemoveAnnotationQuickFix<FileObject,Document,InsertEdit,TextEdit,TextChange,DefaultRegion,Project,NbQuickFixData,CeylonCompletionItem> removeAnnotations
            => annotationsFix;
}

shared class NbQuickFixData(shared actual Tree.CompilationUnit rootNode, 
    shared actual Project project,
    shared actual Node node, Message message, 
    Document document, shared MutableList<Fix> fixes) 
        satisfies QuickFixData<Project> {

    shared actual Integer errorCode => message.code;
    
    shared actual Integer problemOffset => node.startIndex.intValue();
    
     
}