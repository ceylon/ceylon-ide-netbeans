import org.eclipse.ceylon.ide.common.model {
    IdeModuleSourceMapper,
    BaseIdeModule
}
import org.netbeans.api.project {
    Project
}
import org.openide.filesystems {
    FileObject
}
import org.eclipse.ceylon.compiler.typechecker.context {
    Context
}
import org.eclipse.ceylon.ide.common.platform {
    platformUtils,
    Status
}

class NbModuleSourceMapper(Context context, NbModuleManager manager)
        extends IdeModuleSourceMapper<Project,FileObject,FileObject,FileObject>
        (context, manager) {
    
    defaultCharset => "UTF-8";
    
    logModuleResolvingError(BaseIdeModule mod, Exception e) =>
        platformUtils.log(Status._ERROR,
            "Failed to resolve module " + mod.signature, e);
}
