package com.redhat.ceylon.ide.netbeans.features;

import com.redhat.ceylon.ide.netbeans.editor.CeylonSyntaxErrorHighlightingTask;
import com.redhat.ceylon.ide.netbeans.lang.AnnotatedCeylonLanguage;
import java.util.Collection;
import java.util.Collections;
import org.netbeans.api.editor.mimelookup.MimeRegistration;
import org.netbeans.modules.parsing.api.Snapshot;
import org.netbeans.modules.parsing.spi.SchedulerTask;
import org.netbeans.modules.parsing.spi.TaskFactory;

@MimeRegistration(
        mimeType = AnnotatedCeylonLanguage.MIME_TYPE,
        service = TaskFactory.class
)
public class CeylonSyntaxErrorHighlightingTaskFactory extends TaskFactory {

    @Override
    public Collection<? extends SchedulerTask> create(Snapshot snapshot) {
        return Collections.singleton(new CeylonSyntaxErrorHighlightingTask());
    }
}
