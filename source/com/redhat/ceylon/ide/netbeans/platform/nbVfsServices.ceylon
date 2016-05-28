import ceylon.interop.java {
    javaClass
}

import com.redhat.ceylon.ide.common.platform {
    VfsServices
}
import com.redhat.ceylon.ide.common.util {
    Path
}
import com.redhat.ceylon.ide.common.vfs {
    FileVirtualFile,
    FolderVirtualFile,
    ResourceVirtualFile
}
import com.redhat.ceylon.ide.netbeans.model {
    NbCeylonProjects
}
import com.redhat.ceylon.model.typechecker.model {
    Package
}

import java.io {
    File
}
import java.lang.ref {
    WeakReference
}
import java.util {
    List,
    ArrayList
}

import org.netbeans.api.project {
    Project
}
import org.openide.filesystems {
    FileObject,
    FileUtil
}
import org.openide.util {
    Lookup
}

object nbVfsServices
        satisfies VfsServices<Project,FileObject,FileObject,FileObject> {
    
    createVirtualFile(FileObject file, Project project)
            => NbFileVirtualFile(project, file);
    
    createVirtualFileFromProject(Project project, Path path)
            => NbFileVirtualFile(project, FileUtil.toFileObject(path.file));
    
    createVirtualFolder(FileObject folder, Project project)
            => NbFolderVirtualFile(project, folder);
    
    createVirtualFolderFromProject(Project project, Path path)
            => NbFolderVirtualFile(project, FileUtil.toFileObject(path.file));
    
    existsOnDisk(FileObject resource) => !resource.virtual;
    
    findChild(FileObject|Project parent, Path path)
            => if (is FileObject parent)
                then parent.getFileObject(path.string)
                else parent.projectDirectory.getFileObject(path.string);
    
    findFile(FileObject resource, String fileName)
            => resource.getFileObject(fileName);
    
    fromJavaFile(File javaFile, Project project)
            => FileUtil.toFileObject(javaFile);
    
    getJavaFile(FileObject resource) => FileUtil.toFile(resource);
    
    // TODO
    getPackagePropertyForNativeFolder(CeylonProjectAlias ceylonProject, FileObject folder)
            => null;
    
    getParent(FileObject resource) => resource.parent;
    
    // TODO
    shared actual Path? getProjectRelativePath(FileObject resource, CeylonProjectAlias|Project project) => null;
    
    // TODO
    shared actual String? getProjectRelativePathString(FileObject resource, CeylonProjectAlias|Project project) => null;
    
    // TODO
    shared actual Boolean? getRootIsSourceProperty(CeylonProjectAlias ceylonProject, FileObject rootFolder) => false;
    
    // TODO
    getRootPropertyForNativeFolder(CeylonProjectAlias ceylonProject, FileObject folder) => null;
    
    getShortName(FileObject resource) => resource.nameExt;
    
    getVirtualFilePath(FileObject resource) => Path(resource.path);
    
    getVirtualFilePathString(FileObject resource) => resource.path;
    
    isFolder(FileObject resource) => resource.folder;
    
    // TODO
    shared actual void removePackagePropertyForNativeFolder(CeylonProjectAlias ceylonProject, FileObject folder) {}
    
    // TODO
    shared actual void removeRootIsSourceProperty(CeylonProjectAlias ceylonProject, FileObject rootFolder) {}
    
    // TODO
    shared actual void removeRootPropertyForNativeFolder(CeylonProjectAlias ceylonProject, FileObject folder) {}
    
    // TODO
    shared actual void setPackagePropertyForNativeFolder(CeylonProjectAlias ceylonProject, FileObject folder, WeakReference<Package> p) {}
    
    // TODO
    shared actual void setRootIsSourceProperty(CeylonProjectAlias ceylonProject, FileObject rootFolder, Boolean isSource) {}
    
    // TODO
    shared actual void setRootPropertyForNativeFolder(CeylonProjectAlias ceylonProject, FileObject folder, WeakReference<FolderVirtualFileAlias> root) {}
    
    toPackageName(FileObject resource, FileObject sourceDir)
            => FileUtil.getRelativePath(sourceDir, resource)
                .split('/'.equals).sequence();
}

class NbFileVirtualFile(Project project, FileObject fo)
        satisfies FileVirtualFile<Project,FileObject,FileObject,FileObject> {
    
    ceylonProject
            => let (model = Lookup.default.lookup(javaClass<NbCeylonProjects>()))
                model.getProject(project);
    
    charset => null;
    
    inputStream => fo.inputStream;
    
    nativeProject => project;
    
    nativeResource => fo;
    
    shared actual Integer hash => fo.hash;
    
    shared actual Boolean equals(Object that) {
        if (is NbFileVirtualFile that) {
            return fo==that.fo;
        }
        else {
            return false;
        }
    }
}

class NbFolderVirtualFile(Project project, FileObject fo)
        satisfies FolderVirtualFile<Project,FileObject,FileObject,FileObject> {
    
    ceylonProject
            => let (model = Lookup.default.lookup(javaClass<NbCeylonProjects>()))
                model.getProject(project);
    
    shared actual List<out ResourceVirtualFile<Project,FileObject,FileObject,FileObject>> children {
        value list = ArrayList<ResourceVirtualFile<Project,FileObject,FileObject,FileObject>>();
        
        for (child in fo.children) {
            if (child.folder) {
                list.add(NbFolderVirtualFile(project, child));
            } else {
                list.add(NbFileVirtualFile(project, child));
            }
        }
        
        return list;
    }
    
    nativeProject => project;
    
    nativeResource => fo;
    
    shared actual Integer hash {
        variable value hash = 1;
        hash = 31*hash + project.hash;
        hash = 31*hash + fo.hash;
        return hash;
    }
    
    shared actual Boolean equals(Object that) {
        if (is NbFolderVirtualFile that) {
            return project==that.project && 
                fo==that.fo;
        }
        else {
            return false;
        }
    }
}