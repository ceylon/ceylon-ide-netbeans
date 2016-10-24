import java.io {
	File
}

import javax.swing.event {
	ChangeListener
}

import org.openide {
	WizardDescriptor {
		Panel,
		ValidatingPanel,
		FinishablePanel
	}
}

class ConfigureProjectPanel()
        satisfies Panel<WizardDescriptor>
                & ValidatingPanel<WizardDescriptor>
                & FinishablePanel<WizardDescriptor> {
    
    value rootPanel = ConfigureProjectVisual();
    
    addChangeListener(ChangeListener? changeListener)
            => noop();
    
    component => rootPanel;
    
    finishPanel => true;
    
    help => null;
    
    readSettings(WizardDescriptor? data)
            => noop();
    
    removeChangeListener(ChangeListener? changeListener)
            => noop();
    
    shared actual void storeSettings(WizardDescriptor data) {
        value projdir = File(rootPanel.projectLocation.text
            + File.separator + rootPanel.projectName.text);
        
        data.putProperty("projdir", projdir);
    }
    
    valid => true;
    
    validate() => noop();
}