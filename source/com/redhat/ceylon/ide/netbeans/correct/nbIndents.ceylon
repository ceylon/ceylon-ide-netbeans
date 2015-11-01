import com.redhat.ceylon.compiler.typechecker.tree {
    Node
}
import com.redhat.ceylon.ide.common.util {
    Indents
}

import javax.swing.text {
    Document,
    StyledDocument,
    Element
}

import org.openide.text {
    NbDocument
}

shared object nbIndents satisfies Indents<Document> {
    shared actual String getDefaultLineDelimiter(Document? document) => "\n";
    
    shared actual String getLine(Node node, Document doc) {
        if (is StyledDocument doc) {
            Element paragraphsParent = NbDocument.findLineRootElement(doc);
            Element line = paragraphsParent.getElement(node.token.line - 1);
            return doc.getText(line.startOffset, line.endOffset);
        }
        
        return "";
    }
    
    shared actual Integer indentSpaces => 4;
    
    shared actual Boolean indentWithSpaces => true;    
}