package com.redhat.ceylon.ide.netbeans.project;

import java.util.Set;

import org.netbeans.api.progress.ProgressHandle;
import org.openide.WizardDescriptor;
import org.openide.filesystems.FileObject;

public abstract class AmbiguousOverloadsResolver implements WizardDescriptor.ProgressInstantiatingIterator<WizardDescriptor>  {
    
    @Override
    public abstract Set<?> instantiate();
    
    @Override
    public abstract Set<FileObject> instantiate(ProgressHandle handle);
}
