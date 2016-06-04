import ceylon.interop.java {
    CeylonIterable,
    javaClass
}

import com.redhat.ceylon.ide.netbeans.doc {
    NbDocGenerator
}
import com.redhat.ceylon.ide.netbeans.model {
    CeylonParseController
}
import com.redhat.ceylon.model.typechecker.model {
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

import javax.swing {
    Action
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

class CeylonCompletionDocumentation(shared actual String text, CeylonParseController cpc)
        satisfies CompletionDocumentation {
    
    //print(text);
    
    shared actual Action? gotoSourceAction => null;
    
    shared actual CompletionDocumentation? resolveLink(String link) {
        value bits = link.split(':'.equals).sequence();

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
                
                if (exists t = target, exists b = bits[0]) {
                    if (b == "doc") {
                        return CeylonCompletionDocumentation(getDoc(t), cpc);
                    } else if (b == "dec") {
                        value path = t.unit.fullPath;
                        value fo = path.contains("!/")
                                    then URLMapper.findFileObject(URL("jar:file://" + path))
                                    else FileUtil.toFileObject(File(path));

                        DataObject.find(fo).lookup.lookup(javaClass<OpenCookie>()).open();
                    }
                }
            }
        }
        
        return null;
    }
    
    String getDoc(Referenceable ref) {
        if (exists lastAnalysis = cpc.lastAnalysis) {
            value pu = lastAnalysis.typeChecker.getPhasedUnitFromRelativePath(ref.unit.relativePath);
            value cu = pu.compilationUnit;
            
            return NbDocGenerator(cpc).getDocumentationText(ref, null, cu, lastAnalysis)
                else "Couldn't retrieve doc :-(";
        }
        return "";
    }
    shared actual URL? url => null;
}
