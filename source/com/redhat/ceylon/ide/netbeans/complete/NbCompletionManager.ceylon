import com.redhat.ceylon.cmr.api {
    ModuleVersionDetails,
    ModuleSearchResult
}
import com.redhat.ceylon.compiler.typechecker.tree {
    Tree,
    Node
}
import com.redhat.ceylon.ide.common.completion {
    IdeCompletionManager
}
import com.redhat.ceylon.ide.common.util {
    Indents
}
import com.redhat.ceylon.ide.netbeans.correct {
    nbIndents
}
import com.redhat.ceylon.ide.netbeans.doc {
    NbDocGenerator
}
import com.redhat.ceylon.ide.netbeans.model {
    CeylonParseController
}
import com.redhat.ceylon.model.typechecker.model {
    Declaration,
    Unit,
    Package,
    Type,
    Scope,
    Reference
}

import java.util {
    JList=List
}
import java.util.regex {
    Pattern
}

import javax.swing.text {
    Document
}

import org.netbeans.api.project {
    Project
}
import org.netbeans.spi.editor.completion {
    CompletionTask,
    CompletionResultSet
}
import org.netbeans.spi.editor.completion.support {
    AsyncCompletionQuery,
    AsyncCompletionTask
}
import com.redhat.ceylon.ide.netbeans {
    nbIcons
}

shared object nbCompletionManager
        extends IdeCompletionManager<CeylonParseController, Project, CeylonCompletionItem, Document>() {
    
    shared actual String getDocumentSubstring(Document doc, Integer start, Integer length)
            => doc.getText(start, length);
    
    shared actual Indents<Document> indents => nbIndents;
    
    shared actual CeylonCompletionItem newAnonFunctionProposal(Integer offset, Type? requiredType,
        Unit unit, String text, String header, Boolean isVoid, Integer selectionStart, Integer selectionLength)
            => CeylonCompletionItem(text, header, offset, "", nbIcons.anonymousFunction);
    
    shared actual CeylonCompletionItem newBasicCompletionProposal(Integer offset, String prefix,
        String text, String escapedText, Declaration decl, CeylonParseController cmp)
            => CeylonCompletionItem(escapedText, text, offset, prefix, nbIcons.correct);
    
    shared actual CeylonCompletionItem newControlStructureCompletionProposal(Integer offset, String prefix,
        String desc, String text, Declaration dec, CeylonParseController cpc, Node? node)
            => CeylonCompletionItem(text, desc, offset, prefix, nbIcons.correct);
    
    shared actual CeylonCompletionItem newCurrentPackageProposal(Integer offset, String prefix,
        String packageName, CeylonParseController cmp)
            => CeylonCompletionItem(packageName, packageName, offset, prefix, nbIcons.packages);
    
    shared actual CeylonCompletionItem newFunctionCompletionProposal(Integer offset, String prefix,
        String desc, String text, Declaration dec, Unit unit, CeylonParseController cmp)
            => CeylonCompletionItem(text, desc, offset, prefix, nbIcons.correct);
    
    shared actual CeylonCompletionItem newImportedModulePackageProposal(Integer offset, String prefix,
        String memberPackageSubname, Boolean withBody, String fullPackageName, CeylonParseController controller,
        Package candidate)
            => CeylonCompletionItem(memberPackageSubname, fullPackageName, offset, prefix, nbIcons.packages);
    
    shared actual CeylonCompletionItem newInvocationCompletion(Integer offset, String prefix,
        String _desc, String text, Declaration dec, Reference? pr, Scope scope, CeylonParseController cmp,
        Boolean includeDefaulted, Boolean positionalInvocation, Boolean namedInvocation, Boolean inherited,
        Boolean qualified, Declaration? qualifyingDec) {

        return object extends CeylonCompletionItem(text, _desc, offset, prefix, nbIcons.forDeclaration(dec)) {
            shared actual CompletionTask? createDocumentationTask() {
                return AsyncCompletionTask(object extends AsyncCompletionQuery() {
                    shared actual void query(CompletionResultSet completionResultSet,
                        Document document, Integer int) {
                        
                        if (exists doc = NbDocGenerator(cmp).getDocumentationText(dec, null, cmp.lastCompilationUnit, cmp)) {
                            completionResultSet.setDocumentation(CeylonCompletionDocumentation(doc, cmp));
                        }
                        completionResultSet.finish();
                    }
                });
            }
        };
    }
    
    shared actual CeylonCompletionItem newJDKModuleProposal(Integer offset, String prefix,
        Integer len, String versioned, String name)
            => CeylonCompletionItem(name, versioned, offset, prefix, nbIcons.modules);
    
    shared actual CeylonCompletionItem newKeywordCompletionProposal(Integer offset, String prefix,
        String keyword, String text)
            => CeylonCompletionItem(text, keyword, offset, prefix, nbIcons.correct);
    
    shared actual CeylonCompletionItem newMemberNameCompletionProposal(Integer offset, String prefix,
        String name, String unquotedName)
            => CeylonCompletionItem(name, unquotedName, offset, prefix, nbIcons.correct);
    
    shared actual CeylonCompletionItem newModuleDescriptorProposal(Integer offset, String prefix,
        String desc, String text, Integer selectionStart, Integer selectionEnd)
            => CeylonCompletionItem(text, desc, offset, prefix, nbIcons.modules);
    
    shared actual CeylonCompletionItem newModuleProposal(Integer offset, String prefix, Integer len,
        String versioned, ModuleSearchResult.ModuleDetails mod, Boolean withBody,
        ModuleVersionDetails version, String name, Node node, CeylonParseController cpc)
            => CeylonCompletionItem(name, versioned, offset, prefix, nbIcons.modules);
    
    shared actual CeylonCompletionItem newPackageDescriptorProposal(Integer offset, String prefix,
        String desc, String text)
            => CeylonCompletionItem(text, desc, offset, prefix, nbIcons.packages);
    
    // Not supported
    suppressWarnings("expressionTypeNothing")
    shared actual CeylonCompletionItem newParameterInfo(Integer offset, Declaration dec,
        Reference producedReference, Scope scope, CeylonParseController cpc, Boolean namedInvocation)
            => nothing;
    
    shared actual CeylonCompletionItem newParametersCompletionProposal(Integer offset, String prefix,
        String desc, String text, JList<Type> argTypes, Node node, Unit unit)
            => CeylonCompletionItem(text, desc, offset, prefix, nbIcons.param);
    
    shared actual CeylonCompletionItem newQueriedModulePackageProposal(Integer offset, String prefix,
        String memberPackageSubname, Boolean withBody, String fullPackageName,
        CeylonParseController controller, ModuleVersionDetails version, Unit unit, ModuleSearchResult.ModuleDetails md)
            => CeylonCompletionItem(memberPackageSubname, fullPackageName, offset, prefix, nbIcons.modules);
    
    shared actual CeylonCompletionItem newRefinementCompletionProposal(Integer offset, String prefix,
        Reference? pr, String desc, String text, CeylonParseController cmp, Declaration dec,
        Scope scope, Boolean fullType, Boolean explicitReturnType)
            => CeylonCompletionItem(text, desc, offset, prefix, nbIcons.forDeclaration(dec));
    
    shared actual CeylonCompletionItem newTypeProposal(Integer offset, Type? type, String text,
        String desc, Tree.CompilationUnit rootNode)
            => CeylonCompletionItem(text, desc, offset, "");
    
    shared actual List<Pattern> proposalFilters => empty;
}