import ceylon.collection {
    ArrayList
}

import com.redhat.ceylon.ide.common.util {
    ProgressMonitorImpl
}

import org.netbeans.api.progress {
    ProgressHandle
}

// TODO the progress is not updated correctly because of children monitors
shared class ProgressHandleMonitor extends ProgressMonitorImpl<ProgressHandle> {
    ProgressHandle handle;

    value parents = ArrayList<[Boolean,Integer,Integer]>();
    
    variable value started = false;
    variable value allocatedWork = 0;
    variable Integer cumulativeWorked = 0;
    
    shared new child(ProgressMonitorImpl<ProgressHandle> parent,
        Integer allocatedWork, Boolean started)
            extends super.child(parent, allocatedWork) {
        handle = parent.wrapped;
        this.started = started;
        this.allocatedWork = allocatedWork;
        
        if (!started) {
            this.started = true;
            handle.start(allocatedWork);            
        } else {
            handle.switchToDeterminate(allocatedWork);
        }
    }
    
    shared new wrap(ProgressHandle handle) 
            extends super.wrap(handle) {
        this.handle = handle;
        this.started = false;
    }

    shared actual void subTask(String desc) {
        handle.setDisplayName(desc);
    }
    
    shared actual Boolean cancelled => false;
    
    shared actual ProgressHandleMonitor newChild(Integer allocatedWork) {
        parents.push([this.started, this.allocatedWork, this.cumulativeWorked]);
        return child(this, allocatedWork, started);
    }
    
    shared actual void updateRemainingWork(Integer remainingWork) {
        handle.switchToDeterminate(remainingWork);
    }
    
    shared actual void worked(Integer amount) {
        cumulativeWorked += amount;
        //handle.progress(cumulativeWorked);
    }
    
    shared actual void done() {
        if (exists pop = parents.pop()) {
            started = pop[0];
            allocatedWork = pop[1];
            cumulativeWorked = pop[2];
            
            handle.switchToDeterminate(allocatedWork);
            handle.progress(cumulativeWorked);
        }
    }
    
    wrapped => handle;
}