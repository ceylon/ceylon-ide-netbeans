import java.awt {
    Component
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
import org.openide.util {
    HelpCtx
}
import java.io {
    File
}

class ConfigureProjectPanel()
        satisfies Panel<WizardDescriptor>
                & ValidatingPanel<WizardDescriptor>
                & FinishablePanel<WizardDescriptor> {
    
    value rootPanel = ConfigureProjectVisual();
    
    shared actual void addChangeListener(ChangeListener? changeListener) {}
    
    shared actual Component component => rootPanel;
    
    shared actual Boolean finishPanel => true;
    
    shared actual HelpCtx? help => null;
    
    shared actual void readSettings(WizardDescriptor? data) {}
    
    shared actual void removeChangeListener(ChangeListener? changeListener) {}
    
    shared actual void storeSettings(WizardDescriptor data) {
        value projdir = File(rootPanel.projectLocation.text
            + File.separator + rootPanel.projectName.text);
        
        data.putProperty("projdir", projdir);
    }
    
    shared actual Boolean valid => true;
    
    shared actual void validate() {}
}