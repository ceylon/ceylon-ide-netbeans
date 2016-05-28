import org.netbeans.spi.project.ui {
    ProjectOpenedHook
}
import org.netbeans.api.project {
    Project
}
import org.openide.util {
    Lookup
}
import ceylon.interop.java {
    cls=javaClass
}

shared class NbCeylonProjectHook(Project project) extends ProjectOpenedHook() {

    print("NbCeylonProjectHook exists!");
    
    shared actual void projectClosed() {
        print("NbCeylonProjectHook closed!");
        value projects = Lookup.default.lookup(cls<NbCeylonProjects>());
        projects.removeProject(project);
    }
    
    shared actual void projectOpened() {
        value projects = Lookup.default.lookup(cls<NbCeylonProjects>());
        
        // We make sure the model manager is instantiated and ready
        Lookup.default.lookup(cls<CeylonModelManager>()).initializeIfNeeded();
        
        // TODO better detection of Ceylon projects
        if (exists ceylonDir = project.projectDirectory.getFileObject(".ceylon"),
            ceylonDir.folder) {
        
            print("NbCeylonProjectHook opened!");
            projects.addProject(project);
        }
    }
}
