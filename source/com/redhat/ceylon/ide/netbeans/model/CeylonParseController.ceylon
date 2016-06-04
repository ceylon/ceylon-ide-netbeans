import ceylon.interop.java {
    javaClass
}

import com.redhat.ceylon.compiler.typechecker.context {
    PhasedUnit
}
import com.redhat.ceylon.ide.common.model {
    BaseIdeModuleSourceMapper
}
import com.redhat.ceylon.ide.common.typechecker {
    LocalAnalysisResult,
    EditedPhasedUnit,
    ProjectPhasedUnit
}
import com.redhat.ceylon.ide.common.util {
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
import com.redhat.ceylon.model.typechecker.model {
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


shared CeylonParseController? findParseController(Document doc) {
    value docProperty = "CeylonParseController";

    if (is NbEditorDocument doc) {
        CeylonParseController cpc;

        if (is CeylonParseController existing = doc.getProperty(docProperty)) {
            cpc = existing;
        } else {
            cpc = CeylonParseController(doc);
            doc.putProperty(docProperty, cpc);
        }
        
        return cpc;
    }
    
    return null;
}

shared class CeylonParseController(NbEditorDocument doc) {
    
    shared Project project {
        value lookup = TopComponent.registry.activated.lookup;
        
        if (exists p = lookup.lookup(javaClass<Project>())) {
            return p;
        }
        
        if (exists dob = lookup.lookup(javaClass<DataObject>())) {
            return FileOwnerQuery.getOwner(dob.primaryFile);
        }
        
        // We should have found something
        assert(false);
    }

    shared variable LocalAnalysisResult? lastAnalysis = null;
    
    value projects = Lookup.default.lookup(javaClass<NbCeylonProjects>());
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
                    
                    typecheckedRootNode => cu;
                    
                    
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