import ceylon.interop.java {
	createJavaObjectArray
}

import com.redhat.ceylon.ide.netbeans.model {
	NbCeylonProjectHook
}
import com.redhat.ceylon.ide.netbeans.util {
	nbIcons
}

import java.beans {
	PropertyChangeListener
}

import javax.swing {
	ImageIcon
}
import javax.swing.event {
	ChangeListener
}

import org.netbeans.api.project {
	Project,
	ProjectInformation,
	Sources,
	SourceGroup
}
import org.netbeans.spi.project {
	ProjectState
}
import org.netbeans.spi.project.support {
	GenericSources
}
import org.openide.filesystems {
	FileObject
}
import org.openide.util {
	Lookup
}
import org.openide.util.lookup {
	Lookups
}

shared class CeylonProject(shared actual FileObject projectDirectory, ProjectState state)
        satisfies Project {

    variable Lookup? _lazyLookup = null;
    
    lookup => _lazyLookup else (_lazyLookup = createLookup());

    shared CeylonProject init() {
        GenericSources.group(this, projectDirectory, "ceylon", "ceylon",
            ImageIcon(nbIcons.ceylon), ImageIcon(nbIcons.ceylon));
        return this;
    }

    Lookup createLookup() {
    	return Lookups.fixed(
        	Info(this),
        	CeylonSources(),
        	CeylonProjectLogicalView(this),
        	CeylonIdeClasspathProvider().init(),
        	NbCeylonProjectHook(this)
        );
    }
    
    class CeylonSources() satisfies Sources {
        addChangeListener(ChangeListener? changeListener) => noop();
        removeChangeListener(ChangeListener? changeListener)  => noop();
        
        getSourceGroups(String? string) =>
            createJavaObjectArray<SourceGroup>({
                object satisfies SourceGroup {
                    addPropertyChangeListener(PropertyChangeListener listener)
                            => noop();
                    
                    contains(FileObject fileObject) 
                            => true;
                    
                    displayName => "Source";
                    
                    getIcon(Boolean boolean) => ImageIcon(nbIcons.anonymousFunction);
                    
                    name => "source";
                    
                    removePropertyChangeListener(PropertyChangeListener? propertyChangeListener)
                    	=> noop();
                    
                    rootFolder => projectDirectory.getFileObject("source");
                }
            });
	}
}

class Info(shared actual CeylonProject project) satisfies ProjectInformation {
    
    addPropertyChangeListener(PropertyChangeListener? propertyChangeListener)
    	=> noop();
    
    displayName => name;
    
    icon => ImageIcon(nbIcons.ceylon);
    
    name => project.projectDirectory.name;
    
    removePropertyChangeListener(PropertyChangeListener? propertyChangeListener)
    	=> noop();
}
