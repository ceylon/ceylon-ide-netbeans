import ceylon.formatter.options {
    SparseFormattingOptions,
    Spaces,
    FormattingOptions,
    os
}

import com.redhat.ceylon.ide.common.editor {
    AbstractFormatAction
}
import com.redhat.ceylon.ide.common.refactoring {
    DefaultRegion
}
import com.redhat.ceylon.ide.common.util {
    Indents
}
import com.redhat.ceylon.ide.netbeans.correct {
    InsertEdit,
    TextEdit,
    TextChange,
    NbDocumentChanges,
    nbIndents
}
import com.redhat.ceylon.ide.netbeans.lang {
    NBCeylonParser
}

import javax.swing.text {
    Document
}

import org.netbeans.modules.csl.api {
    Formatter
}
import org.netbeans.modules.csl.spi {
    ParserResult
}
import org.netbeans.modules.editor.indent.spi {
    Context
}
shared object codeFormatter 
        satisfies Formatter
                & AbstractFormatAction<Document,InsertEdit,TextEdit,TextChange>
                & NbDocumentChanges {
    
    shared actual void reformat(Context context, ParserResult? result) {
        if (is NBCeylonParser.CeylonParserResult result) {
            value rn = result.rootNode;
            value doc = context.document();
            value selection = DefaultRegion(context.startOffset(),
                context.endOffset() - context.startOffset());
            value options = SparseFormattingOptions {
                indentMode => Spaces(4);
                lineBreak = os;
            };
            value profile = FormattingOptions();
            
            if (exists change = format(rn, result.tokens, doc,
                doc.length, selection, options, profile)) {
                
                change.applyChanges();
            }
        }
    }
    
    shared actual void reindent(Context context) {
        // TODO
    }
    
    shared actual Boolean needsParserResult() => true;
    
    shared actual Integer indentSize() => 4;
    
    shared actual Integer hangingIndentSize() => 4;


    shared actual Indents<Document> indents => nbIndents;
    
    shared actual TextChange newTextChange(String desc, Document doc)
            => TextChange(doc);
}
