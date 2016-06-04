import com.redhat.ceylon.ide.common.util {
    ProgressMonitorImpl,
    ProgressMonitorChild
}
import com.redhat.ceylon.ide.netbeans.doc {
    NbDocGenerator
}
import com.redhat.ceylon.ide.netbeans.model {
    findParseController
}

import javax.swing.text {
    Document,
    JTextComponent
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

shared class CeylonCompletionProvider() satisfies CompletionProvider {
    
    shared actual CompletionTask? createTask(Integer queryType, JTextComponent jtc) {
        if (queryType == CompletionProvider.\iCOMPLETION_QUERY_TYPE) {
            return createCompletionTask(jtc);
        } else if (queryType == CompletionProvider.\iDOCUMENTATION_QUERY_TYPE) {
            return AsyncCompletionTask(object extends AsyncCompletionQuery() {
                shared actual void query(CompletionResultSet completionResultSet, Document document, Integer caretOffset) {
                    value cpc = findParseController(jtc.document);
                    value offset = jtc.caret.dot;
                    
                    if (exists cpc,
                        exists lastAnalysis = cpc.lastAnalysis,
                        exists doc = NbDocGenerator(cpc).getDocumentation(lastAnalysis.lastCompilationUnit, offset, lastAnalysis)) {
                        completionResultSet.setDocumentation(CeylonCompletionDocumentation(doc, cpc));
                    }
                    completionResultSet.finish();
                }
            });
        }
        
        return null;
    }
    
    shared actual Integer getAutoQueryTypes(JTextComponent jtc, String string) {
        return 0;
    }

    AsyncCompletionTask createCompletionTask(JTextComponent jtc) {
        return AsyncCompletionTask(object extends AsyncCompletionQuery() {
            shared actual void query(CompletionResultSet completionResultSet, Document document, Integer caretOffset) {
                if (exists controller = findParseController(document)) {
                    //controller.typeCheck(null);
                    nbCompletionItemPosition.reset();
                }
                //value proposals = completionManager.getContentProposals(controller.lastCompilationUnit,
                //    controller, caretOffset, 1, false, DummyProgress());
                //
                //for (proposal in proposals) {
                //    completionResultSet.addItem(proposal);
                //}
                
                completionResultSet.finish();
            }
        }, jtc);
    }
}

class DummyProgress() extends ProgressMonitorImpl<String>.wrap("") {
    shared actual Boolean cancelled => false;
    
    shared actual ProgressMonitorChild<String> newChild(Integer allocatedWork)
            => this;
    
    shared actual void subTask(String subTaskDescription) {}
    
    shared actual void updateRemainingWork(Integer remainingWork) {}
    
    shared actual void worked(Integer amount) {}
    
    shared actual String wrapped => "";
}
