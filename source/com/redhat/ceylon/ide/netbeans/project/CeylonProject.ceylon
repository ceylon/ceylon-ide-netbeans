import ceylon.interop.java {
	createJavaObjectArray
}


import com.redhat.ceylon.ide.netbeans.model {
	NbCeylonProjectHook
}

import java.beans {
	PropertyChangeListener
}
import java.lang {
	ObjectArray
}

import javax.swing {
	Icon,
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
import org.openide.filesystems {
	FileObject
}
import org.openide.util {
	Lookup
}
import org.openide.util.lookup {
	Lookups
}
import org.netbeans.spi.project.support {
	GenericSources
}
import com.redhat.ceylon.ide.netbeans.util {
	nbIcons
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
        
        shared actual ObjectArray<SourceGroup> getSourceGroups(String? string) {
            return createJavaObjectArray<SourceGroup>({
                object satisfies SourceGroup {
                    addPropertyChangeListener(PropertyChangeListener listener)
                            => noop();
                    
                    contains(FileObject fileObject) 
                            => true;
                    
                    displayName => "Source";
                    
                    shared actual Icon getIcon(Boolean boolean) => ImageIcon(nbIcons.anonymousFunction);
                    
                    shared actual String name => "source";
                    
                    shared actual void removePropertyChangeListener(PropertyChangeListener? propertyChangeListener) {}
                    
                    shared actual FileObject rootFolder => projectDirectory.getFileObject("source");
                }
            });
        }
    }

}

class Info(shared actual CeylonProject project) satisfies ProjectInformation {
    
    shared actual void addPropertyChangeListener(PropertyChangeListener? propertyChangeListener) {}
    
    shared actual String displayName => name;
    
    shared actual Icon icon => ImageIcon(nbIcons.ceylon);
    
    shared actual String name => project.projectDirectory.name;
    
    shared actual void removePropertyChangeListener(PropertyChangeListener? propertyChangeListener) {}
}
