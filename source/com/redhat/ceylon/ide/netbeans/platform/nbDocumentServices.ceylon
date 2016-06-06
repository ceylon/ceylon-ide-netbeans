import ceylon.interop.java {
    javaClass
}

import com.redhat.ceylon.compiler.typechecker.context {
    PhasedUnit
}
import com.redhat.ceylon.ide.common.platform {
    DocumentServices,
    TextChange,
    CommonDocument
}
import com.redhat.ceylon.ide.netbeans.correct {
    NbTextChange,
    NbDocument,
    NbFileObjectDocument,
    NbCompositeChange
}

import java.io {
    File
}

import org.netbeans.api.editor.document {
    EditorDocumentUtils
}
import org.openide.cookies {
    EditorCookie
}
import org.openide.filesystems {
    FileUtil
}
import org.openide.windows {
    TopComponent
}

object nbDocumentServices satisfies DocumentServices {
    
    createCompositeChange(String name) => NbCompositeChange(name);
    
    function phasedUnitToDocument(PhasedUnit pu) {
        value file = File(pu.unit.fullPath);
        value fo = FileUtil.toFileObject(file);
        
        // TODO move in editorUtil
        for (tc in TopComponent.registry.opened) {
            for (node in tc.activatedNodes) {
                if (exists cookie = node.getCookie(javaClass<EditorCookie>()),
                    exists doc = cookie.document,
                    EditorDocumentUtils.getFileObject(doc) == fo) {
                    
                    return NbDocument(doc);
                }
            }
        }

        return NbFileObjectDocument(fo);
    }
    
    shared actual TextChange createTextChange(String name, CommonDocument|PhasedUnit input) {
        value doc = switch (input)
        case (is NbDocument) input
        case (is PhasedUnit) phasedUnitToDocument(input)
        else null;
        
        if (exists doc) {
            return NbTextChange(doc);
        }
        throw Exception("Unsupported input type " + className(input));
    }
    
    indentSpaces => 4;
    
    indentWithSpaces => true;
}
