import ceylon.interop.java {
    javaClass
}

import com.github.rjeschke.txtmark {
    Configuration,
    Processor
}
import com.redhat.ceylon.compiler.typechecker.context {
    PhasedUnit
}
import com.redhat.ceylon.compiler.typechecker.tree {
    Node
}
import com.redhat.ceylon.ide.common.doc {
    DocGenerator,
    Icons,
    Colors
}
import com.redhat.ceylon.ide.common.typechecker {
    LocalAnalysisResult
}
import com.redhat.ceylon.ide.common.util {
    FindReferencedNodeVisitor
}
import com.redhat.ceylon.ide.netbeans {
    nbIcons
}
import com.redhat.ceylon.ide.netbeans.model {
    CeylonParseController
}
import com.redhat.ceylon.model.typechecker.model {
    Declaration,
    Unit,
    Referenceable,
    Scope,
    Constructor,
    Package,
    Module
}
import com.redhat.ceylon.model.typechecker.util {
    TypePrinter
}

import java.awt {
    Image
}
import java.io {
    InputStreamReader,
    BufferedReader
}

shared class NbDocGenerator(CeylonParseController cpc)
        satisfies DocGenerator {
    
    Image? getUrl(Icons thing) {
        return switch (thing)
            case (Icons.annotations) nbIcons.annotations
            case (Icons.modules) nbIcons.modules
            case (Icons.objects) nbIcons.objects
            case (Icons.classes) nbIcons.classes
            case (Icons.interfaces) nbIcons.interfaces
            case (Icons.enumeration) nbIcons.enumerations
            case (Icons.extendedType) nbIcons.overrides
            case (Icons.satisfiedTypes) nbIcons.implements
            case (Icons.exceptions) nbIcons.exceptions
            //case (Icons.see) AllIcons.Actions.\iShare
            //case (Icons.implementation) AllIcons.General.\iOverridingMethod
            //case (Icons.override) AllIcons.General.\iImplementingMethod
            case (Icons.returns) nbIcons.returns
            case (Icons.units) nbIcons.ceylonFile
            case (Icons.parameters) nbIcons.param
            case (Icons.attributes) nbIcons.attributes
            case (Icons.types) nbIcons.types
            else null;
    }
    
    Image? getIconUrl(Icons|Referenceable thing) {
        return switch (thing)
            case (is Declaration) nbIcons.forDeclaration(thing)
            case (is Module) nbIcons.modules
            case (is Package) nbIcons.packages
            case (is Icons) getUrl(thing)
            else null;
    }
    
    shared actual void addIconAndText(StringBuilder builder, Icons|Referenceable icon, String text) {
        value iconUrl = getIconUrl(icon);
        
        if (exists iconUrl) {
            value path = nbIcons.getPath(iconUrl);
            builder.append("<div><img src='``path``' width='16' height='16'>&nbsp;");
        } else {
            builder.append("<div>");
        }
        
        builder.append(text).append("</div>");
    }
    
    shared actual void appendJavadoc(Declaration model, StringBuilder buffer) {}
    
    shared actual void appendPageEpilog(StringBuilder builder) {
        builder.append("</div>");
    }
    
    shared actual void appendPageProlog(StringBuilder builder) {
        value resource = "/com/redhat/ceylon/ide/netbeans/doc/prolog.html";
        if (exists stream = javaClass<CeylonParseController>().getResourceAsStream(resource)) {
            value reader = BufferedReader(InputStreamReader(stream));
            
            while (true) {
                if (exists line = reader.readLine()) {
                    builder.append(line);
                } else {
                    break;
                }
            }
            // TODO use this instead (needs a proper module loader)
            //if (exists r = `module`.resourceByPath("doc/prolog.html")) {
            //    print("found it");
            //    builder.append(r.textContent());
        } else {
            builder.append("<div>");
        }
    }
    
    shared String buildUrl(Referenceable model) {
        if (is Package model) {
            return buildUrl(model.\imodule) + ":" + model.nameAsString;
        }
        if (is Module model) {
            return model.nameAsString + "/" + model.version;
        }
        else if (is Declaration model) {
            String result = ":" + (model.name else "new");
            Scope? container = model.container;
            if (is Referenceable container) {
                return buildUrl(container) + result;
            }
            else {
                return result;
            }
        }
        else {
            return "";
        }
    }

    shared actual String buildLink(Referenceable|String model, String text,
        String protocol) {
        
        String href = if (is String model) then model else buildUrl(model);
         
        return "<a href=\"``protocol``:``href``\">``text``</a>";
    }
    
    shared actual String color(Object? what, Colors how)
            => "<span style='color: blue'>`` what?.string else "" ``</span>"; // TODO proper highlight
    
    shared actual String? getLiveValue(Declaration dec, Unit unit)
            => null;
    
    shared actual PhasedUnit? getPhasedUnit(Unit u)
            => cpc.typeChecker.getPhasedUnitFromRelativePath(u.relativePath);
    
    shared actual Node? getReferencedNode(Declaration dec) {
        value relPath = dec.unit.relativePath;

        if (exists unit = cpc.typeChecker.getPhasedUnitFromRelativePath(relPath)) {
            value visitor = FindReferencedNodeVisitor(dec);
            unit.compilationUnit.visit(visitor);
            return visitor.declarationNode;
        }
        
        return null;
    }
    
    shared actual String getUnitName(Unit u) => u.filename;
    
    shared actual String highlight(String text, LocalAnalysisResult cmp)
            => "<code>``text``</code>"; // TODO
    
    shared actual String markdown(String text, LocalAnalysisResult cmp, Scope? linkScope, Unit? unit) {
        value builder = Configuration.builder().forceExtentedProfile();
        builder.setCodeBlockEmitter(CeylonBlockEmitter());

        return Processor.process(text, builder.build());
    }
    
    shared actual object printer extends TypePrinter(true, true, false, true, false) {
        
        shared actual String getSimpleDeclarationName(Declaration? declaration, Unit unit) {
            if (exists declaration) {
                variable String? name = super.getSimpleDeclarationName(declaration, unit);
                if (!exists n = name, is Constructor declaration) {
                    name = "new";
                }
                
                if (exists n = name) {
                    value col = if (n.first?.lowercase else false) then Colors.identifiers else Colors.types;
                    return buildLink(declaration, color(name, col));
                }
            }
            
            return "&lt;unknown&gt;";
        }
        
        shared actual String amp() => "&amp;";
        shared actual String lt() => "&lt;";
        shared actual String gt() => "&gt";
    }
    
    shared actual Boolean showMembers => false;
    
    shared actual Boolean supportsQuickAssists => false;

    shared actual TypePrinter verbosePrinter => nothing;
    
}
