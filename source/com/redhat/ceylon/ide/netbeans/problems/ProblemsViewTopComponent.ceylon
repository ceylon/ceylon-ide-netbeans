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
