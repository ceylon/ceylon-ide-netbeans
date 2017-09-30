import ceylon.collection {
    MutableList
}

import org.eclipse.ceylon.compiler.typechecker.context {
    PhasedUnit
}
import org.eclipse.ceylon.compiler.typechecker.tree {
    Message,
    Tree,
    Node
}
import org.eclipse.ceylon.ide.common.correct {
    QuickFixData,
    QuickFixKind
}
import org.eclipse.ceylon.ide.common.doc {
    Icons
}
import org.eclipse.ceylon.ide.common.model {
    BaseCeylonProject
}
import org.eclipse.ceylon.ide.common.platform {
    TextChange,
    platformUtils,
    Status
}
import org.eclipse.ceylon.ide.common.refactoring {
    DefaultRegion
}
import com.redhat.ceylon.ide.netbeans.util {
    editorUtil
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
import org.eclipse.ceylon.cmr.api {
    ModuleVersionDetails
}
import org.eclipse.ceylon.model.typechecker.model {
    Referenceable
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
    
    errorCode => message.code;
    
    problemOffset => node.startIndex.intValue();
    
    shared actual void addAssignToLocalProposal(String description) {
        // TODO
    }
    
    shared actual void addConvertToClassProposal(String description,
        Tree.ObjectDefinition declaration) {
        // TODO
    }
    
    shared actual void addQuickFix(String description, 
        TextChange|Anything() change, DefaultRegion? selection, 
        Boolean qualifiedNameIsPath, Icons? image, QuickFixKind kind, 
        String? hint, Boolean asynchronous,
        Referenceable|Null|ModuleVersionDetails declaration,
        Boolean affectsOtherUnits) {
        
        fixes.add(object satisfies Fix {
            shared actual ChangeInfo implement() {
                if (is NbTextChange change) {
                    change.apply();
                }
                else if (is Anything() change) {
                    change();
                }
                else {
                    platformUtils.log(Status._WARNING, 
                        "Unsupported change of type " + className(change));
                }

                editorUtil.updateSelection(selection);
                return ChangeInfo();
            }
            
            text => description; // TODO add colors
        });
    }
}