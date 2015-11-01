package com.redhat.ceylon.ide.netbeans.editor;

import com.redhat.ceylon.ide.netbeans.lang.AnnotatedCeylonLanguage;
import org.netbeans.api.editor.EditorActionNames;
import org.netbeans.api.editor.EditorActionRegistration;

@EditorActionRegistration(name = EditorActionNames.organizeImports,
        mimeType = AnnotatedCeylonLanguage.MIME_TYPE,
        menuPath = "Source",
        menuPosition = 2430,
        menuText = "#" + EditorActionNames.organizeImports + "_menu_text"
)
public class AnnotatedOrganizeImportsActions extends OrganizeImportsActions {

}
