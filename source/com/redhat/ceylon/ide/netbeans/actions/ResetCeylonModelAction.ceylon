import ceylon.interop.java {
    javaClass
}

import com.redhat.ceylon.ide.netbeans.model {
    CeylonModelManager,
    NbCeylonProjects
}

import java.awt.event {
    ActionEvent,
    ActionListener
}

import org.netbeans.api.project {
    Project
}
import org.openide.util {
    Lookup
}

shared class ResetCeylonModelAction(Project context) satisfies ActionListener {
    
    shared actual void actionPerformed(ActionEvent ev) {
        value projects = Lookup.default.lookup(javaClass<NbCeylonProjects>());
        
        if (exists project = projects.getProject(context)) {
            project.build.requestFullBuild();
            project.build.classPathChanged();

            Lookup.default.lookup(javaClass<CeylonModelManager>()).startBuild();
        }
    }
}
