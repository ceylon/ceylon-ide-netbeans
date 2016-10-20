import com.redhat.ceylon.ide.netbeans.model {
	NbCeylonProject
}

import java.util {
	Properties
}

import javax.swing.tree {
	TreeModel,
	DefaultMutableTreeNode
}
import java.awt.event {
	MouseAdapter,
	MouseEvent
}
import org.openide.loaders {
	DataObject
}
import ceylon.interop.java {
	javaClass
}
import org.openide.cookies {
	LineCookie
}
import org.openide.text {
	Line
}
import org.openide.windows {
	TopComponent {
		description,
		registration,
		openActionRegistration
	}
}
import org.openide.awt {
	actionID,
	actionReference
}

"Displays project errors in a tool window."
description {
	preferredID = "ProblemsViewTopComponent";
	iconBase = "icons/ceylon.png";
	persistenceType = TopComponent.persistenceAlways;
}
registration {
	mode = "bottomSlidingSide";
	openAtStartup = false;
}
actionID {
	category = "Window";
	id = "com.redhat.ceylon.ide.netbeans.problems.ProblemsViewTopComponent";
}
actionReference {
	path = "Menu/Window";
	/*position = 333; */
}
openActionRegistration {
	displayName = "Ceylon Problems";
	preferredID = "ProblemsViewTopComponent";
}
shared class ProblemsViewTopComponent()
		extends AbstractProblemsViewTopComponent() {
	
	setName("Ceylon Problems");
	setToolTipText("Displays errors and warnings");
	
	late ProblemsTree treeModel;

	problemsTree.cellRenderer = treeModel.renderer;
	problemsTree.addMouseListener(object extends MouseAdapter() {
		shared actual void mouseClicked(MouseEvent evt) {
			if (evt.clickCount == 2,
				exists path = problemsTree.getPathForLocation(evt.x, evt.y),
				is DefaultMutableTreeNode node = path.lastPathComponent,
				is SourceMsg msg = node.userObject,
				exists dobj = DataObject.find(msg.file),
				is LineCookie cookie = dobj.getCookie(javaClass<LineCookie>())) {
				
				value line = cookie.lineSet.getOriginal(msg.startLine - 1);
				line.show(Line.ShowOpenType.open, Line.ShowVisibilityType.focus, msg.startCol);
			}
		}
	});
	
	shared actual void componentOpened() {
	}
	
	shared actual void componentClosed() {
	}

	shared actual void preInitComponents() {
		treeModel = ProblemsTree();
	}

	shared actual TreeModel createModel() {
		return treeModel.model;
	}
	
	shared void closeProject(NbCeylonProject project) {
		treeModel.closeProject(project);
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
	shared void writeProperties(Properties p) {
		//p.setProperty("version", "1.0");
	}
	
	"Used to deserialize the component's state by reflection."
	shared void readProperties(Properties p) {
		//String version = p.getProperty("version");
	}
	
}
