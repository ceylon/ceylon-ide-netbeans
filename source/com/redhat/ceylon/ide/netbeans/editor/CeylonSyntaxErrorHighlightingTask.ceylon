import ceylon.collection {
    ArrayList
}
import ceylon.interop.java {
    JavaList
}

import com.redhat.ceylon.compiler.typechecker.analyzer {
    AnalysisError,
    UsageWarning
}
import com.redhat.ceylon.compiler.typechecker.parser {
    RecognitionError
}
import com.redhat.ceylon.compiler.typechecker.tree {
    Message
}
import com.redhat.ceylon.ide.common.util {
    ErrorVisitor,
    nodes
}
import com.redhat.ceylon.ide.netbeans.lang {
    NBCeylonParser
}
import com.redhat.ceylon.ide.netbeans.model {
    findParseController
}

import java.lang {
    Class
}
import java.util {
    JArrayList=ArrayList
}

import org.netbeans.modules.parsing.spi {
    ParserResultTask,
    Scheduler,
    SchedulerEvent,
    Parser
}
import org.netbeans.spi.editor.hints {
    ErrorDescription,
    ErrorDescriptionFactory {
        createErrorDescription
    },
    Fix,
    HintsController,
    Severity
}


shared class CeylonSyntaxErrorHighlightingTask() extends ParserResultTask<Parser.Result>() {
    
    shared actual void run(Parser.Result result, SchedulerEvent event) {
        value document = result.snapshot.source.getDocument(false);
        
        if (is NBCeylonParser.CeylonParserResult result,
            exists controller = findParseController(document),
            exists pu = controller.typecheck(result),
            exists lastAnalysis = controller.lastAnalysis) {
        
            value errors = JArrayList<ErrorDescription>();
    
            object extends ErrorVisitor() {
                shared actual void handleMessage(Integer startOffset, 
                    Integer endOffset, Integer startCol, Integer startLine,
                    Message message) {

                    value node = nodes.findNode {
                        node = pu.compilationUnit;
                        tokens = null;
                        startOffset = startOffset;
                        endOffset = endOffset;
                    };
                    
                    if (!exists node) {
                        return;
                    }
                    
                    value severity = switch(message)
                    case (is RecognitionError|AnalysisError) Severity.error
                    case (is UsageWarning) Severity.warning
                    else Severity.hint;
                            
                     value fixes = ArrayList<Fix>();
                     //value data = NbQuickFixData {
                     //    rootNode = lastAnalysis.lastCompilationUnit;
                     //    project = controller.project;
                     //    node = node;
                     //    message = message;
                     //    ceylonProject = controller.ceylonProject;
                     //    editorSelection = DefaultRegion(0); // not used for quick fixes
                     //    phasedUnit = lastAnalysis.lastPhasedUnit;
                     //    problemLength = endOffset - startOffset;
                     //    nativeDocument = document;
                     //    fixes = fixes;
                     //};
                     //
                     //ideQuickFixManager.addQuickFixes(data, lastAnalysis.typeChecker);
                     
                     value errorDescription = createErrorDescription(
                         severity,
                         message.message,
                         JavaList(fixes),
                         document,
                         document.createPosition(startOffset),
                         document.createPosition(endOffset)
                     );
                     errors.add(errorDescription);
                }
            }.visit(pu.compilationUnit);
            
            HintsController.setErrors(document, "ceylon-errors", errors);
        }
    }
    
    shared actual Integer priority {
        return 100;
    }
    
    shared actual Class<out Scheduler> schedulerClass {
        return Scheduler.editorSensitiveTaskScheduler;
    }
    
    shared actual void cancel() {
    }
}