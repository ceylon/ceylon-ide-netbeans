import com.redhat.ceylon.compiler.typechecker.tree {
    Tree
}

import java.util {
    Set,
    List,
    HashSet,
    ArrayList
}

import javax.swing {
    ImageIcon
}

import org.netbeans.modules.csl.api {
    StructureItem,
    HtmlFormatter,
    ElementKind,
    ElementHandle,
    Modifier
}

class CeylonStructureItem(Tree.Declaration decl) satisfies StructureItem {
    
    shared actual ImageIcon? customIcon => null;
    
    shared actual ElementHandle elementHandle => nothing;
    
    endPosition => decl.endIndex.intValue();
    
    shared actual String getHtml(HtmlFormatter htmlFormatter)
            => decl.identifier?.text else "<unnamed>";
    
    shared actual ElementKind kind {
        return switch (decl)
        case (is Tree.AnyClass) ElementKind.\iclass
        case (is Tree.AnyInterface) ElementKind.\iinterface
        case (is Tree.AnyMethod) ElementKind.method
        case (is Tree.ObjectDefinition) ElementKind.\iclass
        else ElementKind.other;
    }
    
    leaf => false;
    
    shared actual Set<Modifier> modifiers {
        value mods = HashSet<Modifier>();
        
        if (exists m = decl.declarationModel) {
            if (m.shared) {
                mods.add(Modifier.public);
            }
            if (m.abstraction) {
                mods.add(Modifier.abstract);
            }
        }
        
        return mods;
    }
    
    name => decl.identifier?.text else "<unnamed>";
    
    shared actual List<out StructureItem> nestedItems {
        value children = ArrayList<StructureItem>();
        StructureVisitor(children).visitAny(decl);
        return children;
    }
    
    position => decl.startIndex.intValue();
    
    sortText => name;
    
    hash => 42;
    
    equals(Object that) => false;
}
