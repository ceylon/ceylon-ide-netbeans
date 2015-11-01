package com.redhat.ceylon.ide.netbeans.complete;

import com.redhat.ceylon.ide.netbeans.lang.AnnotatedCeylonLanguage;
import org.netbeans.api.editor.mimelookup.MimeRegistration;
import org.netbeans.spi.editor.completion.CompletionProvider;

@MimeRegistration(
        mimeType = AnnotatedCeylonLanguage.MIME_TYPE,
        service = CompletionProvider.class
)
public class AnnotatedCompletionProvider extends CeylonCompletionProvider {

}
