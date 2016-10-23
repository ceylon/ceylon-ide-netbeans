import com.redhat.ceylon.ide.netbeans.util {
	nbIcons
}
import com.redhat.ceylon.model.typechecker.util {
	ModuleManager
}

import java.awt {
	Image
}

import org.netbeans.core.spi.multiview {
	MultiViewElement {
		multiViewElementRegistration=registration
	}
}
import org.netbeans.core.spi.multiview.text {
	MultiViewEditorElement
}
import org.openide.filesystems {
	FileObject,
	MIMEResolver {
		mimeResolverExtensionRegistration=extensionRegistration
	}
}
import org.openide.loaders {
	DataNode,
	DataObject {
		dataObjectRegistration=registration
	},
	MultiDataObject,
	MultiFileLoader
}
import org.openide.nodes {
	Children
}
import org.openide.util {
	Lookup
}
import org.openide.windows {
	TopComponent
}

mimeResolverExtensionRegistration {
	displayName = "Ceylon files";
	mimeType = "text/x-ceylon";
	extension = {"ceylon"};
}
dataObjectRegistration {
	displayName = "Ceylon files";
	mimeType = "text/x-ceylon";
	iconBase = "icons/ceylon.png";
}
shared class CeylonDataObject extends MultiDataObject {
	
	multiViewElementRegistration {
		displayName = "Source";
		iconBase = "icons/ceylonFile.png";
		mimeType = {"text/x-ceylon"};
		persistenceType = TopComponent.persistenceOnlyOpened;
		preferredID = "Ceylon";
		position = 1000;
	}
	shared static MultiViewEditorElement createEditor(Lookup lkp) {
		return MultiViewEditorElement(lkp);
	}
	
	shared new (FileObject file, MultiFileLoader loader) 
			extends MultiDataObject(file, loader) {
		registerEditor(mimeType, true);
	}
	
	associateLookup() => 1;
	
	createNodeDelegate() =>
			if (associateLookup() >= 1)
	then CustomDataNode(this, Children.leaf, lookup)
	else CustomDataNode(this, Children.leaf);
}

"This allows rendering @2x icons on hidpi screens."
class CustomDataNode(DataObject obj, Children ch, Lookup? lookup = null) 
		extends DataNode(obj, ch, lookup) {
	
	shared actual Image getIcon(Integer type) {
		String name = dataObject.primaryFile.nameExt;
		if (name == ModuleManager.moduleFile) {
			return nbIcons.modules;
		}
		else if (name == ModuleManager.packageFile) {
			return nbIcons.packages;
		}
		else {
			return nbIcons.ceylonFile;
		}
	}
	
	getOpenedIcon(Integer type) => getIcon(type);
}
