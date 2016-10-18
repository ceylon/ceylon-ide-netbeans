

import javax.swing {
	ImageIcon
}

import org.netbeans.api.project {
	Project,
	ProjectManager
}
import org.netbeans.spi.project {
	ProjectState,
	ProjectFactory2
}
import org.openide.filesystems {
	FileObject
}
import com.redhat.ceylon.ide.netbeans.util {
	nbIcons
}

shared class CeylonProjectFactory() satisfies ProjectFactory2 {
    
    shared actual Boolean isProject(FileObject projectDir)
            => projectDir.getFileObject(".ceylon")?.folder else false;

    shared actual Project? loadProject(FileObject projectDir, ProjectState state)
            => isProject(projectDir) then CeylonProject(projectDir, state);
    
    shared actual void saveProject(Project project) {
    }
    
    shared actual ProjectManager.Result? isProject2(FileObject fileObject) {
        return if (exists config = fileObject.getFileObject(".ceylon/config"),
            	!config.virtual,
            	!config.folder)
        then ProjectManager.Result(fileObject.name, "Ceylon", ImageIcon(nbIcons.ceylonFile))
        else null;
    }
}
