import ceylon.interop.java {
    javaClass,
    createJavaObjectArray,
    javaString
}

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

import javax.lang.model.element {
    TypeElement
}

import org.netbeans.api.java.classpath {
    ClassPath
}
import org.netbeans.api.java.project.classpath {
    ProjectClassPathModifier
}
import org.netbeans.api.java.source {
    ClasspathInfo,
    JavaSource,
    Task,
    CompilationController
}
import org.netbeans.api.project {
    Project
}
import org.netbeans.spi.java.classpath {
    ClassPathProvider
}
import org.openide.filesystems {
    FileObject,
    FileUtil
}

class NbModelLoader(NbCeylonProject project, NbModuleManager mm, NbModuleSourceMapper msm, Modules modules)
        extends IdeModelLoader<Project,FileObject,FileObject,FileObject,TypeElement,TypeElement>
        (mm, msm, modules) {
    
    value cpProvider = project.ideArtifact.lookup
            .lookup(javaClass<ClassPathProvider>());
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
        
        shared actual Boolean packageExists(String quotedPackageName) => false;
        
        shared actual {TypeElement*}? packageMembers(String quotedPackageName) => null;
        
        shared actual Boolean shouldBeOmitted(TypeElement type) => false;
    }
    
    shared actual void addModuleToClasspathInternal(ArtifactResult? artifact) {
        if (exists file = artifact?.artifact()) {         
            value fo = FileUtil.toFileObject(file);
            ProjectClassPathModifier.addRoots(
                createJavaObjectArray({FileUtil.getArchiveRoot(fo).toURI()}),
                project.sourceFolders.first?.nativeResource,
                ClassPath.compile
            );
        }
    }
    
    shared actual ClassMirror? buildClassMirrorInternal(String name) {
        value cpInfo = ClasspathInfo.create(bootCp, compilerCp, null);
        
        value unparameterized = 
                if (exists lt = name.firstOccurrence('<'), lt > 0)
                then name.spanTo(lt - 1)
                else name;

        value js = JavaSource.create(cpInfo);
        
        variable TypeElement? te = null;
        
        // TODO is this expensive?
        js.runUserActionTask(object satisfies Task<CompilationController> {
            shared actual void run(CompilationController ctrl) {
                te = ctrl.elements.getTypeElement(javaString(unparameterized));
            }
        }, true);
        
        if (exists _te = te) {
            return TypeElementMirror(_te);
        }
        
        //print("not found ``simpleName`` => ``name``");
        return null;
    }
    
    shared actual Boolean isOverloadingMethod(MethodMirror? methodMirror) {
        return false;
    }
    
    shared actual Boolean isOverridingMethod(MethodMirror? methodMirror) => false;
    
    shared actual Boolean moduleContainsClass(BaseIdeModule ideModule, 
        String packageName, String className) => false;
    
    
    typeExists(TypeElement type) => true;
    
    typeName(TypeElement type) => type.simpleName.string;
}