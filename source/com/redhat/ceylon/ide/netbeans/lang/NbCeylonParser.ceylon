import com.redhat.ceylon.compiler.typechecker.parser {
    CeylonLexer,
    CeylonParser
}
import com.redhat.ceylon.compiler.typechecker.tree {
    Tree
}

import java.util {
    Collections,
    List
}

import javax.swing.event {
    ChangeListener
}

import org.antlr.runtime {
    ANTLRStringStream,
    CommonTokenStream,
    RecognitionException,
    CommonToken
}
import org.netbeans.modules.csl.api {
    Error
}
import org.netbeans.modules.csl.spi {
    ParserResult
}
import org.netbeans.modules.parsing.api {
    Snapshot,
    Task
}
import org.netbeans.modules.parsing.spi {
    ParseException,
    Parser,
    SourceModificationEvent
}
import org.openide.util {
    Exceptions
}
import com.redhat.ceylon.ide.common.util {
    unsafeCast
}

shared class NBCeylonParser() extends Parser() {
    variable CeylonParserResult? result = null;
    
    shared actual void parse(Snapshot snapshot, Task task, SourceModificationEvent event) {
        ANTLRStringStream input = ANTLRStringStream(snapshot.text.string);
        CeylonLexer ceylonLexer = CeylonLexer(input);
        CommonTokenStream cts = CommonTokenStream(ceylonLexer);
        cts.fill();
        
        try {
            value parser = CeylonParser(cts);
            
            value tokens = unsafeCast<List<CommonToken>>(cts.tokens);
            
            result = CeylonParserResult {
                snapshot = snapshot;
                parser = parser;
                rootNode = parser.compilationUnit();
                tokens = tokens;
            };
        } catch (RecognitionException ex) {
            result = null;
            Exceptions.printStackTrace(ex);
        }
    }
    
    shared actual Result? getResult(Task task) {
        return result;
    }
    
    shared actual void cancel() {
    }
    
    shared actual void addChangeListener(ChangeListener changeListener) {
    }
    
    shared actual void removeChangeListener(ChangeListener changeListener) {
    }
    
    shared class CeylonParserResult(Snapshot snapshot, CeylonParser parser,
        shared Tree.CompilationUnit rootNode,
        shared List<CommonToken> tokens)
            extends ParserResult(snapshot) {
        
        variable Boolean valid = true;
        
        shared CeylonParser ceylonParser {
            if (!valid) {
                throw ParseException();
            }
            
            return parser;
        }
        
        shared actual void invalidate() {
            valid = false;
        }
        
        shared actual List<out Error> diagnostics {
            return Collections.emptyList<Error>();
        }
    }
}
