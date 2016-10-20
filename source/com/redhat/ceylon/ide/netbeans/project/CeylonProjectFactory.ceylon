import javax.swing {
	ImageIcon
}

import org.netbeans.api.project {
	Project,
	ProjectManager
}
import org.netbeans.spi.project {
	ProjectState,
	ProjectFactory2,
	ProjectFactory
}
import org.openide.filesystems {
	FileObject
}
import com.redhat.ceylon.ide.netbeans.util {
	nbIcons
}
import org.openide.util.lookup {
	serviceProvider
}

serviceProvider {
	service = `interface ProjectFactory`;
}
shared class CeylonProjectFactory() satisfies ProjectFactory2 {
    
    isProject(FileObject projectDir)
            => projectDir.getFileObject(".ceylon")?.folder else false;

    loadProject(FileObject projectDir, ProjectState state)
            => isProject(projectDir) then CeylonProject(projectDir, state);
    
    saveProject(Project project) => noop();
    
    isProject2(FileObject fileObject) =>
        if (exists config = fileObject.getFileObject(".ceylon/config"),
        	!config.virtual,
        	!config.folder)
        then ProjectManager.Result(fileObject.name, "Ceylon", ImageIcon(nbIcons.ceylon))
        else null;
}
