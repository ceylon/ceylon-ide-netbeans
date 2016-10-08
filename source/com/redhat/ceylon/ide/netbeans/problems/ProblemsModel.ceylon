import ceylon.collection {
	HashMap
}

import com.redhat.ceylon.ide.common.model {
	Severity
}
import com.redhat.ceylon.ide.netbeans {
	nbIcons
}
import com.redhat.ceylon.ide.netbeans.model {
	NbCeylonProject
}

import java.awt {
	Component
}

import javax.swing {
	JTree,
	ImageIcon
}
import javax.swing.tree {
	DefaultMutableTreeNode,
	DefaultTreeModel,
	DefaultTreeCellRenderer,
	TreeCellRenderer
}
import org.openide.filesystems {
	FileObject
}

class ProblemsModel() {
	value problemsByProject = HashMap<NbCeylonProject, Problems>();
	
	class Problems(project, frontendMessages, backendMessages, projectMessages) {
		
		NbCeylonProject project;
		
		{SourceMsg*}? frontendMessages;
		{SourceMsg*}? backendMessages;
		{ProjectMsg*}? projectMessages;
		
		shared Integer count(Severity s)
				=> [frontendMessages, backendMessages, projectMessages].coalesced.fold(0)(
			(initial, messages)
					=> initial + messages.count((msg) => msg.severity == s));
		
		shared Integer countWarnings() => count(Severity.warning);
		
		shared Integer countErrors() => count(Severity.error);
		
		shared {BuildMsg*} allMessages
				=> expand([frontendMessages, backendMessages, projectMessages].coalesced);
	}
	
	shared void updateProblems(NbCeylonProject project, {SourceMsg*}? frontendMessages,
		{SourceMsg*}? backendMessages, {ProjectMsg*}? projectMessages) {
		
		problemsByProject[project]
				= Problems {
			project = project;
			frontendMessages = frontendMessages;
			backendMessages = backendMessages;
			projectMessages = projectMessages;
		};
	}
	
	shared Integer count(Severity s)
			=> problemsByProject.items.fold(0)((sum, item) => sum + item.count(s));
	
	shared Integer countWarnings()
			=> problemsByProject.items.fold(0)((sum, item) => sum + item.countWarnings());
	
	shared Integer countErrors()
			=> problemsByProject.items.fold(0)((sum, item) => sum + item.countErrors());
	
	shared {BuildMsg*} allMessages => expand(problemsByProject.items.map(Problems.allMessages));
}

class ProblemsTree() {
	value noFile = "nofile";
	value root = DefaultMutableTreeNode();
	shared DefaultTreeModel model = DefaultTreeModel(root);
	value problemsModel = ProblemsModel();

	value errorsNode = DefaultMutableTreeNode();
	value warningsNode = DefaultMutableTreeNode();
	value messagesNode = DefaultMutableTreeNode();
	
	root.add(errorsNode);
	root.add(warningsNode);
	root.add(messagesNode);
	
	shared void reload() {
		model.reload(errorsNode);
		model.reload(warningsNode);
		model.reload(messagesNode);
	}
	
	shared TreeCellRenderer renderer = object extends DefaultTreeCellRenderer() {
		shared actual Component getTreeCellRendererComponent(JTree tree, Object obj, 
			Boolean sel, Boolean expanded, Boolean leaf, Integer row, Boolean hasFocus) {
			
			value cmp = super.getTreeCellRendererComponent(tree, obj, sel, expanded, 
				leaf, row, hasFocus);
			
			if (obj == errorsNode) {
				icon = ImageIcon(nbIcons.error);
				text = "``errorsNode.childCount`` errors in project";
			} else if (obj == warningsNode) {
				icon = ImageIcon(nbIcons.warning);
				text = "``warningsNode.childCount`` warnings in project";
			} else if (obj == messagesNode) {
				icon = ImageIcon(nbIcons.info);
				text = "``messagesNode.childCount`` messages in project";
			} else if (is DefaultMutableTreeNode obj) {
				if (is SourceMsg val = obj.userObject) {
					text = val.startLine.string + ": " + val.message;
					icon = switch(val.severity)
					case (Severity.error) ImageIcon(nbIcons.error)
					case (Severity.warning) ImageIcon(nbIcons.warning)
					else ImageIcon(nbIcons.info);
				} else if (is FileObject val = obj.userObject) {
					text = val.nameExt;
					icon = ImageIcon(nbIcons.ceylonFile);
				}
			}
			
			return cmp;
		}
	};
	
	shared void updateMessages(NbCeylonProject project, {SourceMsg*}? frontendMessages,
		{SourceMsg*}? backendMessages, {ProjectMsg*}? projectMessages) {
		
		problemsModel.updateProblems(project, frontendMessages, backendMessages, projectMessages);
		
		errorsNode.removeAllChildren();
		warningsNode.removeAllChildren();
		messagesNode.removeAllChildren();

		value bySeverity = problemsModel.allMessages.group((msg) => msg.severity);
		
		for (severity -> messages in bySeverity) {
			value byFile = messages.group((msg) => if (is SourceMsg msg) then msg.file else noFile);
			
			for (file -> messageList in byFile) {
				value fileNode = DefaultMutableTreeNode(file, true);
				
				switch (severity)
				case (Severity.error) {
					errorsNode.add(fileNode);
				}
				case (Severity.warning) {
					warningsNode.add(fileNode);
				}
				else {
					messagesNode.add(fileNode);
				}
				
				for (msg in messageList) {
					switch (msg.severity)
					case (Severity.error) {
						fileNode.add(DefaultMutableTreeNode(msg));
					}
					case (Severity.warning) {
						fileNode.add(DefaultMutableTreeNode(msg));
					}
					else {
						fileNode.add(DefaultMutableTreeNode(msg));
					}
				}
			}
		}
		
		model.reload();
	}
}