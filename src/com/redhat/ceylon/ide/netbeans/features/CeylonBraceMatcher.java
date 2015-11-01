package com.redhat.ceylon.ide.netbeans.features;

import com.redhat.ceylon.ide.netbeans.lang.AnnotatedCeylonLanguage;
import org.netbeans.api.editor.mimelookup.MimeRegistration;
import org.netbeans.spi.editor.bracesmatching.BracesMatcher;
import org.netbeans.spi.editor.bracesmatching.BracesMatcherFactory;
import org.netbeans.spi.editor.bracesmatching.MatcherContext;
import org.netbeans.spi.editor.bracesmatching.support.BracesMatcherSupport;

@MimeRegistration(
        mimeType = AnnotatedCeylonLanguage.MIME_TYPE,
        service = BracesMatcherFactory.class
)
public class CeylonBraceMatcher implements BracesMatcherFactory {

    @Override
    public BracesMatcher createMatcher(MatcherContext context) {
        return BracesMatcherSupport.defaultMatcher(context, -1, -1);
    }

}
