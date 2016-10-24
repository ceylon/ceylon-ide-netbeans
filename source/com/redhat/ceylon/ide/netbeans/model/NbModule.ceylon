import com.redhat.ceylon.ide.common.model {
    IdeModule,
    BaseIdeModule
}

import org.netbeans.api.project {
    Project
}
import org.openide.filesystems {
    FileObject,
    FileUtil
}
import ceylon.collection {
    HashSet
}
import com.redhat.ceylon.model.cmr {
    JDKUtils
}
import com.redhat.ceylon.cmr.api {
    RepositoryManager,
    ArtifactContext
}
import java.io {
    File
}
import ceylon.interop.java {
	CeylonStringIterable
}

class NbModule(NbModuleManager mm, NbModuleSourceMapper msm)
        extends IdeModule<Project,FileObject,FileObject,FileObject>() {
    
    value packageList = HashSet<String>();
    
    shared actual Set<String> listPackages() {
        value name = nameAsString;
        if (JDKUtils.isJDKModule(name)) {
            packageList.addAll(CeylonStringIterable(
                JDKUtils.getJDKPackagesByModule(name)));
        } else if (JDKUtils.isOracleJDKModule(name)) {
            packageList.addAll(CeylonStringIterable(
                JDKUtils.getOracleJDKPackagesByModule(name)));
        } else if (java) {
            if (!moduleManager.isExternalModuleLoadedFromSource(nameAsString),
                exists mod = ceylonProject,
                packageList.empty) {
                
                scanPackages(mod.ideArtifact);
            }
        }
        
        return packageList;
    }
    
    void scanPackages(Project mod) {
        if (exists jarToSearch = returnCarFile()
            else getModuleArtifact(moduleManager.repositoryManager, this),
            exists fo = FileUtil.toFileObject(jarToSearch),
            exists root = FileUtil.getArchiveRoot(fo)) {
            
            listPackagesInternal(fo);
        }
    }
    
    void listPackagesInternal(FileObject fo, String parentPackage = "") {
        fo.children.array.coalesced
                .filter((_) => _.folder)
                .each((child) {
                    String pack =
                            (parentPackage.empty then "" else parentPackage + ".")
                            + child.name;
                    packageList.add(pack);
                    listPackagesInternal(child, pack);
                }
        );
    }

    File? getModuleArtifact(RepositoryManager provider, BaseIdeModule mod) {
        if (!mod.isSourceArchive) {
            File? moduleFile = mod.artifact;
            if (!exists moduleFile) {
                return null;
            }
            
            if (moduleFile.\iexists()) {
                return moduleFile;
            }
        }
        
        variable ArtifactContext ctx = ArtifactContext(null, mod.nameAsString, mod.version,
            ArtifactContext.car);
        variable File? moduleArtifact = provider.getArtifact(ctx);
        if (!exists a = moduleArtifact) {
            ctx = ArtifactContext(null, mod.nameAsString, mod.version,
                ArtifactContext.jar);
            moduleArtifact = provider.getArtifact(ctx);
        }
        
        return moduleArtifact;
    }

    
    modelLoader => mm.modelLoader;
    
    shared actual NbModuleManager moduleManager => mm;
    
    moduleSourceMapper => msm;
    
    refreshJavaModel() => noop();
}
