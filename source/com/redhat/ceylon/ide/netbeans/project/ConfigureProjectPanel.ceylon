import java.awt {
    Component
}

import javax.swing {
    JPanel
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

class ConfigureProjectPanel()
        satisfies Panel<WizardDescriptor>
                & ValidatingPanel<WizardDescriptor>
                & FinishablePanel<WizardDescriptor> {
    
    JPanel rootPanel = ConfigureProjectVisual();
    
    shared actual void addChangeListener(ChangeListener? changeListener) {}
    
    shared actual Component component => rootPanel;
    
    shared actual Boolean finishPanel => true;
    
    shared actual HelpCtx? help => null;
    
    shared actual void readSettings(WizardDescriptor? data) {}
    
    shared actual void removeChangeListener(ChangeListener? changeListener) {}
    
    shared actual void storeSettings(WizardDescriptor? data) {}
    
    shared actual Boolean valid => true;
    
    shared actual void validate() {}
}