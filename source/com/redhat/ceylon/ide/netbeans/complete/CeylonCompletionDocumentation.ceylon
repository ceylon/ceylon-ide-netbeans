import ceylon.interop.java {
	CeylonIterable
}

import com.redhat.ceylon.ide.netbeans.doc {
	NbDocGenerator
}
import com.redhat.ceylon.ide.netbeans.model {
	CeylonParseController
}
import org.eclipse.ceylon.model.typechecker.model {
	Scope,
	Referenceable,
	TypedDeclaration,
	Value
}

import java.io {
	File
}
import java.net {
	URL
}

import org.netbeans.spi.editor.completion {
	CompletionDocumentation
}
import org.openide.cookies {
	OpenCookie
}
import org.openide.filesystems {
	FileUtil,
	URLMapper
}
import org.openide.loaders {
	DataObject
}

class CeylonCompletionDocumentation(text, cpc)
        satisfies CompletionDocumentation {
    
    CeylonParseController cpc;
    shared actual String text;
    
    gotoSourceAction => null;
    
    shared actual CompletionDocumentation? resolveLink(String link) {
        value bits = link.split(':'.equals).sequence();

        // TODO this was copied from Eclipse and IntelliJ
        if (exists moduleNameAndVersion = bits[1],
            exists loc = moduleNameAndVersion.firstOccurrence('/')) {
            
            String moduleName = moduleNameAndVersion.spanTo(loc - 1);
            String moduleVersion = moduleNameAndVersion.spanFrom(loc + 1);
            assert(exists tc = cpc.lastAnalysis?.typeChecker);
            value mod = CeylonIterable(tc.context.modules.listOfModules).find(
                (m) => m.nameAsString==moduleName && m.version==moduleVersion
            );
            
            if (bits.size == 2, exists mod) {
                return CeylonCompletionDocumentation(getDoc(mod), cpc);
            }
            if (exists mod) {
                variable Referenceable? target = mod.getPackage(bits[2]);
                
                if (bits.size > 3) {
                    for (i in 3 .. bits.size-1) {
                        variable Scope scope;
                        if (is Scope t = target) {
                            scope = t;
                        } else if (is TypedDeclaration t = target) {
                            scope = t.type.declaration;
                        } else {
                            return null;
                        }
                        
                        if (is Value s = scope, s.typeDeclaration.anonymous) {
                            scope = s.typeDeclaration;
                        }
                        
                        target = scope.getDirectMember(bits[i], null, false);
                    }
                }
                
                if (exists t = target) {
                    value b = bits[0];
                    if (b == "doc") {
                        return CeylonCompletionDocumentation(getDoc(t), cpc);
                    } else if (b == "dec") {
                        value path = t.unit.fullPath;
                        value fo = path.contains("!/")
                                    then URLMapper.findFileObject(URL("jar:file://" + path))
                                    else FileUtil.toFileObject(File(path));

                        DataObject.find(fo).lookup.lookup(`OpenCookie`).open();
                    }
                }
            }
        }
        
        return null;
    }
    
    String getDoc(Referenceable ref) {
        if (exists lastAnalysis = cpc.lastAnalysis,
            exists tc = lastAnalysis.typeChecker) {
            value pu = tc.getPhasedUnitFromRelativePath(ref.unit.relativePath);
            value cu = pu.compilationUnit;
            
            return NbDocGenerator(cpc).getDocumentationText(ref, null, cu, lastAnalysis)
                else "Couldn't retrieve doc :-(";
        }
        return "";
    }
    
    url => null;
}
