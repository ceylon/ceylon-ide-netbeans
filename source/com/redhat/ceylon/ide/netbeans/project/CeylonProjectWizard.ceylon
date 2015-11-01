import java.util {
    Set,
    LinkedHashSet
}

import javax.swing.event {
    ChangeListener
}

import org.netbeans.api.progress {
    ProgressHandle
}
import org.openide {
    WizardDescriptor {
        Panel
    }
}
import org.openide.filesystems {
    FileObject,
    FileUtil
}
import java.io {
    File
}

shared class CeylonProjectWizard() extends AmbiguousOverloadsResolver() {
    
    value panels = [ConfigureProjectPanel()];
    variable WizardDescriptor? wiz = null;
    
    shared actual void addChangeListener(ChangeListener changeListener) {}
    
    shared actual Panel<WizardDescriptor> current() => panels.first;
    
    shared actual Boolean hasNext() => false;
    
    shared actual Boolean hasPrevious() => false;
    
    shared actual void initialize(WizardDescriptor wizardDescriptor) {
        wiz = wizardDescriptor;
        wizardDescriptor.title = "New Ceylon project";
    }
    
    // Should not be callsed because we implement
    //  WizardDescriptor.ProgressInstantiatingIterator
    suppressWarnings("expressionTypeNothing")
    shared actual Set<out Object> instantiate() => nothing;

    shared actual Set<FileObject> instantiate(ProgressHandle handle) {
        assert(exists wizard = wiz);
        assert(is File projectDir = wizard.getProperty("projdir"));

        Set<FileObject> files = LinkedHashSet<FileObject>();
        
        handle.start(1);
        
        value ceylonDir = File(projectDir, ".ceylon");
        ceylonDir.mkdirs();
        value ceylonConfig = File(ceylonDir, "config");
        ceylonConfig.createNewFile();
        
        files.add(FileUtil.toFileObject(ceylonDir));
        files.add(FileUtil.toFileObject(ceylonConfig));
        
        handle.progress(1);
        
        return files;
    }
    
    shared actual String name() => "???";
    
    shared actual void nextPanel() {}
    
    shared actual void previousPanel() {}
    
    shared actual void removeChangeListener(ChangeListener changeListener) {}
    
    shared actual void uninitialize(WizardDescriptor wizardDescriptor) {}
    
}
