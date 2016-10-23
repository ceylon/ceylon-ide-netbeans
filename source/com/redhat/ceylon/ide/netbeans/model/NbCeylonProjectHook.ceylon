import ceylon.interop.java {
	cls=javaClass
}

import com.redhat.ceylon.ide.netbeans.problems {
	ProblemsViewTopComponent
}

import org.netbeans.api.project {
	Project
}
import org.netbeans.spi.project.ui {
	ProjectOpenedHook
}
import org.openide.util {
	Lookup
}
import org.openide.windows {
	WindowManager {
		windowManager=default
	}
}

"Bootstraps a global Ceylon model if this [[project]] is a Ceylon project."
shared class NbCeylonProjectHook(Project project) extends ProjectOpenedHook() {

    shared actual void projectClosed() {
        value projects = Lookup.default.lookup(cls<NbCeylonProjects>());

        if (exists ceylonProject = projects.getProject(project)) {
            windowManager.invokeWhenUIReady(() {
                if (is NbCeylonProject ceylonProject,
                    is ProblemsViewTopComponent view = windowManager.findTopComponent("ProblemsViewTopComponent")) {
                    
                    view.closeProject(ceylonProject);			
                }
            });
        }

        projects.removeProject(project);
    }
    
    shared actual void projectOpened() {
        value projects = Lookup.default.lookup(cls<NbCeylonProjects>());
        
        // We make sure the model manager is instantiated and ready
        Lookup.default.lookup(cls<CeylonModelManager>()).initializeIfNeeded();
        
        // TODO better detection of Ceylon projects
        if (exists ceylonDir = project.projectDirectory.getFileObject(".ceylon"),
            ceylonDir.folder) {
        
            projects.addProject(project);
        }
    }
}
