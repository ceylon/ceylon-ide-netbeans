import com.redhat.ceylon.ide.common.platform {
    PlatformServices,
    VfsServices,
    ModelServices,
    CommonDocument,
    JavaModelServices
}
import com.redhat.ceylon.ide.common.util {
    unsafeCast
}
import com.redhat.ceylon.ide.netbeans.correct {
    NbDocument
}
import com.redhat.ceylon.model.typechecker.model {
    Unit
}

shared object nbPlatformServices satisfies PlatformServices {
    
    completion => nbCompletionServices;
    
    shared actual NbLinkedMode createLinkedMode(CommonDocument document) {
        assert(is NbDocument document);
        return NbLinkedMode(document);
    }
    
    document => nbDocumentServices;
    
    gotoLocation(Unit unit, Integer offset, Integer length) => null;
    
    shared actual ModelServices<NativeProject,NativeResource,NativeFolder,NativeFile>
    model<NativeProject, NativeResource, NativeFolder, NativeFile>()
            => unsafeCast<ModelServices<NativeProject,NativeResource,NativeFolder,NativeFile>>(nbModelServices);
    
    utils() => nbIdeUtils;
    
    shared actual VfsServices<NativeProject,NativeResource,NativeFolder,NativeFile>
    vfs<NativeProject, NativeResource, NativeFolder, NativeFile>()
            => unsafeCast<VfsServices<NativeProject,NativeResource,NativeFolder,NativeFile>>(nbVfsServices);
    
    shared actual JavaModelServices<JavaClassRoot> 
    javaModel<JavaClassRoot>()
            => unsafeCast<JavaModelServices<JavaClassRoot>>(nbJavaModelServices);
    
}