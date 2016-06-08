import org.netbeans.spi.editor.bracesmatching {
    BracesMatcherFactory,
    MatcherContext
}
import org.netbeans.spi.editor.bracesmatching.support {
    BracesMatcherSupport
}

shared class CeylonBraceMatcher() satisfies BracesMatcherFactory {
    
    createMatcher(MatcherContext context) 
            => BracesMatcherSupport.defaultMatcher(context, -1, -1);

}
