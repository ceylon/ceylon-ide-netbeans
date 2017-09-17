import com.redhat.ceylon.ide.netbeans.model {
	NbCeylonProjectHook
}

import org.netbeans.api.project {
	Project
}
import org.netbeans.spi.project {
	LookupProvider {
		lookupProviderRegistration=registration
	}
}
import org.openide.util {
	Lookup
}
import org.openide.util.lookup {
	Lookups {
		fixed
	}
}
import com.redhat.ceylon.ide.netbeans.project {
	CeylonIdeClasspathProvider
}

lookupProviderRegistration {
	projectType = {
		"org-netbeans-modules-java-j2seproject",
		"org-netbeans-modules-apisupport-project"
	};
}
shared class CeylonLookupProvider() satisfies LookupProvider {
	
	createAdditionalLookup(Lookup lookup) =>
		fixed(
			NbCeylonProjectHook(lookup.lookup(`Project`)),
			CeylonIdeClasspathProvider().init()
		);
}
