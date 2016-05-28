import com.redhat.ceylon.ide.common.util {
    ProgressMonitorImpl
}

import org.netbeans.api.progress {
    ProgressHandle
}

shared class ProgressHandleMonitor extends ProgressMonitorImpl<ProgressHandle> {
    ProgressHandle handle;
    
    shared new child(ProgressMonitorImpl<ProgressHandle> parent, Integer allocatedWork)
            extends super.child(parent, allocatedWork) {
        handle = parent.wrapped;
        handle.start(allocatedWork);
    }
    
    shared new wrap(ProgressHandle handle) 
            extends super.wrap(handle) {
        this.handle = handle;
    }

    shared actual void subTask(String desc) {
        handle.setDisplayName(desc);
    }
    
    shared actual Boolean cancelled => false;
    
    newChild(Integer allocatedWork) => child(this, allocatedWork);
    
    shared actual void updateRemainingWork(Integer remainingWork) {
        //handle.progress(remainingWork);
    }
    
    shared actual void worked(Integer amount) {
        //handle.progress(amount);
    }
    
    wrapped => handle;
}