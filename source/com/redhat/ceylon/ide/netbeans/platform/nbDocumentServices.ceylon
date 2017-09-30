import org.eclipse.ceylon.compiler.typechecker.context {
    PhasedUnit
}
import org.eclipse.ceylon.ide.common.platform {
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
import com.redhat.ceylon.ide.netbeans.util {
    editorUtil
}

import java.io {
    File
}

import org.openide.filesystems {
    FileUtil
}

object nbDocumentServices satisfies DocumentServices {
    
    createCompositeChange(String name) => NbCompositeChange(name);
    
    function phasedUnitToDocument(PhasedUnit pu) {
        value file = File(pu.unit.fullPath);
        value fo = FileUtil.toFileObject(file);
        
        if (exists doc = editorUtil.findOpenedDocument(fo)) {
            return NbDocument(doc);
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
