import com.redhat.ceylon.ide.netbeans.model {
    NbCeylonProjects
}

import java.beans {
    PropertyChangeListener
}

import javax.swing {
    Icon
}

import org.netbeans.api.project {
    Project,
    ProjectInformation
}
import org.netbeans.spi.project {
    ProjectState
}
import org.openide.filesystems {
    FileObject
}
import org.openide.util {
    Lookup
}
import org.openide.util.lookup {
    Lookups
}

shared class CeylonProject(shared actual FileObject projectDirectory, ProjectState state)
        satisfies Project {

    variable Lookup? _lazyLookup = null;
    
    lookup => _lazyLookup else (_lazyLookup = Lookups.fixed(
        NbCeylonProjects()
    ));
}

class Info() satisfies ProjectInformation {
    
    shared actual void addPropertyChangeListener(PropertyChangeListener? propertyChangeListener) {}
    
    shared actual String displayName => name;
    
    shared actual Icon icon => nothing;
    
    shared actual String name => nothing;
    
    shared actual Project project => nothing;
    
    shared actual void removePropertyChangeListener(PropertyChangeListener? propertyChangeListener) {}
    
    
}