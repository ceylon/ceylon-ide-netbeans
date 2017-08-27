
import com.redhat.ceylon.ide.common.refactoring {
	DefaultRegion
}

import java.awt {
	EventQueue
}

import javax.swing.text {
	Document,
	AbstractDocument
}

import org.netbeans.api.editor.document {
	EditorDocumentUtils
}
import org.netbeans.modules.parsing.impl {
	Utilities
}
import org.openide.cookies {
	EditorCookie
}
import org.openide.filesystems {
	FileObject
}
import org.openide.windows {
	TopComponent
}

shared object editorUtil {
    
    shared void updateSelection(DefaultRegion? selection) {
        if (exists selection) {
            EventQueue.invokeAndWait(() {
                if (TopComponent.registry.activatedNodes.size == 1,
                    exists ec = TopComponent.registry.activatedNodes
                            .get(0).getCookie(`EditorCookie`),
                    ec.openedPanes.size > 0) {
                    
                    ec.openedPanes.get(0).select(selection.start, selection.end);
                }
            });
        }
    }
    
    shared Document? findOpenedDocument(FileObject fo) {
        for (tc in TopComponent.registry.opened) {
            if (exists activatedNodes = tc.activatedNodes) {
	            for (node in activatedNodes) {
	                if (exists cookie = node.getCookie(`EditorCookie`),
	                    exists doc = cookie.document,
	                    EditorDocumentUtils.getFileObject(doc) == fo) {
	                    
	                    return doc;
	                }
	            }
	        }
        }

        return null;
    }
    
    shared void updateAnnotations() {
        if (exists nodes = TopComponent.registry.currentNodes) {
	        for (node in nodes) {
	            if (exists cookie = node.getCookie(`EditorCookie`),
	                is AbstractDocument doc = cookie.document,
	            	exists fo = EditorDocumentUtils.getFileObject(doc)) {
	
					Utilities.revalidate(fo);
	            }            
	        }
	    }
    }
}
