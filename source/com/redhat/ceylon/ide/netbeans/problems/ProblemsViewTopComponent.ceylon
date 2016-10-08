import com.redhat.ceylon.ide.netbeans.model {
	NbCeylonProject
}

import javax.swing.tree {
	TreeModel
}
import java.util {
	Properties
}

shared class ProblemsViewTopComponent()
		extends AbstractProblemsViewTopComponent() {
	
	setName("Ceylon Problems");
	setToolTipText("Displays errors and warnings");
	
	late ProblemsTree treeModel;

	problemsTree.cellRenderer = treeModel.renderer;
	
	shared actual void componentOpened() {
	}
	
	shared actual void componentClosed() {
	}

	shared actual TreeModel createModel() {
		treeModel = ProblemsTree();
		return treeModel.model;
	}
	
	shared void buildMessagesChanged(NbCeylonProject project, {SourceMsg*}? frontendMessages,
		{SourceMsg*}? backendMessages, {ProjectMsg*}? projectMessages) {

		treeModel.updateMessages(project, frontendMessages, backendMessages, projectMessages);
		expandNodes();
	}
	
	void expandNodes() {
		variable value i = 0;
		while (i<problemsTree.rowCount) {
			problemsTree.expandRow(i++);
		}
	}
	
	"Used to serialize the component's state by reflection."
	suppressWarnings("unusedDeclaration")
	void writeProperties(Properties p) {
		//p.setProperty("version", "1.0");
	}
	
	"Used to deserialize the component's state by reflection."
	suppressWarnings("unusedDeclaration")
	void readProperties(Properties p) {
		//String version = p.getProperty("version");
	}
	
}
