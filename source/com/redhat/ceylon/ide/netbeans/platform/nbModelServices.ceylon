import org.eclipse.ceylon.ide.common.model {
    ProjectSourceFile,
    EditedSourceFile,
    CrossProjectSourceFile
}
import org.eclipse.ceylon.ide.common.model.parsing {
    RootFolderScanner
}
import org.eclipse.ceylon.ide.common.platform {
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
    SourceGroup,
    ProjectUtils
}
import org.openide.filesystems {
    FileObject,
    FileUtil
}

object nbModelServices 
        satisfies ModelServices<Project,FileObject,FileObject,FileObject> {
    
    shared actual Boolean isResourceContainedInProject(FileObject resource, 
        CeylonProjectAlias ceylonProject) {
        
        value roots = ProjectUtils.getSources(ceylonProject.ideArtifact)
                .getSourceGroups(JavaProjectConstants.sourcesTypeJava);

        for (root in roots) {
            if (FileUtil.isParentOf(root.rootFolder, resource)
                || root.rootFolder == resource) {
                
                return true;
            }
        }
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
    
    scanRootFolder(RootFolderScanner<Project,FileObject,FileObject,FileObject> scanner)
        	=> visit(scanner.nativeRootDir, scanner);
    
    void visit(FileObject obj, RootFolderScanner<Project,FileObject,FileObject,FileObject> scanner) {
        scanner.visitNativeResource(obj);

        if (obj.folder) {
            for (child in obj.children) {
                visit(child, scanner);
            }
        }
    }
    
    sourceNativeFolders(CeylonProjectAlias ceylonProject)
            => listFolders(ceylonProject, sourcesTypeJava);
    
    {FileObject*} listFolders(CeylonProjectAlias ceylonProject, String type) {
        if (is NbCeylonProject ceylonProject) {
            value sources = ProjectUtils.getSources(ceylonProject.ideArtifact);
            
            return sources.getSourceGroups(type)
                    .iterable.coalesced
                    .map(SourceGroup.rootFolder);
        }
        
        return empty;
    }   
}
