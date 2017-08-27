import com.redhat.ceylon.ide.netbeans.model {
	CeylonModelManager,
	NbCeylonProjects
}

import java.awt.event {
	ActionEvent,
	ActionListener
}
import java.lang { 
	nonbean
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
shared nonbean class ResetCeylonModelAction(Project context) satisfies ActionListener {
	
	shared actual void actionPerformed(ActionEvent ev) {
		value projects = Lookup.default.lookup(^NbCeylonProjects);
		
		if (exists project = projects.getProject(context)) {
			project.build.requestFullBuild();
			project.build.classPathChanged();
			
			Lookup.default.lookup(`CeylonModelManager`).startBuild();
		}
	}
}
