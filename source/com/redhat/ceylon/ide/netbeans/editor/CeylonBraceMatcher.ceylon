import org.netbeans.api.editor.mimelookup {
	mimeRegistration
}
import org.netbeans.spi.editor.bracesmatching {
	BracesMatcherFactory,
	MatcherContext
}
import org.netbeans.spi.editor.bracesmatching.support {
	BracesMatcherSupport
}

mimeRegistration {
	mimeType = "text/x-ceylon";
	service = `interface BracesMatcherFactory`;
}
shared class CeylonBraceMatcher() satisfies BracesMatcherFactory {
	
	createMatcher(MatcherContext context) 
			=> BracesMatcherSupport.defaultMatcher(context, -1, -1);
	
}
