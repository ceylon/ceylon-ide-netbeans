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

import org.netbeans.api.progress {
    ProgressHandleFactory
}
import org.netbeans.api.project {
    Project
}
import org.openide.filesystems {
    FileObject
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
                & ModelAliases<Project,FileObject,FileObject,FileObject> {
    
    value model => Lookup.default.lookup(javaClass<NbCeylonProjects>());
    variable value initialized = false;
    
    shared void initializeIfNeeded() {
        if (!initialized) {
            model.addModelListener(this);
            nbPlatformServices.register();
            initialized = true;
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
        value handle = ProgressHandleFactory.createHandle("Updating Ceylon model");
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
}