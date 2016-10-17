import ceylon.collection {
	HashMap
}

import java.beans {
	PropertyChangeListener,
	PropertyChangeSupport
}
import java.net {
	URL
}
import java.util {
	List,
	ArrayList
}

import org.netbeans.api.java.classpath {
	ClassPath
}
import org.netbeans.spi.java.classpath {
	ClassPathProvider,
	PathResourceImplementation,
	ClassPathFactory,
	ClassPathImplementation
}
import org.netbeans.spi.java.classpath.support {
	ClassPathSupport
}
import org.openide.filesystems {
	FileObject
}
import java.lang {
	UnsupportedOperationException
}
import org.netbeans.api.java.platform {
	JavaPlatform
}

shared class CeylonIdeClasspathProvider() satisfies ClassPathProvider {

	value classpathResourcesRef = HashMap<String, List<PathResourceImplementation>>();
	value classpaths = HashMap<String, ClassPath>();
	late PropertyChangeSupport changes;
	
	shared CeylonIdeClasspathProvider init() {
		changes = PropertyChangeSupport(this);
		
		classpaths.put(ClassPath.boot, ClassPathFactory.createClassPath(CeylonClassPaths(ClassPath.boot)));
		classpathResourcesRef.put(ClassPath.boot, ArrayList<PathResourceImplementation>());
		classpaths.put(ClassPath.compile, ClassPathFactory.createClassPath(CeylonClassPaths(ClassPath.compile)));
		classpathResourcesRef.put(ClassPath.compile, ArrayList<PathResourceImplementation>());
		
		for (lib in JavaPlatform.default.bootstrapLibraries.entries()) {
			classpathResourcesRef.get(ClassPath.boot)?.add(ClassPathSupport.createResource(lib.url));
		}
		for (lib in JavaPlatform.default.standardLibraries.entries()) {
			classpathResourcesRef.get(ClassPath.compile)?.add(ClassPathSupport.createResource(lib.url));
		}

		return this;
	}
	
	shared void addRoot(URL resource, String type) {
		if (classpathResourcesRef.defines(type)) {
			classpathResourcesRef.get(type)?.add(ClassPathSupport.createResource(resource));
			changes.firePropertyChange(ClassPathImplementation.propResources, null, null);
		} else {
			throw UnsupportedOperationException("Unsupported classpath type ``type``");
		}
	}
	
	shared actual ClassPath? findClassPath(FileObject file, String type) {
		return classpaths.get(type);
	}
	
	class CeylonClassPaths(String type) satisfies ClassPathImplementation {
		addPropertyChangeListener(PropertyChangeListener listener)
				=> changes.addPropertyChangeListener(listener);
		
		removePropertyChangeListener(PropertyChangeListener listener)
				=> changes.removePropertyChangeListener(listener);
		
		resources => classpathResourcesRef.get(type);
	}
}
