import ceylon.collection {
    MutableList
}

import com.redhat.ceylon.compiler.typechecker.context {
    PhasedUnit
}
import com.redhat.ceylon.compiler.typechecker.tree {
    Message,
    Tree,
    Node
}
import com.redhat.ceylon.ide.common.correct {
    QuickFixData,
    QuickFixKind
}
import com.redhat.ceylon.ide.common.doc {
    Icons
}
import com.redhat.ceylon.ide.common.model {
    BaseCeylonProject
}
import com.redhat.ceylon.ide.common.platform {
    TextChange
}
import com.redhat.ceylon.ide.common.refactoring {
    DefaultRegion
}

import javax.swing.text {
    Document
}

import org.netbeans.api.project {
    Project
}
import org.netbeans.spi.editor.hints {
    Fix
}


shared class NbQuickFixData(
    shared actual Tree.CompilationUnit rootNode, 
    shared Project project,
    shared actual Node node, Message message, 
    shared actual BaseCeylonProject ceylonProject,
    shared actual DefaultRegion editorSelection,
    shared actual PhasedUnit phasedUnit,
    shared actual Integer problemLength,
    Document nativeDocument,
    shared MutableList<Fix> fixes) 
        satisfies QuickFixData {

    shared actual NbDocument document = NbDocument(nativeDocument);
    
    shared actual Integer errorCode => message.code;
    
    shared actual Integer problemOffset => node.startIndex.intValue();
    
    shared actual void addAssignToLocalProposal(String description) {}
    
    shared actual void addConvertToClassProposal(String description, Tree.ObjectDefinition declaration) {}
    
    shared actual void addQuickFix(String description, TextChange|Anything() change, DefaultRegion? selection, Boolean qualifiedNameIsPath, Icons? image, QuickFixKind kind) {}
}