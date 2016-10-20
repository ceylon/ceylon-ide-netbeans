import ceylon.interop.java {
	Unserialized,
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
import org.openide.awt {
	actionID,
	actionRegistration,
	actionReference
}
import org.openide.util {
	Lookup
}

actionID {
	category = "Tools";
	id = "com.redhat.ceylon.ide.netbeans.actions.ResetCeylonModelAction";
}
actionRegistration {
	displayName = "Reset Ceylon model";
	iconBase = "icons/ceylon.png";
	
}
actionReference {
	path = "Menu/Tools";
	position = 1800;
}
shared class ResetCeylonModelAction(Project context) extends Unserialized.create() satisfies ActionListener {
    
    shared actual void actionPerformed(ActionEvent ev) {
        value projects = Lookup.default.lookup(javaClass<NbCeylonProjects>());
        
        if (exists project = projects.getProject(context)) {
            project.build.requestFullBuild();
            project.build.classPathChanged();

            Lookup.default.lookup(javaClass<CeylonModelManager>()).startBuild();
        }
    }
}
