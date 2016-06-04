import ceylon.interop.java {
    javaClass,
    JavaRunnable
}

import com.redhat.ceylon.ide.common.model {
    ModelListenerAdapter,
    ChangeAware,
    ModelAliases
}
import com.redhat.ceylon.ide.netbeans.platform {
    nbPlatformServices
}
import com.redhat.ceylon.ide.netbeans.util {
    ProgressHandleMonitor
}

import java.util {
    Timer,
    TimerTask
}

import org.netbeans.api.progress {
    ProgressHandle
}
import org.netbeans.api.project {
    Project
}
import org.openide.filesystems {
    FileObject,
    FileChangeListener,
    FileAttributeEvent,
    FileEvent,
    FileRenameEvent,
    FileUtil
}
import org.openide.util {
    Lookup,
    RequestProcessor {
        requestProcessor=default
    }
}

shared class CeylonModelManager()
        satisfies ModelListenerAdapter<Project,FileObject,FileObject,FileObject>
                & ChangeAware<Project,FileObject,FileObject,FileObject>
                & ModelAliases<Project,FileObject,FileObject,FileObject>
                & FileChangeListener {
    
    value model => Lookup.default.lookup(javaClass<NbCeylonProjects>());
    variable value initialized = false;
    
    variable Timer? timer = null;
    
    shared void initializeIfNeeded() {
        if (!initialized) {
            model.addModelListener(this);
            nbPlatformServices.register();
            initialized = true;
            FileUtil.addFileChangeListener(this);
        }
    }
    
    ceylonProjectAdded(CeylonProjectAlias ceylonProject) =>
            startBuild();
    
    shared void startBuild() {
        print("starting build");
        if (model.ceylonProjects.any((prj) => prj.build.somethingToDo)) {
            requestProcessor.post(JavaRunnable(startBuildInternal));
        }
    }

    void startBuildInternal() {
        value handle = ProgressHandle.createHandle("Updating Ceylon model");
        value monitor = ProgressHandleMonitor.wrap(handle);
        value ticks = model.ceylonProjectNumber * 1000;
        
        try (progress = monitor.Progress(ticks, "Updating Ceylon Model")) {
            value projects = model.ceylonProjectsInTopologicalOrder
                    .sequence().reversed;
            
            for (ceylonProject in projects) {
                ceylonProject.build.performBuild(progress.newChild(1000));
            }
        } finally {
            handle.finish();
        }
    }
    
    // File changes
    
    void notifyChanges({NativeResourceChange*} changes) {
        model.fileTreeChanged(changes);
        
        if (exists t = timer) {
            t.cancel();
        }
        value newTimer = Timer();
        newTimer.schedule(object extends TimerTask() {
            run() => startBuild();
        }, 1000);
        timer = newTimer;
    }

    fileAttributeChanged(FileAttributeEvent fileAttributeEvent)
            => noop();
    
    shared actual void fileChanged(FileEvent evt) {
        if (!evt.file.virtual) {
            print("file changed: " + evt.file.string);
            notifyChanges({NativeFileContentChange(evt.file)});
        }
    }
    
    fileDataCreated(FileEvent evt)
            => notifyChanges({NativeFileAddition(evt.file)});
    
    fileDeleted(FileEvent fileEvent)
            => notifyChanges(
                if (fileEvent.file.folder)
                then {NativeFileRemoval(fileEvent.file, null)}
                else {NativeFolderRemoval(fileEvent.file, null)}
            );
    
    fileFolderCreated(FileEvent evt)
            => notifyChanges({NativeFolderAddition(evt.file)});
    
    fileRenamed(FileRenameEvent evt)
            // TODO this is incorrect
            => notifyChanges(
                if (evt.file.folder)
                then {NativeFileRemoval(evt.file, null), NativeFileAddition(evt.file)}
                else {NativeFolderRemoval(evt.file, null), NativeFolderAddition(evt.file)}
            );
    
}
