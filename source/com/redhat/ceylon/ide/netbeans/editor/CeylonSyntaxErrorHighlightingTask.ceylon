import ceylon.collection {
	ArrayList
}
import ceylon.interop.java {
	JavaList
}

import org.eclipse.ceylon.compiler.typechecker.analyzer {
	AnalysisError,
	UsageWarning
}
import org.eclipse.ceylon.compiler.typechecker.parser {
	RecognitionError
}
import org.eclipse.ceylon.compiler.typechecker.tree {
	Message,
	Node
}
import org.eclipse.ceylon.ide.common.correct {
	ideQuickFixManager
}
import org.eclipse.ceylon.ide.common.refactoring {
	DefaultRegion
}
import org.eclipse.ceylon.ide.common.typechecker {
	LocalAnalysisResult
}
import org.eclipse.ceylon.ide.common.util {
	ErrorVisitor,
	nodes
}
import com.redhat.ceylon.ide.netbeans.correct {
	NbQuickFixData
}
import com.redhat.ceylon.ide.netbeans.lang {
	NBCeylonParser
}
import com.redhat.ceylon.ide.netbeans.model {
	findParseController,
	CeylonParseController
}

import java.beans {
	PropertyChangeListener
}
import java.util {
	JArrayList=ArrayList,
	JList=List,
	Collections
}

import javax.swing.text {
	Document
}

import org.netbeans.api.editor.mimelookup {
	mimeRegistration
}
import org.netbeans.modules.parsing.api {
	Snapshot
}
import org.netbeans.modules.parsing.impl {
	Utilities
}
import org.netbeans.modules.parsing.spi {
	ParserResultTask,
	Scheduler,
	SchedulerEvent,
	Parser,
	TaskFactory
}
import org.netbeans.spi.editor.hints {
	ErrorDescription,
	ErrorDescriptionFactory {
		createErrorDescription
	},
	Fix,
	HintsController,
	Severity,
	LazyFixList
}

mimeRegistration {
	mimeType = "text/x-ceylon";
	service = `class TaskFactory`;
}
shared class CeylonSyntaxErrorHighlightingTaskFactory() extends TaskFactory() {
    create(Snapshot snapshot)
        => Collections.singleton(CeylonSyntaxErrorHighlightingTask());
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
                    
                    value severity = switch (message)
                        case (is RecognitionError|AnalysisError) Severity.error
                        case (is UsageWarning) Severity.warning
                        else Severity.hint;
                    
                    value errorDescription = createErrorDescription(
                        severity,
                        message.message,
                        NbLazyFixList(controller, lastAnalysis, document, node, message, startOffset, endOffset),
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
    
    class NbLazyFixList(controller, lastAnalysis, document, node, message,
        startOffset, endOffset) satisfies LazyFixList {
        
        variable JList<Fix>? lazyFixes = null;
        
        CeylonParseController controller;
        LocalAnalysisResult lastAnalysis;
        Document document;
        Node node;
        Message message;
        Integer startOffset;
        Integer endOffset;
 
        // TODO check if we should fire PROP_COMPUTED
        addPropertyChangeListener(PropertyChangeListener listener)
                => noop();
        
        computed => lazyFixes exists;
        
        shared actual JList<Fix> fixes {
            if (!exists _ = lazyFixes,
                exists cu = lastAnalysis.lastCompilationUnit,
                exists pu = lastAnalysis.lastPhasedUnit) {
                
                value fixes = ArrayList<Fix>();
                value data = NbQuickFixData {
                    rootNode = cu;
                    project = controller.project;
                    node = node;
                    message = message;
                    ceylonProject = controller.ceylonProject;
                    editorSelection = DefaultRegion(0); // not used for quick fixes
                    phasedUnit = pu;
                    problemLength = endOffset - startOffset;
                    nativeDocument = document;
                    fixes = fixes;
                };
                

                Utilities.acquireParserLock();
                try {
                    ideQuickFixManager.addQuickFixes(data, lastAnalysis.typeChecker);
                } finally {
                    Utilities.releaseParserLock();
                }
                
                lazyFixes = JavaList(fixes);
            }
            
            assert(exists fixes = lazyFixes);
            return fixes;
        }
        
        probablyContainsFixes() => true;
        
        removePropertyChangeListener(PropertyChangeListener? propertyChangeListener)
                => noop();
    }
    
    priority => 100;
    
    schedulerClass => Scheduler.editorSensitiveTaskScheduler;
    
    cancel() => noop();
}