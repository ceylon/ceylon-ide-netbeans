import org.netbeans.api.project {
	Project
}
import org.netbeans.spi.project.ui {
	LogicalViewProvider
}
import org.netbeans.spi.project.ui.support {
	NodeFactorySupport {
		createCompositeChildren
	},
	NodeFactory {
		nodeFactoryRegistration=registration
	},
	NodeList
}
import org.openide.filesystems {
	FileObject
}
import org.openide.loaders {
	DataFolder,
	DataObject
}
import org.openide.nodes {
	Node,
	FilterNode
}
import org.openide.util {
	ImageUtilities
}
import com.redhat.ceylon.ide.netbeans.util {
	nbIcons
}

class CeylonProjectLogicalView(CeylonProject project) satisfies LogicalViewProvider {
	
	shared actual Node createLogicalView() {
		value root = project.projectDirectory;
		value folder = DataFolder.findFolder(root);
		return ProjectNode(folder.nodeDelegate);
	}
	
	findPath(Node? node, Object? obj) => null;
	
	class ProjectNode(Node node) 
			extends FilterNode(node, 
		createCompositeChildren(project, "Projects/com-redhat-ceylon-ide-netbeans-project/Nodes")) {
		
		getIcon(Integer int) => nbIcons.ceylon;
		getOpenedIcon(Integer int) => nbIcons.ceylon;
		displayName = project.projectDirectory.name;
	}
}

nodeFactoryRegistration {
	projectType = {"com-redhat-ceylon-ide-netbeans-project"};
	position = 10;
}
shared class CeylonProjectNodeFactory() satisfies NodeFactory {
	
	shared actual NodeList<out Object> createNodes(Project project) {
		return NodeFactorySupport.fixedNodeList(
			for (child in orderedChildren(project))
			CeylonNode(DataObject.find(child).nodeDelegate)
		);
	}
	
	FileObject[] orderedChildren(Project project) {
		value children = project.projectDirectory.children.array.coalesced;
		assert(is CeylonProject project);
		
		return children.sort((x, y) {
			if (x.folder) {
				if (y.folder) {
					return x.name.compare(y.name);
				} else {
					return smaller;
				}
			}
			if (y.folder) {
				return larger;
			} else {
				return x.name.compare(y.name);
			}
		});
	}
}

class CeylonNode(Node node) extends FilterNode(node) {
	getIcon(Integer int) 
			=> if (node.name == "source") 
	then ImageUtilities.mergeImages(super.getIcon(int), nbIcons.sourceBadge, 7, 7) 
	else super.getIcon(int);
	
	getOpenedIcon(Integer int) 
			=> if (node.name == "source") 
	then ImageUtilities.mergeImages(super.getOpenedIcon(int), nbIcons.sourceBadge, 7, 7) 
	else super.getOpenedIcon(int);
}
