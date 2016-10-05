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
    NbCeylonProjects,
    NbCeylonProject
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
    
    getPackagePropertyForNativeFolder(CeylonProjectAlias ceylonProject, FileObject folder)
            => if (is NbCeylonProject ceylonProject)
                then ceylonProject.filePropertyHolder.packages.get(folder)
                else null;
    
    getParent(FileObject resource) => resource.parent;
    
    shared actual Path? getProjectRelativePath(FileObject resource, CeylonProjectAlias|Project project) {
        return if (exists path = getProjectRelativePathString(resource, project))
        then Path(path)
        else null;
    }
    
    shared actual String? getProjectRelativePathString(FileObject resource, CeylonProjectAlias|Project project) {
        value p = if (is Project project) then project else project.ideArtifact;
        
        return FileUtil.getRelativePath(p.projectDirectory, resource);
    }
    
    getRootIsSourceProperty(CeylonProjectAlias ceylonProject, FileObject rootFolder)
            => if (is NbCeylonProject ceylonProject)
                then ceylonProject.filePropertyHolder.rootIsSources.get(rootFolder)
                else null;
    
    getRootPropertyForNativeFolder(CeylonProjectAlias ceylonProject, FileObject folder)
            => if (is NbCeylonProject ceylonProject)
                then ceylonProject.filePropertyHolder.roots.get(folder)
                else null;

    getShortName(FileObject resource) => resource.nameExt;
    
    getVirtualFilePath(FileObject resource) => Path(resource.path);
    
    getVirtualFilePathString(FileObject resource) => resource.path;
    
    isFolder(FileObject resource) => resource.folder;
    
    shared actual void removePackagePropertyForNativeFolder
    (CeylonProjectAlias ceylonProject, FileObject folder) {
        if (is NbCeylonProject ceylonProject) {
            ceylonProject.filePropertyHolder.packages.remove(folder);
        }
    }
    
    shared actual void removeRootIsSourceProperty
    (CeylonProjectAlias ceylonProject, FileObject folder) {
        if (is NbCeylonProject ceylonProject) {
            ceylonProject.filePropertyHolder.rootIsSources.remove(folder);
        }
    }
    
    shared actual void removeRootPropertyForNativeFolder
    (CeylonProjectAlias ceylonProject, FileObject folder) {
        if (is NbCeylonProject ceylonProject) {
            ceylonProject.filePropertyHolder.roots.remove(folder);
        }
    }
    
    shared actual void setPackagePropertyForNativeFolder
    (CeylonProjectAlias ceylonProject, FileObject folder, WeakReference<Package> p) {
        if (is NbCeylonProject ceylonProject) {
            ceylonProject.filePropertyHolder.packages.put(folder, p);
        }
    }
    
    shared actual void setRootIsSourceProperty
    (CeylonProjectAlias ceylonProject, FileObject folder, Boolean isSource) {
        if (is NbCeylonProject ceylonProject) {
            ceylonProject.filePropertyHolder.rootIsSources.put(folder, isSource);
        }
    }
    
    shared actual void setRootPropertyForNativeFolder
    (CeylonProjectAlias ceylonProject, FileObject folder, WeakReference<FolderVirtualFileAlias> root) {
        if (is NbCeylonProject ceylonProject) {
            ceylonProject.filePropertyHolder.roots.put(folder, root);
        }
    }
    
    toPackageName(FileObject resource, FileObject sourceDir)
            => FileUtil.getRelativePath(sourceDir, resource)
                .split('/'.equals).sequence();
    
    flushIfNecessary(FileObject resource) => false;
    
}

shared class NbFileVirtualFile(Project project, FileObject fo)
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

shared class NbFolderVirtualFile(Project project, FileObject fo)
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