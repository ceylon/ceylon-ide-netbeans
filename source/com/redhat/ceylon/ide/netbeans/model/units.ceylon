import com.redhat.ceylon.ide.common.model {
    CeylonBinaryUnit,
    IJavaModelAware,
    CrossProjectBinaryUnit,
    JavaCompilationUnit,
    JavaClassFile
}
import org.netbeans.api.project {
    Project
}
import javax.lang.model.element {
    TypeElement
}
import com.redhat.ceylon.model.typechecker.model {
    Package,
    Declaration
}
import com.redhat.ceylon.ide.common.util {
    BaseProgressMonitor
}
import org.openide.filesystems {
    FileObject
}

interface NbJavaModelAware
        satisfies IJavaModelAware<Project,TypeElement,TypeElement> {
    
    shared actual Project javaClassRootToNativeProject(TypeElement javaClassRoot)
            => nothing; // TODO
    
    shared actual TypeElement? toJavaElement(Declaration ceylonDeclaration,
        BaseProgressMonitor? monitor) => null; // TODO
}

class NbCeylonBinaryUnit(
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

class NbCrossProjectBinaryUnit(
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

class NbJavaCompilationUnit(
    TypeElement cls,
    String filename,
    String relativePath,
    String fullPath,
    Package pkg
)
        extends JavaCompilationUnit<Project,FileObject,FileObject,TypeElement,TypeElement>
        (cls, filename, relativePath, fullPath, pkg)
        satisfies NbJavaModelAware {
    
    // TODO
    shared actual FileObject? javaClassRootToNativeFile(TypeElement javaClassRoot) => null;
    
    // TODO
    shared actual FileObject? javaClassRootToNativeRootFolder(TypeElement javaClassRoot) => null;
}

class NbJavaClassFile(
    TypeElement cls,
    String filename,
    String relativePath,
    String fullPath,
    Package pkg
)
        extends JavaClassFile<Project,FileObject,FileObject,TypeElement,TypeElement>
        (cls, filename, relativePath, fullPath, pkg)
        satisfies NbJavaModelAware {
    
    // TODO
    shared actual FileObject? javaClassRootToNativeFile(TypeElement javaClassRoot) => null;
    
    // TODO
    shared actual FileObject? javaClassRootToNativeRootFolder(TypeElement javaClassRoot) => null;
}
