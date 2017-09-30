import org.eclipse.ceylon.compiler.typechecker.context {
    PhasedUnit
}
import org.eclipse.ceylon.ide.common.model {
    BaseIdeModuleSourceMapper
}
import org.eclipse.ceylon.ide.common.typechecker {
    LocalAnalysisResult,
    EditedPhasedUnit,
    ProjectPhasedUnit
}
import org.eclipse.ceylon.ide.common.util {
    SingleSourceUnitPackage
}
import com.redhat.ceylon.ide.netbeans.correct {
    NbDocument
}
import com.redhat.ceylon.ide.netbeans.lang {
    NBCeylonParser
}
import com.redhat.ceylon.ide.netbeans.platform {
    NbFileVirtualFile,
    NbFolderVirtualFile
}
import org.eclipse.ceylon.model.typechecker.model {
    Package
}

import javax.swing.text {
    Document
}

import org.netbeans.api.java.project {
    JavaProjectConstants
}
import org.netbeans.api.project {
    Project,
    FileOwnerQuery,
    ProjectUtils
}
import org.netbeans.modules.editor {
    NbEditorDocument
}
import org.openide.filesystems {
    FileObject,
    FileUtil
}
import org.openide.loaders {
    DataObject
}
import org.openide.util {
    Lookup
}
import org.openide.windows {
    TopComponent
}
import java.util.concurrent {
	Future
}
import java.lang.ref {
	WeakReference
}

shared CeylonParseController? findParseController(Document doc) {
    value docProperty = "CeylonParseController";

    if (is NbEditorDocument doc) {
        CeylonParseController cpc;

        if (is WeakReference<out Anything> existing = doc.getProperty(docProperty),
            is CeylonParseController c = existing.get()) {
            cpc = c;
        } else {
            cpc = CeylonParseController(doc);
            doc.putProperty(docProperty, WeakReference(cpc));
        }
        
        return cpc;
    }
    
    return null;
}

shared class CeylonParseController(NbEditorDocument doc) {
    
    shared Project project {
        value lookup = TopComponent.registry.activated.lookup;
        
        if (exists p = lookup.lookup(`Project`)) {
            return p;
        }
        
        if (exists dob = lookup.lookup(`DataObject`)) {
            return FileOwnerQuery.getOwner(dob.primaryFile);
        }
        
        "The current project should have been found"
        assert(false);
    }

    shared variable LocalAnalysisResult? lastAnalysis = null;
    
    value projects = Lookup.default.lookup(`NbCeylonProjects`);
    assert(is NbCeylonProject _p = projects.getProject(project));
    shared NbCeylonProject ceylonProject = _p;
    
    shared NbDocument commonDocument = NbDocument(doc);

    "Operates a local typecheck of the parser [[result]],
     without updating the global model."
    shared PhasedUnit? typecheck(NBCeylonParser.CeylonParserResult result) {
        if (ceylonProject.typechecked,
            exists tc = ceylonProject.typechecker) {
            
            return ceylonProject.withSourceModel(true, () {
                value mod = ceylonProject.ideArtifact;
                value fo = result.snapshot.source.fileObject;
                value sourceCodeVirtualFile = NbFileVirtualFile(mod, fo);
                PhasedUnit? phasedUnit = tc.getPhasedUnit(sourceCodeVirtualFile);
                value cu = result.rootNode;
                NbFolderVirtualFile srcDir;
                Package pkg;
                
                if (exists phasedUnit) {
                    assert(is NbFolderVirtualFile f = phasedUnit.srcDir);
                    srcDir = f;
                    pkg = phasedUnit.\ipackage;
                } else {
                    value sf = getSourceFolder(fo, mod);
                    
                    if (!exists sf) {
                        return null;
                    }
                    srcDir = NbFolderVirtualFile(mod, sf);
                    assert(exists cp = srcDir.ceylonPackage);
                    pkg = cp;
                }
                
                value projectPu = switch (phasedUnit)
                case (is EditedPhasedUnit<Project,FileObject,FileObject,FileObject>) phasedUnit.originalPhasedUnit
                case (is ProjectPhasedUnit<Project,FileObject,FileObject,FileObject>) phasedUnit
                else null;
                
                value singleSourceUnitPackage = SingleSourceUnitPackage(pkg, sourceCodeVirtualFile.path);
                
                assert(is BaseIdeModuleSourceMapper msm = tc.phasedUnits.moduleSourceMapper);
                
                value editedPhasedUnit = EditedPhasedUnit {
                    unitFile = sourceCodeVirtualFile;
                    srcDir = srcDir;
                    cu = cu;
                    p = singleSourceUnitPackage;
                    moduleManager = tc.phasedUnits.moduleManager;
                    moduleSourceMapper = msm;
                    typeChecker = tc;
                    tokens = result.tokens;
                    savedPhasedUnit = projectPu;
                    project = mod;
                    file = fo;
                };
                
                msm.moduleManager.modelLoader.loadPackageDescriptors();
                editedPhasedUnit.validateTree();
                editedPhasedUnit.visitSrcModulePhase();
                editedPhasedUnit.visitRemainingModulePhase();
                editedPhasedUnit.scanDeclarations();
                editedPhasedUnit.scanTypeDeclarations();
                editedPhasedUnit.validateRefinement();
                editedPhasedUnit.analyseTypes();
                editedPhasedUnit.analyseUsage();
                editedPhasedUnit.analyseFlow();

                lastAnalysis = object satisfies LocalAnalysisResult {
                    ceylonProject => outer.ceylonProject;
                    
                    commonDocument => outer.commonDocument;
                    
                    lastCompilationUnit => cu;
                    
                    lastPhasedUnit => editedPhasedUnit;
                    
                    parsedRootNode => cu;
                    
                    tokens => editedPhasedUnit.tokens;
                    
                    typeChecker => tc;
                    
                    shared actual Future<out PhasedUnit> phasedUnitWhenTypechecked => nothing;
                    
                    typecheckedPhasedUnit => editedPhasedUnit;
                };
                
                return editedPhasedUnit;
            }, 0);
        }
        
        return null;
    }
    
    FileObject? getSourceFolder(FileObject fo, Project project) {
        for (source in ProjectUtils.getSources(project)
            .getSourceGroups(JavaProjectConstants.sourcesTypeJava)) {
            
            if (FileUtil.isParentOf(source.rootFolder, fo)) {
                return source.rootFolder;
            }
        }
        
        return null;
    }
}