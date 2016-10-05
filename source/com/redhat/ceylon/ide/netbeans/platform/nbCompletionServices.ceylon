import ceylon.collection {
    ArrayList
}

import com.redhat.ceylon.cmr.api {
    ModuleVersionDetails,
    ModuleSearchResult
}
import com.redhat.ceylon.compiler.typechecker.tree {
    Tree,
    Node
}
import com.redhat.ceylon.ide.common.completion {
    ProposalsHolder,
    CompletionContext,
    ProposalKind
}
import com.redhat.ceylon.ide.common.doc {
    Icons
}
import com.redhat.ceylon.ide.common.platform {
    CompletionServices,
    TextChange
}
import com.redhat.ceylon.ide.common.refactoring {
    DefaultRegion
}
import com.redhat.ceylon.ide.common.settings {
    CompletionOptions
}
import com.redhat.ceylon.ide.common.typechecker {
    LocalAnalysisResult
}
import com.redhat.ceylon.ide.netbeans {
    nbIcons
}
import com.redhat.ceylon.ide.netbeans.complete {
    CeylonCompletionItem
}
import com.redhat.ceylon.model.typechecker.model {
    Declaration,
    Unit,
    Package,
    Type,
    Scope,
    Reference
}
import java.util.concurrent {
	Future
}
import com.redhat.ceylon.compiler.typechecker.context {
	PhasedUnit
}

// TODO
object nbCompletionServices satisfies CompletionServices {
    shared actual void addNestedProposal(ProposalsHolder proposals, Icons|Declaration icon, String description, DefaultRegion region, String text) {}
    
    shared actual void addProposal(CompletionContext ctx, Integer offset, 
        String prefix, Icons|Declaration icon, String description, String text,
        ProposalKind kind, TextChange? additionalChange, DefaultRegion? selection) {
        
        if (is NbCompletionContext ctx) {
            value image = switch(icon)
            case(is Icons) nbIcons.forCommonIcon(icon)
            else nbIcons.forDeclaration(icon);
            
            ctx.proposals.addItem(CeylonCompletionItem(
                text, description, offset, prefix, image
            ));
        }
    }
    
    createProposalsHolder() => NbProposalsHolder();
    
    shared actual void newControlStructureCompletionProposal(Integer offset, String prefix, String desc, String text, Declaration dec, CompletionContext cpc, Node? node) {}
    
    shared actual void newFunctionCompletionProposal(Integer offset, String prefix, String desc, String text, Declaration dec, Unit unit, CompletionContext cmp) {}
    
    shared actual void newImportedModulePackageProposal(Integer offset, String prefix, String memberPackageSubname, Boolean withBody, String fullPackageName, CompletionContext controller, Package candidate) {}
    
    shared actual void newJDKModuleProposal(CompletionContext ctx, Integer offset, String prefix, Integer len, String versioned, String name) {}
    
    shared actual void newModuleDescriptorProposal(CompletionContext ctx, Integer offset, String prefix, String desc, String text, Integer selectionStart, Integer selectionEnd) {}
    
    shared actual void newModuleProposal(Integer offset, String prefix, Integer len, String versioned, ModuleSearchResult.ModuleDetails mod, Boolean withBody, ModuleVersionDetails version, String name, Node node, CompletionContext cpc) {}
    
    shared actual void newPackageDescriptorProposal(CompletionContext ctx, Integer offset, String prefix, String desc, String text) {}
    
    shared actual void newParameterInfo(CompletionContext ctx, Integer offset, Declaration dec, Reference producedReference, Scope scope, Boolean namedInvocation) {}
    
    shared actual void newParametersCompletionProposal(CompletionContext ctx, Integer offset, String prefix, String desc, String text, List<Type> argTypes, Node node, Unit unit) {}
    
    shared actual void newQueriedModulePackageProposal(Integer offset, String prefix, String memberPackageSubname, Boolean withBody, String fullPackageName, CompletionContext controller, ModuleVersionDetails version, Unit unit, ModuleSearchResult.ModuleDetails md) {}
    
    shared actual void newRefinementCompletionProposal(Integer offset, String prefix, Reference? pr, String desc, String text, CompletionContext cmp, Declaration dec, Scope scope, Boolean fullType, Boolean explicitReturnType) {}
    
    shared actual void newTypeProposal(ProposalsHolder proposals, Integer offset, Type? type, String text, String desc, Tree.CompilationUnit rootNode) {}
}

shared class NbProposalsHolder() satisfies ProposalsHolder {
    value props = ArrayList<CeylonCompletionItem>();
    
    size => props.size;
    
    shared void addItem(CeylonCompletionItem item)
            => props.add(item);
    
    shared List<CeylonCompletionItem> proposals => props;
}

shared class NbCompletionContext(LocalAnalysisResult lar)
        satisfies CompletionContext {
    
    assert(exists cu = lar.lastCompilationUnit);
    assert(exists pu = lar.lastPhasedUnit);
    assert(exists tc = lar.typeChecker);
    
    ceylonProject => lar.ceylonProject;
    
    commonDocument => lar.commonDocument;
    
    lastCompilationUnit => cu;
    
    lastPhasedUnit => pu;
    
    options = object extends CompletionOptions() {
        // TODO
    };
    
    parsedRootNode => lar.parsedRootNode;
    
    proposalFilters => empty;
    
    shared actual NbProposalsHolder proposals = NbProposalsHolder();
    
    tokens => lar.tokens;
    
    typeChecker => tc;

    shared actual Future<out PhasedUnit> phasedUnitWhenTypechecked => nothing;
    
    typecheckedPhasedUnit => lar.typecheckedPhasedUnit;
}
