import ceylon.interop.java {
    javaClass
}

import com.redhat.ceylon.ide.common.model.parsing {
    RootFolderScanner
}
import com.redhat.ceylon.ide.common.platform {
    ModelServices
}
import com.redhat.ceylon.ide.netbeans.model {
    NbCeylonProject
}

import org.netbeans.api.java.project {
    JavaProjectConstants {
        sourcesTypeResources,
        sourcesTypeJava
    }
}
import org.netbeans.api.project {
    Project,
    Sources,
    SourceGroup
}
import org.openide.filesystems {
    FileObject
}
import com.redhat.ceylon.ide.common.model {
    ProjectSourceFile,
    EditedSourceFile,
    CrossProjectSourceFile
}

object nbModelServices 
        satisfies ModelServices<Project,FileObject,FileObject,FileObject> {
    
    shared actual Boolean isResourceContainedInProject(FileObject resource, 
        CeylonProjectAlias ceylonProject) {
        
        return false;
    }
    
    nativeProjectIsAccessible(Project nativeProject) => true;
    
    newCrossProjectSourceFile(CrossProjectPhasedUnitAlias phasedUnit)
            => CrossProjectSourceFile(phasedUnit);
    
    newEditedSourceFile(EditedPhasedUnitAlias phasedUnit)
            => EditedSourceFile(phasedUnit);
    
    newProjectSourceFile(ProjectPhasedUnitAlias phasedUnit)
            => ProjectSourceFile(phasedUnit);
    
    referencedNativeProjects(Project nativeProject) => empty;
    
    referencingNativeProjects(Project nativeProject) => empty;
    
    resourceNativeFolders(CeylonProjectAlias ceylonProject)
            => listFolders(ceylonProject, sourcesTypeResources);
    
    shared actual void scanRootFolder(RootFolderScanner<Project,FileObject,FileObject,FileObject> scanner) {
        visit(scanner.nativeRootDir, scanner);
    }
    
    void visit(FileObject obj, RootFolderScanner<Project,FileObject,FileObject,FileObject> scanner) {
        if (obj.folder) {
            for (child in obj.children) {
                scanner.visitNativeResource(child);
                visit(child, scanner);
            }
        }
    }
    
    sourceNativeFolders(CeylonProjectAlias ceylonProject)
            => listFolders(ceylonProject, sourcesTypeJava);
    
    {FileObject*} listFolders(CeylonProjectAlias ceylonProject, String type) {
        if (is NbCeylonProject ceylonProject) {
            value sources = ceylonProject.ideArtifact.lookup.lookup(javaClass<Sources>());
            
            return sources.getSourceGroups(type)
                    .iterable.coalesced
                    .map(SourceGroup.rootFolder);
        }
        
        return empty;
    }   
}
