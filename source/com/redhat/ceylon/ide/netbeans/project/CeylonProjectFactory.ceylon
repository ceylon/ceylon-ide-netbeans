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

shared class CeylonProjectFactory() satisfies ProjectFactory2 {
    
    shared actual Boolean isProject(FileObject projectDir)
            => projectDir.getFileObject(".ceylon").folder;
    
    shared actual Project? loadProject(FileObject projectDir, ProjectState state)
            => isProject(projectDir) then CeylonProject(projectDir, state);
    
    shared actual void saveProject(Project project) {
    }
    shared actual ProjectManager.Result? isProject2(FileObject? fileObject)
            => null; // TODO
}
