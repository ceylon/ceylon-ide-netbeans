import ceylon.collection {
	HashMap
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
import com.redhat.ceylon.ide.netbeans.project {
	CeylonIdeClasspathProvider
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
import org.netbeans.api.project {
	Project,
	ProjectInformation
}
import org.openide.filesystems {
	FileObject,
	FileUtil
}
import org.openide.modules {
	InstalledFileLocator
}

shared class NbCeylonProject(NbCeylonProjects projects, Project nativeProject)
        extends CeylonProject<Project,FileObject,FileObject,FileObject>() {

    loadBinariesFirst => true;

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
                ArtifactContext(null, moduleName, moduleVersion, ArtifactContext.car)
            );
        }
        
        shared actual void beforeClasspathResolution(CeylonProjectBuildAlias build, CeylonProjectBuildAlias.State state) {
            if (! languageModuleAdded) {
                if (exists file = findLanguageCar()) {
                    addDependencyToClasspath(file);
                    languageModuleAdded = true;
                } else {
                    platformUtils.log(Status._ERROR, "Could not locate ceylon.language.car");
                }
            }
        }
        
        repositoryManagerReset(CeylonProjectAlias ceylonProject)
                => languageModuleAdded = false;
    }

	shared void addDependencyToClasspath(File dependency) {
		value provider = {
			for (lkp in nativeProject.lookup.lookupAll(`Object`))
			if (is CeylonIdeClasspathProvider lkp)
			lkp
		}.first;
		
		if (is CeylonIdeClasspathProvider provider) {
			provider.addRoot(FileUtil.urlForArchiveOrDir(dependency), ClassPath.compile);
		} else {
			print("Project has no instance of CeylonIdeClasspathProvider in its lookup");
			//value fo = FileUtil.toFileObject(dependency);
			//for (group in ProjectUtils.getSources(nativeProject)
			//		.getSourceGroups(JavaProjectConstants.sourcesTypeJava)) {
			//	//group.
			//}
			//ProjectClassPathModifier.addRoots(
			//	createJavaObjectArray({FileUtil.getArchiveRoot(fo).toURI()}),
			//	nativeProject.projectDirectory,
			//	ClassPath.compile
			//);
		}
	}
	
    compileToJava => ideConfiguration.compileToJvm else false;
    
    compileToJs => ideConfiguration.compileToJs else false;
    
    completeCeylonModelParsing(BaseProgressMonitorChild monitor)
            => noop();
    
    createNewOutputFolder(String folderProjectRelativePath)
            => noop();
    
    createOverridesProblemMarker(Exception theOverridesException,
        File absoluteFile, Integer overridesLine, Integer overridesColumn)
            => noop();
    
    deleteOldOutputFolder(String folderProjectRelativePath)
            => noop();
    
    hasConfigFile => true;
    
    ideArtifact => nativeProject;
    
    model => projects;
    
    moduleManagerFactory => object satisfies ModuleManagerFactory {
        createModuleManager(Context context)
                => NbModuleManager(context.repositoryManager, outer);
        
        shared actual ModuleSourceMapper createModuleManagerUtil
        (Context context, ModuleManager moduleManager) {
            assert(is NbModuleManager moduleManager);
            return NbModuleSourceMapper(context, moduleManager);
        }
    };
    
    name => nativeProject.lookup.lookup(`ProjectInformation`).name;
    
    refreshConfigFile(String projectRelativePath)
            => noop();
    
    removeOverridesProblemMarker()
            => noop();
    
    rootDirectory => FileUtil.toFile(nativeProject.projectDirectory);
    
    synchronizedWithConfiguration => true;
    
    systemRepository => 
            InstalledFileLocator.default.locate(
                "ceylon/embeddedDist/repo",
                "com.redhat.ceylon.ide.netbeans",
                false
            ).absolutePath;
        
    buildHooks => {addModuleArchiveHook};
}
