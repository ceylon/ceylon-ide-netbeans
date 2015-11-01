package com.redhat.ceylon.ide.netbeans.features;

import com.redhat.ceylon.ide.netbeans.lang.AnnotatedCeylonLanguage;
import java.util.Arrays;
import java.util.Collection;
import org.netbeans.api.editor.fold.FoldType;
import org.netbeans.api.editor.mimelookup.MimeRegistration;
import org.netbeans.spi.editor.fold.FoldTypeProvider;

@MimeRegistration(
        mimeType = AnnotatedCeylonLanguage.MIME_TYPE,
        service = FoldTypeProvider.class
)
public class CeylonFoldTypeProvider implements FoldTypeProvider {

    @Override
    @SuppressWarnings("rawtypes")
    public Collection getValues(Class type) {
        return Arrays.asList(FoldType.IMPORT, FoldType.CODE_BLOCK);
    }

    @Override
    public boolean inheritable() {
        return false;
    }

}
