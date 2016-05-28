package com.redhat.ceylon.ide.netbeans;

import com.redhat.ceylon.ide.netbeans.model.NbCeylonProjectHook;
import org.netbeans.api.project.Project;
import org.netbeans.spi.project.LookupProvider;
import org.openide.util.Lookup;
import org.openide.util.lookup.Lookups;

@LookupProvider.Registration(
    projectType = "org-netbeans-modules-java-j2seproject"
)
public class CeylonLookupProvider implements LookupProvider {

    @Override
    public Lookup createAdditionalLookup(Lookup lkp) {
        return Lookups.fixed(
                new NbCeylonProjectHook(lkp.lookup(Project.class))
        );
    }
}
