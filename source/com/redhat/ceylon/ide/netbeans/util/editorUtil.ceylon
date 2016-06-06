import com.redhat.ceylon.ide.common.refactoring {
    DefaultRegion
}
import java.awt {
    EventQueue
}
import ceylon.interop.java {
    JavaRunnable,
    javaClass
}
import org.openide.cookies {
    EditorCookie
}
import org.openide.windows {
    TopComponent
}

shared object editorUtil {
    
    shared void updateSelection(DefaultRegion? selection) {
        if (exists selection) {
            EventQueue.invokeAndWait(JavaRunnable(void () {
                if (TopComponent.registry.activatedNodes.size == 1,
                    exists ec = TopComponent.registry.activatedNodes
                            .get(0).getCookie(javaClass<EditorCookie>()),
                    ec.openedPanes.size > 0) {
                    
                    ec.openedPanes.get(0).select(selection.start, selection.end);
                }
            }));
        }
    }
}