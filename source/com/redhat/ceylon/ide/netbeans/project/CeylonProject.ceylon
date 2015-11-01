import org.netbeans.api.project {
    Project,
    ProjectInformation
}
import org.openide.filesystems {
    FileObject
}
import org.openide.util {
    Lookup
}
import org.netbeans.spi.project {
    ProjectState
}
import org.openide.util.lookup {
    Lookups
}
import java.beans {
    PropertyChangeListener
}
import javax.swing {
    Icon
}
import com.redhat.ceylon.ide.netbeans {
    nbIcons
}

shared class CeylonProject(shared actual FileObject projectDirectory, ProjectState state)
        satisfies Project {

    shared actual Lookup lookup = Lookups.fixed(
        
    );
    
}

class Info() satisfies ProjectInformation {
    
    shared actual void addPropertyChangeListener(PropertyChangeListener? propertyChangeListener) {}
    
    shared actual String displayName => name;
    
    shared actual Icon icon => nothing;
    
    shared actual String name => nothing;
    
    shared actual Project project => nothing;
    
    shared actual void removePropertyChangeListener(PropertyChangeListener? propertyChangeListener) {}
    
    
}