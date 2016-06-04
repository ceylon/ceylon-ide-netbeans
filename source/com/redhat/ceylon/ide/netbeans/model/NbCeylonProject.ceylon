import ceylon.collection {
    HashMap
}
import ceylon.interop.java {
    javaClass,
    createJavaObjectArray
}

import com.redhat.ceylon.cmr.api {
    ArtifactContext
}
import com.redhat.ceylon.compiler.typechecker {
    TypeChecker
}
import com.redhat.ceylon.compiler.typechecker.analyzer {
    ModuleSourceMapper
}
import com.redhat.ceylon.compiler.typechecker.context {
    Context
}
import com.redhat.ceylon.compiler.typechecker.util {
    ModuleManagerFactory
}
import com.redhat.ceylon.ide.common.model {
    CeylonProject,
    BuildHook
}
import com.redhat.ceylon.ide.common.platform {
    platformUtils,
    Status
}
import com.redhat.ceylon.ide.common.util {
    BaseProgressMonitorChild
}
import com.redhat.ceylon.ide.common.vfs {
    FolderVirtualFile
}
import com.redhat.ceylon.model.typechecker.model {
    Package
}
import com.redhat.ceylon.model.typechecker.util {
    ModuleManager
}

import java.io {
    File
}
import java.lang.ref {
    WeakReference
}

import org.netbeans.api.java.classpath {
    ClassPath
}
import org.netbeans.api.java.project.classpath {
    ProjectClassPathModifier
}
import org.netbeans.api.project {
    Project,
    ProjectInformation
}
import org.openide.filesystems {
    FileObject,
    FileUtil
}

shared class NbCeylonProject(NbCeylonProjects projects, Project nativeProject)
        extends CeylonProject<Project,FileObject,FileObject,FileObject>() {

    variable Boolean languageModuleAdded = false;

    shared object filePropertyHolder {
        shared HashMap<FileObject,WeakReference<Package>> packages =
                HashMap<FileObject, WeakReference<Package>>();

        shared HashMap<FileObject,Boolean> rootIsSources =
                HashMap<FileObject, Boolean>();

        shared HashMap<FileObject,WeakReference<FolderVirtualFile<Project,FileObject,FileObject,FileObject>>> roots =
                HashMap<FileObject, WeakReference<FolderVirtualFile<Project,FileObject,FileObject,FileObject>>>();
    }

    object addModuleArchiveHook
            satisfies BuildHook<Project,FileObject,FileObject,FileObject> {
        
        File? findLanguageCar() {
            String moduleName = "ceylon.language";
            String moduleVersion = TypeChecker.languageModuleVersion;
            
            return repositoryManager.getArtifact(
                ArtifactContext(moduleName, moduleVersion, ArtifactContext.car)
            );
        }
        
        shared actual void beforeClasspathResolution(CeylonProjectBuildAlias build, CeylonProjectBuildAlias.State state) {
            if (! languageModuleAdded) {
                if (exists file = findLanguageCar()) {
                    ProjectClassPathModifier.addRoots(
                        createJavaObjectArray({FileUtil.getArchiveRoot(file.toURI().toURL()).toURI()}),
                        sourceFolders.first?.nativeResource,
                        ClassPath.compile
                    );
                    
                    languageModuleAdded = true;
                } else {
                    platformUtils.log(Status._ERROR, "Could not locate ceylon.language.car");
                }
            }
        }
        
        shared actual void repositoryManagerReset(CeylonProjectAlias ceylonProject) {
            languageModuleAdded = false;
        }
    }

    compileToJava => ideConfiguration.compileToJvm else false;
    
    compileToJs => ideConfiguration.compileToJs else false;
    
    shared actual void completeCeylonModelParsing(BaseProgressMonitorChild monitor) {}
    
    shared actual void createNewOutputFolder(String folderProjectRelativePath) {}
    
    shared actual void createOverridesProblemMarker(Exception theOverridesException,
        File absoluteFile, Integer overridesLine, Integer overridesColumn) {}
    
    shared actual void deleteOldOutputFolder(String folderProjectRelativePath) {}
    
    shared actual Boolean hasConfigFile => true;
    
    ideArtifact => nativeProject;
    
    shared actual NbCeylonProjects model => projects;
    
    moduleManagerFactory => object satisfies ModuleManagerFactory {
        createModuleManager(Context context)
                => NbModuleManager(context.repositoryManager, outer);
        
        shared actual ModuleSourceMapper createModuleManagerUtil
        (Context context, ModuleManager moduleManager) {
            assert(is NbModuleManager moduleManager);
            return NbModuleSourceMapper(context, moduleManager);
        }
    };
    
    name => nativeProject.lookup.lookup(javaClass<ProjectInformation>()).name;
    
    shared actual void refreshConfigFile() {}
    
    shared actual void removeOverridesProblemMarker() {}
    
    rootDirectory => FileUtil.toFile(nativeProject.projectDirectory);
    
    synchronizedWithConfiguration => true;
    
    shared actual String systemRepository
            => "/Users/bastien/Dev/ceylon/ceylon/dist/dist/repo"; // TODO
        
    buildHooks => {addModuleArchiveHook};

}