import com.redhat.ceylon.ide.common.platform {
    PlatformServices,
    VfsServices,
    ModelServices,
    LinkedMode,
    CompletionServices,
    CommonDocument
}
import com.redhat.ceylon.ide.common.util {
    unsafeCast
}
import com.redhat.ceylon.model.typechecker.model {
    Unit
}

shared object nbPlatformServices satisfies PlatformServices {
    
    shared actual CompletionServices completion => nothing;
    
    shared actual LinkedMode createLinkedMode(CommonDocument document) => nothing;
    
    document => nbDocumentServices;
    
    shared actual CommonDocument? gotoLocation(Unit unit, Integer offset, Integer length) => null;
    
    shared actual ModelServices<NativeProject,NativeResource,NativeFolder,NativeFile>
    model<NativeProject, NativeResource, NativeFolder, NativeFile>()
            => unsafeCast<ModelServices<NativeProject,NativeResource,NativeFolder,NativeFile>>(nbModelServices);
    
    utils() => nbIdeUtils;
    
    shared actual VfsServices<NativeProject,NativeResource,NativeFolder,NativeFile>
    vfs<NativeProject, NativeResource, NativeFolder, NativeFile>()
            => unsafeCast<VfsServices<NativeProject,NativeResource,NativeFolder,NativeFile>>(nbVfsServices);
}