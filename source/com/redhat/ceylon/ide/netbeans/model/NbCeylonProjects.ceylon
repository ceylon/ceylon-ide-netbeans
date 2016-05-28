import com.redhat.ceylon.ide.common.model {
    CeylonProjects
}

import org.netbeans.api.project {
    Project
}
import org.openide.filesystems {
    FileObject
}

shared class NbCeylonProjects()
        extends CeylonProjects<Project,FileObject,FileObject,FileObject>(){
    
    shared actual NbCeylonProject newNativeProject(Project nativeProject)
            => NbCeylonProject(this, nativeProject);
}