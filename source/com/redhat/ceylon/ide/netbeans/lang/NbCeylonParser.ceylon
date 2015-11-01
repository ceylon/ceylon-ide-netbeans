import com.redhat.ceylon.compiler.typechecker.parser {
    CeylonLexer,
    CeylonParser
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
    RecognitionException
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

shared class NBCeylonParser() extends Parser() {
    variable Snapshot? snapshot = null;
    variable CeylonParser? ceylonParser = null;
    variable Tree.CompilationUnit? rootNode = null;
     
    shared actual void parse(Snapshot snapshot, Task task, SourceModificationEvent event) {
        this.snapshot = snapshot;
        ANTLRStringStream input = ANTLRStringStream(snapshot.text.string);
        CeylonLexer ceylonLexer = CeylonLexer(input);
        CommonTokenStream cts = CommonTokenStream(ceylonLexer);

        ceylonParser = CeylonParser(cts);
        try {
            assert(exists parser = ceylonParser);
            rootNode = parser.compilationUnit();
        } catch (RecognitionException ex) {
            Exceptions.printStackTrace(ex);
        }
    }
    
    shared actual Result getResult(Task task) {
        assert(exists snap = snapshot, exists parser = ceylonParser,
               exists rn = rootNode);
        return CeylonParserResult(snap, parser, rn);
    }
    
    shared actual void cancel() {
    }
    
    shared actual void addChangeListener(ChangeListener changeListener) {
    }
    
    shared actual void removeChangeListener(ChangeListener changeListener) {
    }
    
    shared class CeylonParserResult(Snapshot snapshot, CeylonParser parser,
        shared Tree.CompilationUnit rootNode)
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
