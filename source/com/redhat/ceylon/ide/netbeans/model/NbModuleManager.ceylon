import org.eclipse.ceylon.cmr.api {
    RepositoryManager
}
import org.eclipse.ceylon.ide.common.model {
    IdeModuleManager,
    BaseIdeModelLoader,
    BaseIdeModuleManager,
    BaseIdeModuleSourceMapper,
    BaseIdeModule,
    BaseCeylonProject
}
import org.eclipse.ceylon.model.typechecker.model {
    Modules,
    Module
}

import org.netbeans.api.java.project {
    JavaProjectConstants
}
import org.netbeans.api.project {
    Project,
    ProjectUtils
}
import org.openide.filesystems {
    FileObject
}

class NbModuleManager(shared RepositoryManager repositoryManager, NbCeylonProject project)
        extends IdeModuleManager<Project,FileObject,FileObject,FileObject>(project.model, project) {
    
    shared actual Boolean moduleFileInProject(String moduleName, 
        BaseCeylonProject? ceylonProject) {
        
        value sources = ProjectUtils.getSources(project.ideArtifact)
                .getSourceGroups(JavaProjectConstants.sourcesTypeJava);
        
        value modulePath = moduleName.replace(".", "/") + Module.defaultModuleName;
        
        for (source in sources) {
            if (exists _ = source.rootFolder.getFileObject(modulePath)) {
                return true;
            }
        }
        return false;
    }
    
    shared actual BaseIdeModelLoader newModelLoader(BaseIdeModuleManager self,
        BaseIdeModuleSourceMapper sourceMapper, Modules modules) {
        
        assert(is NbModuleManager self, is NbModuleSourceMapper sourceMapper);
        
        return NbModelLoader(project, self, sourceMapper, modules);
    }
    
    shared actual BaseIdeModule newModule(String moduleName, String version) {
        assert(is NbModuleSourceMapper msm = moduleSourceMapper);
        
        return NbModule(this, msm);
    }
}
