import ceylon.formatter.options {
    SparseFormattingOptions,
    Spaces,
    FormattingOptions,
    os
}

import com.redhat.ceylon.ide.common.editor {
    formatAction
}
import com.redhat.ceylon.ide.common.refactoring {
    DefaultRegion
}
import com.redhat.ceylon.ide.netbeans.correct {
    NbDocument
}
import com.redhat.ceylon.ide.netbeans.lang {
    NBCeylonParser
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

shared object codeFormatter satisfies Formatter {
    
    shared actual void reformat(Context context, ParserResult? result) {
        if (is NBCeylonParser.CeylonParserResult result,
            context.document().length > 0) {
            value rn = result.rootNode;
            value doc = NbDocument(context.document());
            value selection = DefaultRegion(context.startOffset(),
                context.endOffset() - context.startOffset());
            value options = SparseFormattingOptions {
                indentMode => Spaces(4);
                lineBreak = os;
            };
            value profile = FormattingOptions();
            
            if (exists change = formatAction.format(rn, result.tokens, doc,
                doc.size, selection, options, profile)) {
                
                change.apply();
            }
        }
    }
    
    shared actual void reindent(Context context) {
        // TODO
    }
    
    needsParserResult() => true;
    
    indentSize() => 4;
    
    hangingIndentSize() => 4;
}
