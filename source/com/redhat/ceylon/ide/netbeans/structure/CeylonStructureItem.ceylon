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
    
    shared actual ElementHandle? elementHandle => null;
    
    shared actual Integer endPosition => decl.endIndex.intValue();
    
    shared actual String getHtml(HtmlFormatter? htmlFormatter)
            => decl.identifier?.text else "<unnamed>";
    
    shared actual ElementKind kind {
        return switch (decl)
        case (is Tree.AnyClass) ElementKind.\iCLASS
        case (is Tree.AnyInterface) ElementKind.\iINTERFACE
        case (is Tree.AnyMethod) ElementKind.\iMETHOD
        case (is Tree.ObjectDefinition) ElementKind.\iCLASS
        else ElementKind.\iOTHER;
    }
    
    shared actual Boolean leaf => false;
    
    shared actual Set<Modifier> modifiers {
        value mods = HashSet<Modifier>();
        
        if (exists m = decl.declarationModel) {
            if (m.shared) {
                mods.add(Modifier.\iPUBLIC);
            }
            if (m.abstraction) {
                mods.add(Modifier.\iABSTRACT);
            }
        }
        
        return mods;
    }
    
    shared actual String name => decl.identifier?.text else "<unnamed>";
    
    shared actual List<out StructureItem> nestedItems {
        value children = ArrayList<StructureItem>();
        StructureVisitor(children).visitAny(decl);
        return children;
    }
    
    shared actual Integer position => decl.startIndex.intValue();
    
    shared actual String sortText => name;
    
    shared actual Integer hash => 42;
    
    shared actual Boolean equals(Object that) => false;
}
