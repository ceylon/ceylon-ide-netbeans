import java.io {
	File
}
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
import org.netbeans.api.templates {
	templateRegistration
}
import org.openide {
	WizardDescriptor
}
import org.openide.filesystems {
	FileObject,
	FileUtil
}

templateRegistration {
	folder = "Project/Ceylon";
	displayName = "Ceylon Application";
	iconBase = "icons/ceylon.png";
	position = 305;
	description = "CeylonApp.html";
}
shared class CeylonProjectWizard extends AmbiguousOverloadsResolver {
    
    shared static CeylonProjectWizard createIterator() {
        return CeylonProjectWizard();
    }

    shared new () extends AmbiguousOverloadsResolver() {
    }

    value panels = [ConfigureProjectPanel()];
    variable WizardDescriptor? wiz = null;
    
    addChangeListener(ChangeListener changeListener)
            => noop();
    
    current() => panels.first;
    
    hasNext() => false;
    
    hasPrevious() => false;
    
    shared actual void initialize(WizardDescriptor wizardDescriptor) {
        wiz = wizardDescriptor;
        wizardDescriptor.title = "New Ceylon project";
    }
    
    // Should not be called because we implement
    //  WizardDescriptor.ProgressInstantiatingIterator
    suppressWarnings("expressionTypeNothing")
    shared actual Set<out Object> instantiate() => nothing;

    // TODO this does not create and open a new project, atm it only creates files
    shared actual Set<FileObject> instantiate(ProgressHandle handle) {
        assert(exists wizard = wiz);
        assert(is File projectDir = wizard.getProperty("projdir"));

        Set<FileObject> files = LinkedHashSet<FileObject>();
        
        handle.start(2);
        
        value ceylonDir = File(projectDir, ".ceylon");
        ceylonDir.mkdirs();
        value ceylonConfig = File(ceylonDir, "config");
        ceylonConfig.createNewFile();
        
        files.add(FileUtil.toFileObject(ceylonDir));
        files.add(FileUtil.toFileObject(ceylonConfig));

        handle.progress(1);

        value sourceDir = File(projectDir, "source");
        sourceDir.mkdirs();

        files.add(FileUtil.toFileObject(sourceDir));
        
        handle.progress(2);
        
        handle.finish();
        
        return files;
    }
    
    name() => "???";
    
    nextPanel() => noop();
    
    previousPanel() => noop();
    
    removeChangeListener(ChangeListener changeListener)
            => noop();
    
    uninitialize(WizardDescriptor wizardDescriptor)
            => noop();
}
