import ceylon.collection {
    ArrayList
}
import ceylon.interop.java {
    JavaList,
    CeylonIterable
}

import com.redhat.ceylon.compiler.typechecker.analyzer {
    AnalysisError,
    UsageWarning
}
import com.redhat.ceylon.compiler.typechecker.parser {
    RecognitionError
}
import com.redhat.ceylon.compiler.typechecker.tree {
    Node,
    Tree,
    Visitor
}
import com.redhat.ceylon.ide.common.correct {
    ideQuickFixManager
}
import com.redhat.ceylon.ide.netbeans.correct {
    NbQuickFixData
}
import com.redhat.ceylon.ide.netbeans.lang {
    NBCeylonParser
}
import com.redhat.ceylon.ide.netbeans.model {
    CeylonParseController
}

import java.lang {
    Class
}
import java.util {
    JArrayList=ArrayList
}

import org.antlr.runtime {
    CommonToken
}
import org.netbeans.modules.parsing.spi {
    ParserResultTask,
    Scheduler,
    SchedulerEvent,
    Parser
}
import org.netbeans.spi.editor.hints {
    ErrorDescription,
    ErrorDescriptionFactory,
    Fix,
    HintsController,
    Severity
}


shared class CeylonSyntaxErrorHighlightingTask() extends ParserResultTask<Parser.Result>() {
    
    shared actual void run(Parser.Result result, SchedulerEvent event) {
        value document = result.snapshot.source.getDocument(false);
//        value controller = CeylonParseController.get(document);
//        value cu = if (is NBCeylonParser.CeylonParserResult result)
//                   then result.rootNode else null;
//        
//        if (!exists p = controller.project) {
//            return; 
//        }
//        value pu = controller.typeCheck(cu);
//        value errors = JArrayList<ErrorDescription>();
//
//        object extends Visitor() {
//            shared actual void visitAny(Node that) {
//                super.visitAny(that);
//                
//                for (error in CeylonIterable(that.errors)) {
//                    variable value start = that.startIndex?.intValue();
//                    variable value end = that.endIndex?.intValue();
//                    if (exists _s = start,
//                        exists _e = end) {
//
//                        variable value severity = Severity.\iHINT;
//                        
//                        if (is Tree.Declaration that,
//                            exists id = that.identifier) {
//                            start = id.startIndex.intValue();
//                            end = id.endIndex.intValue(); 
//                        }
//                        
//                        if (is RecognitionError error,
//                            is CommonToken token = error.recognitionException.token) {
//                            
//                            start = token.startIndex;
//                            end = token.stopIndex + 1;
//                            severity = Severity.\iERROR;
//                        } else if (is AnalysisError error) {
//                            severity = Severity.\iERROR;
//                        } else if (is UsageWarning error) {
//                            severity = Severity.\iWARNING;
//                        }
//                     
//                        assert(exists s = start, exists e = end);
//
//                         value fixes = ArrayList<Fix>();
//                         value data = NbQuickFixData {
//                             rootNode = controller.lastCompilationUnit;
//                             project = controller.project;
//                             node = that;
//                             message = error;
//                             ceylonProject = controller.ceylonProject;
//                             editorSelection = nothing;
//                             phasedUnit = controller.lastPhasedUnit;
//                             problemLength = e-s;
//                             nativeDocument = document;
//                             fixes = fixes;
//                         };
//                         
//                         ideQuickFixManager.addQuickFixes(data, controller.typeChecker);
//                         
//                         value errorDescription = ErrorDescriptionFactory.createErrorDescription(
//                             severity,
//                             error.message,
//                             JavaList(fixes),
//                             document,
//                             document.createPosition(s),
//                             document.createPosition(e)
//                         );
//                         errors.add(errorDescription);
//   
//                    }
//                }
//            }
//        }.visit(pu.compilationUnit);
//        
//        HintsController.setErrors(document, "ceylon-errors", errors);
    }
    
    shared actual Integer priority {
        return 100;
    }
    
    shared actual Class<out Scheduler> schedulerClass {
        return Scheduler.\iEDITOR_SENSITIVE_TASK_SCHEDULER;
    }
    
    shared actual void cancel() {
    }
}