package com.redhat.ceylon.ide.netbeans.actions;

import com.redhat.ceylon.ide.netbeans.model.CeylonModelManager;
import com.redhat.ceylon.ide.netbeans.model.NbCeylonProjects;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import org.netbeans.api.project.Project;
import org.openide.awt.ActionID;
import org.openide.awt.ActionReference;
import org.openide.awt.ActionRegistration;
import org.openide.util.Lookup;
import org.openide.util.NbBundle.Messages;

@ActionID(
        category = "Tools",
        id = "com.redhat.ceylon.ide.netbeans.actions.ResetCeylonModelAction"
)
@ActionRegistration(
        iconBase = "icons/ceylon.png",
        displayName = "#CTL_ResetCeylonModelAction"
)
@ActionReference(path = "Menu/Tools", position = 1800)
@Messages("CTL_ResetCeylonModelAction=Reset Ceylon model")
public final class ResetCeylonModelAction implements ActionListener {

    private final Project context;

    public ResetCeylonModelAction(Project context) {
        this.context = context;
    }

    @Override
    public void actionPerformed(ActionEvent ev) {
        NbCeylonProjects projects = Lookup.getDefault().lookup(NbCeylonProjects.class);
        
        projects.getProject(context).getBuild().requestFullBuild();
        projects.getProject(context).getBuild().classPathChanged();

        Lookup.getDefault().lookup(CeylonModelManager.class).startBuild();
    }
}
