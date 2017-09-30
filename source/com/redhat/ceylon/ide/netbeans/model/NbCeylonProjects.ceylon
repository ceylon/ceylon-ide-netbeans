import org.eclipse.ceylon.ide.common.model {
	CeylonProjects
}

import org.netbeans.api.project {
	Project
}
import org.openide.filesystems {
	FileObject
}
import org.openide.util.lookup {
	serviceProvider
}

serviceProvider {
	service = `class NbCeylonProjects`;
}
shared class NbCeylonProjects()
        extends CeylonProjects<Project,FileObject,FileObject,FileObject>(){
    
    newNativeProject(Project nativeProject)
            => NbCeylonProject(this, nativeProject);
}