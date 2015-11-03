import com.redhat.ceylon.compiler.typechecker.parser {
    CeylonLexer,
    CeylonParser
}

import java.util {
    Collections,
    List,
    ArrayList
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
import com.redhat.ceylon.compiler.typechecker.tree {
    Tree
}
import ceylon.interop.java {
    CeylonIterable
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
            
            value tokens = ArrayList<CommonToken>();
            for (tok in CeylonIterable(cts.tokens)) {
                assert(is CommonToken tok);
                tokens.add(tok);
            }

            // TODO fix com.redhat.ceylon.model.loader.ModelResolutionException: Failed to resolve org.antlr.runtime.CommonToken
            //assert(is List<CommonToken> tokens = cts.tokens);
            
            result = CeylonParserResult(snapshot, parser,
                parser.compilationUnit(), tokens);
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
