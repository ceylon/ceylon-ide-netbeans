import com.redhat.ceylon.ide.common.model {
    CeylonBinaryUnit,
    IJavaModelAware,
    CrossProjectBinaryUnit,
    JavaCompilationUnit,
    JavaClassFile,
    CrossProjectJavaCompilationUnit,
    BaseCeylonProject
}
import com.redhat.ceylon.ide.common.util {
    BaseProgressMonitor
}
import com.redhat.ceylon.model.loader.model {
    LazyPackage
}
import com.redhat.ceylon.model.typechecker.model {
    Package,
    Declaration
}

import javax.lang.model.element {
    TypeElement
}

import org.netbeans.api.project {
    Project
}
import org.openide.filesystems {
    FileObject
}

shared interface NbJavaModelAware
        satisfies IJavaModelAware<Project,TypeElement,TypeElement> {
    
    shared actual Project javaClassRootToNativeProject(TypeElement javaClassRoot)
            => nothing; // TODO
    
    shared actual TypeElement? toJavaElement(Declaration ceylonDeclaration,
        BaseProgressMonitor? monitor) => null; // TODO
}

shared class NbCeylonBinaryUnit(
    TypeElement cls,
    String filename,
    String relativePath,
    String fullPath,
    Package pkg
)
        extends CeylonBinaryUnit<Project,TypeElement,TypeElement>
        (cls, filename, relativePath, fullPath, pkg)
        satisfies NbJavaModelAware {
    
}

shared class NbCrossProjectBinaryUnit(
    TypeElement cls,
    String filename,
    String relativePath,
    String fullPath,
    Package pkg
)
        extends CrossProjectBinaryUnit<Project,FileObject,FileObject,FileObject,TypeElement,TypeElement>
        (cls, filename, relativePath, fullPath, pkg)
        satisfies NbJavaModelAware {
    
}

shared class NbJavaCompilationUnit(
    TypeElement cls,
    String filename,
    String relativePath,
    String fullPath,
    LazyPackage pkg
)
        extends JavaCompilationUnit<Project,FileObject,FileObject,TypeElement,TypeElement>
        (cls, filename, relativePath, fullPath, pkg)
        satisfies NbJavaModelAware {
    
    // TODO
    shared actual FileObject? javaClassRootToNativeFile(TypeElement javaClassRoot) => null;
    
    // TODO
    shared actual FileObject? javaClassRootToNativeRootFolder(TypeElement javaClassRoot) => null;
}

shared class NbJavaClassFile(
    TypeElement cls,
    String filename,
    String relativePath,
    String fullPath,
    LazyPackage pkg
)
        extends JavaClassFile<Project,FileObject,FileObject,TypeElement,TypeElement>
        (cls, filename, relativePath, fullPath, pkg)
        satisfies NbJavaModelAware {
    
    // TODO
    shared actual FileObject? javaClassRootToNativeFile(TypeElement javaClassRoot) => null;
    
    // TODO
    shared actual FileObject? javaClassRootToNativeRootFolder(TypeElement javaClassRoot) => null;
}

shared class NbCrossProjectJavaCompilationUnit(
    BaseCeylonProject ceylonProject,
    TypeElement cls,
    String filename,
    String relativePath,
    String fullPath,
    LazyPackage pkg)
        extends CrossProjectJavaCompilationUnit<Project,FileObject,FileObject,TypeElement,TypeElement>
        (ceylonProject, cls, filename, relativePath, fullPath, pkg)
        satisfies NbJavaModelAware {
    
    shared actual FileObject? javaClassRootToNativeFile(TypeElement cls)
            => null; // TODO
    
    shared actual FileObject? javaClassRootToNativeRootFolder(TypeElement cls)
            => null; // TODO
}
