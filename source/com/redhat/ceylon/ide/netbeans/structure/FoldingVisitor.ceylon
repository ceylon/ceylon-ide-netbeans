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

                folds.put(code(FoldType.\iimport), singletonList(range));
            }
        }
        super.visitImportList(importList);
    }
    
    shared actual void visitBlock(Tree.Block block) {
        value type = block.scope.toplevel
        then FoldType.codeBlock
        else FoldType.nested;
        
        value range = OffsetRange(block.startIndex.intValue(), block.endIndex.intValue());
        findOrCreateKey(type).add(range);

        super.visitBlock(block);
    }
    
    shared actual void visitBody(Tree.Body body) {
        value type = body.scope.toplevel
        then FoldType.codeBlock
        else FoldType.nested;

        value range = OffsetRange(body.startIndex.intValue(), body.endIndex.intValue());
        findOrCreateKey(type).add(range);
        
        super.visitBody(body);
    }
    
    shared actual void visitAnonymousAnnotation(Tree.AnonymousAnnotation ann) {
        value newLine = ann.token.text.firstInclusion("\n");
        if (exists newLine) {
            value range = OffsetRange(ann.startIndex.intValue() + newLine,
                ann.endIndex.intValue());
            findOrCreateKey(FoldType.documentation).add(range);
        }

        super.visitAnonymousAnnotation(ann);
    }
    
    shared actual void visitImportModuleList(Tree.ImportModuleList list) {
        value range = OffsetRange(list.startIndex.intValue(), list.endIndex.intValue());
        findOrCreateKey(FoldType.codeBlock).add(range);

        super.visitImportModuleList(list);
    }
    
    List<OffsetRange> findOrCreateKey(FoldType type) {
        List<OffsetRange> ranges;

        if (folds.containsKey(code(type))) {
            ranges = folds.get(code(type));
        } else {
            ranges = ArrayList<OffsetRange>();
            folds.put(code(type), ranges);
        }

        return ranges;
    }

    JString code(FoldType type) => javaString(type.code());
}