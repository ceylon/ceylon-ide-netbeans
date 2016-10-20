import com.redhat.ceylon.ide.common.completion {
    completionManager
}
import com.redhat.ceylon.ide.netbeans.doc {
    NbDocGenerator
}
import com.redhat.ceylon.ide.netbeans.model {
    findParseController
}
import com.redhat.ceylon.ide.netbeans.platform {
    NbCompletionContext
}
import com.redhat.ceylon.ide.netbeans.util {
    ProgressHandleMonitor
}

import javax.swing.text {
    Document,
    JTextComponent
}

import org.netbeans.api.progress {
    ProgressHandle
}
import org.netbeans.spi.editor.completion {
    CompletionProvider,
    CompletionResultSet,
    CompletionTask
}
import org.netbeans.spi.editor.completion.support {
    AsyncCompletionQuery,
    AsyncCompletionTask
}
import org.netbeans.api.editor.mimelookup {
	mimeRegistration
}

mimeRegistration {
	mimeType = "text/x-ceylon";
	service = `interface CompletionProvider`;
}
shared class CeylonCompletionProvider() satisfies CompletionProvider {
    
    shared actual CompletionTask? createTask(Integer queryType, JTextComponent jtc) {
        if (queryType == CompletionProvider.completionQueryType) {
            return createCompletionTask(jtc);
        } else if (queryType == CompletionProvider.documentationQueryType) {
            return createDocumentationTask(jtc);
        }
        
        return null;
    }
    
    shared actual Integer getAutoQueryTypes(JTextComponent jtc, String string) {
        return 0;
    }

    AsyncCompletionTask createDocumentationTask(JTextComponent jtc) {
        return AsyncCompletionTask(object extends AsyncCompletionQuery() {
            shared actual void query(CompletionResultSet result,
                Document document, Integer caretOffset) {
                
                value cpc = findParseController(jtc.document);
                value offset = jtc.caret.dot;
                
                if (exists cpc,
                    exists lastAnalysis = cpc.lastAnalysis,
                    exists cu = lastAnalysis.lastCompilationUnit,
                    exists doc = NbDocGenerator(cpc).getDocumentation {
                        rootNode = cu;
                        offset = offset;
                        cmp = lastAnalysis;
                    }) {

                    result.setDocumentation(CeylonCompletionDocumentation(doc, cpc));
                }
                result.finish();
            }
        });
    }

    AsyncCompletionTask createCompletionTask(JTextComponent jtc) {
        return AsyncCompletionTask(object extends AsyncCompletionQuery() {
            shared actual void query(CompletionResultSet completionResultSet,
                Document document, Integer caretOffset) {
                
                if (exists controller = findParseController(document),
                    exists result = controller.lastAnalysis,
                    exists cu = result.lastCompilationUnit) {
                    // TODO typecheck?
                    nbCompletionItemPosition.reset();
                    
                    value ctx = NbCompletionContext(result);
                    value handle = ProgressHandle.createHandle("Computing proposals...");
                    value monitor = ProgressHandleMonitor.wrap(handle);
                    handle.start();
                    
                    completionManager.getContentProposals {
                        typecheckedRootNode = cu;
                        ctx = ctx;
                        offset = caretOffset;
                        line = 1;
                        secondLevel = false;
                        monitor = monitor;
                    };
                    
                    handle.finish();
                    
                    for (proposal in ctx.proposals.proposals) {
                        completionResultSet.addItem(proposal);
                    }                    
                }
                
                completionResultSet.finish();
            }
        }, jtc);
    }
}
