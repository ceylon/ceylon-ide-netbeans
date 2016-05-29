import com.redhat.ceylon.ide.common.model {
    BaseCeylonProject
}
import com.redhat.ceylon.ide.common.platform {
    JavaModelServices
}
import com.redhat.ceylon.ide.netbeans.model {
    NbJavaCompilationUnit,
    NbJavaClassFile,
    NbCeylonBinaryUnit,
    NbCrossProjectBinaryUnit,
    NbCrossProjectJavaCompilationUnit
}
import com.redhat.ceylon.ide.netbeans.model.mirrors {
    TypeElementMirror
}
import com.redhat.ceylon.model.loader.mirror {
    ClassMirror
}
import com.redhat.ceylon.model.loader.model {
    LazyPackage
}

import javax.lang.model.element {
    TypeElement
}

object nbJavaModelServices satisfies JavaModelServices<TypeElement> {
    
    shared actual TypeElement? getJavaClassRoot(ClassMirror classMirror)
            => if (is TypeElementMirror classMirror)
                then classMirror.te
                else null;
    
    newCeylonBinaryUnit(TypeElement typeRoot, String relativePath,
        String fileName, String fullPath, LazyPackage pkg)
            => NbCeylonBinaryUnit(typeRoot, fileName, relativePath, fullPath, pkg);
    
    newCrossProjectBinaryUnit(TypeElement typeRoot, 
        String relativePath, String fileName, String fullPath, LazyPackage pkg)
            => NbCrossProjectBinaryUnit(typeRoot, fileName, relativePath, fullPath, pkg);
    
    newJavaClassFile(TypeElement typeRoot, 
        String relativePath, String fileName, String fullPath, LazyPackage pkg)
            => NbJavaClassFile(typeRoot, fileName, relativePath, fullPath, pkg);
    
    newJavaCompilationUnit(TypeElement typeRoot, 
        String relativePath, String fileName, String fullPath, LazyPackage pkg)
            => NbJavaCompilationUnit(typeRoot, fileName, relativePath, fullPath, pkg);

    newCrossProjectJavaCompilationUnit(BaseCeylonProject ceylonProject, 
        TypeElement typeRoot, String relativePath, String fileName,
        String fullPath, LazyPackage pkg)
            => NbCrossProjectJavaCompilationUnit(ceylonProject, typeRoot, fileName, relativePath, fullPath, pkg);
    
}