import ceylon.interop.java {
    javaString
}

import com.redhat.ceylon.compiler.typechecker.tree {
    VisitorAdaptor,
    Tree
}

import java.lang {
    JString=String
}
import java.util {
    Map,
    List,
    Collections {
        singletonList
    },
    ArrayList
}

import org.netbeans.api.editor.fold {
    FoldType
}
import org.netbeans.modules.csl.api {
    OffsetRange
}

class FoldingVisitor(Map<JString,List<OffsetRange>> folds) extends VisitorAdaptor() {
    
    shared actual void visitImportList(Tree.ImportList importList) {
        if (!importList.imports.empty) {
            if (exists path = importList.imports.get(0).importPath) {
                value range = OffsetRange(path.startIndex.intValue(),
                    importList.endIndex.intValue() + 1);

                folds.put(code(FoldType.\iIMPORT), singletonList(range));
            }
        }
    }
    
    shared actual void visitBlock(Tree.Block block) {
        List<OffsetRange> ranges;
        if (folds.containsKey(code(FoldType.\iCODE_BLOCK))) {
            ranges = folds.get(code(FoldType.\iCODE_BLOCK));
        } else {
            ranges = ArrayList<OffsetRange>();
            folds.put(code(FoldType.\iCODE_BLOCK), ranges);
        }
        
        ranges.add(OffsetRange(block.startIndex.intValue(), block.endIndex.intValue()));
    }
    
    shared actual void visitBody(Tree.Body body) {
        List<OffsetRange> ranges;
        if (folds.containsKey(code(FoldType.\iCODE_BLOCK))) {
            ranges = folds.get(code(FoldType.\iCODE_BLOCK));
        } else {
            ranges = ArrayList<OffsetRange>();
            folds.put(code(FoldType.\iCODE_BLOCK), ranges);
        }
        
        ranges.add(OffsetRange(body.startIndex.intValue(), body.endIndex.intValue()));
    }
    
    shared actual void visitAnyClass(Tree.AnyClass? anyClass) => super.visitAnyClass(anyClass);
    
    JString code(FoldType type) => javaString(type.code());
}