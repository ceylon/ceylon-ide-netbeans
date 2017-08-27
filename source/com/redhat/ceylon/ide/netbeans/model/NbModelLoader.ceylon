import com.redhat.ceylon.ide.common.model {
	IdeModelLoader,
	BaseIdeModule
}
import com.redhat.ceylon.ide.netbeans.model.mirrors {
	TypeElementMirror
}
import com.redhat.ceylon.model.cmr {
	ArtifactResult
}
import com.redhat.ceylon.model.loader.mirror {
	ClassMirror,
	MethodMirror
}
import com.redhat.ceylon.model.typechecker.model {
	Modules
}

import java.lang {
	Types
}

import javax.lang.model.element {
	TypeElement
}

import org.netbeans.api.java.classpath {
	ClassPath
}
import org.netbeans.api.java.source {
	ClasspathInfo,
	JavaSource,
	CompilationController
}
import org.netbeans.api.project {
	Project
}
import org.netbeans.modules.parsing.impl {
	Utilities
}
import org.netbeans.spi.java.classpath {
	ClassPathProvider
}
import org.openide.filesystems {
	FileObject
}

class NbModelLoader(NbCeylonProject project, NbModuleManager mm, NbModuleSourceMapper msm, Modules modules)
        extends IdeModelLoader<Project,FileObject,FileObject,FileObject,TypeElement,TypeElement>
        (mm, msm, modules) {
    
    value cpProvider = project.ideArtifact.lookup
            .lookup(`ClassPathProvider`);
    value bootCp => findClasspath(ClassPath.boot);
    value compilerCp => findClasspath(ClassPath.compile);
    
    ClassPath? findClasspath(String type) {
        if (exists sourceFolder = project.sourceFolders.first) {
            return cpProvider.findClassPath(sourceFolder.nativeResource, type);
        }
        return null;
    }
    
    shared actual class PackageLoader(BaseIdeModule ideModule)
             extends super.PackageLoader(ideModule) {
        
        packageExists(String quotedPackageName) => false;
        
        packageMembers(String quotedPackageName) => null;
        
        shouldBeOmitted(TypeElement type) => false;
    }
    
    shared actual void addModuleToClasspathInternal(ArtifactResult? artifact) {
        if (exists file = artifact?.artifact()) {         
            project.addDependencyToClasspath(file);
        }
    }
    
    shared actual ClassMirror? buildClassMirrorInternal(String name) {
        assert(exists _bootCp = bootCp);
        assert(exists _compilerCp = compilerCp);
        value cpInfo = ClasspathInfo.create(_bootCp, _compilerCp, null);
        
        value unparameterized = 
                if (exists lt = name.firstOccurrence('<'), lt > 0)
                then name.spanTo(lt - 1)
                else name;

        value js = JavaSource.create(cpInfo);
        
        variable TypeElement? te = null;
        
        Utilities.acquireParserLock();
        
        try {
	        js.runUserActionTask(
	            (CompilationController ctrl) {
	                te = ctrl.elements.getTypeElement(Types.nativeString(unparameterized));
	            },
	            true
	        );
	    } finally {
	        Utilities.releaseParserLock();
	    }
        
        if (exists _te = te) {
            return TypeElementMirror(_te);
        }
        
        //print("not found ``unparameterized`` => ``name``");
        return null;
    }
    
    isOverloadingMethod(MethodMirror? methodMirror) => false;
    
    isOverridingMethod(MethodMirror? methodMirror) => false;
    
    moduleContainsClass(BaseIdeModule ideModule, 
        String packageName, String className) => false;
    
    typeExists(TypeElement type) => true;
    
    typeName(TypeElement type) => type.simpleName.string;
}
