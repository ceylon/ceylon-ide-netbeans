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
import ceylon.interop.java {
	javaClass
}
import org.netbeans.api.project {
	Project
}
import com.redhat.ceylon.ide.netbeans.model {
	NbCeylonProjectHook
}

lookupProviderRegistration {
	projectType = {"org-netbeans-modules-java-j2seproject"};
}
shared class CeylonLookupProvider() satisfies LookupProvider {
	
	createAdditionalLookup(Lookup lookup)
			=> fixed(NbCeylonProjectHook(lookup.lookup(javaClass<Project>())));
}