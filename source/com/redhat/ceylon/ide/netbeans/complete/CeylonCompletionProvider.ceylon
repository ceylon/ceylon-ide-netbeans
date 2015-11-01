import com.redhat.ceylon.ide.common.util {
    ProgressMonitor
}
import com.redhat.ceylon.ide.netbeans.doc {
    NbDocGenerator
}
import com.redhat.ceylon.ide.netbeans.model {
    CeylonParseController
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
                    value cpc = CeylonParseController.get(jtc.document);
                    value offset = jtc.caret.dot;
                    
                    if (exists doc = NbDocGenerator(cpc).getDocumentation(cpc.lastCompilationUnit, offset, cpc)) {
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
                CeylonParseController controller = CeylonParseController.get(document);
                controller.typeCheck(null);
                nbCompletionItemPosition.reset();
                value proposals = nbCompletionManager.getContentProposals(controller.lastCompilationUnit,
                    controller, caretOffset, 1, false, DummyProgress());
                
                for (proposal in proposals) {
                    completionResultSet.addItem(proposal);
                }
                
                completionResultSet.finish();
            }
        }, jtc);
    }
}

class DummyProgress() satisfies ProgressMonitor {
    
    shared actual variable Integer workRemaining = 0;
    
    shared actual Object worked(Integer l) {
        return l;
    }
    
    shared actual Object? subTask(String? string) {
        return string;
    }
}
