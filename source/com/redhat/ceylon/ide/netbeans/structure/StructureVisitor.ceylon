import com.redhat.ceylon.compiler.typechecker.tree {
    VisitorAdaptor,
    Tree
}

import java.util {
    List
}

import org.netbeans.modules.csl.api {
    StructureItem
}

class StructureVisitor(List<in StructureItem> items) extends VisitorAdaptor() {

    shared actual void visitObjectDefinition(Tree.ObjectDefinition def) {
        items.add(CeylonStructureItem(def));
    }
    
    shared actual void visitClassOrInterface(Tree.ClassOrInterface def) {
        items.add(CeylonStructureItem(def));
    }
    
    shared actual void visitAnyMethod(Tree.AnyMethod meth) {
        items.add(CeylonStructureItem(meth));
    }
}