package com.redhat.ceylon.ide.netbeans.project;

// This is needed to instantiate the wizard from layer.xml
public class CeylonProjectWizardFactory {
    public static AmbiguousOverloadsResolver wizard() {
        return new CeylonProjectWizard();
    }
}
