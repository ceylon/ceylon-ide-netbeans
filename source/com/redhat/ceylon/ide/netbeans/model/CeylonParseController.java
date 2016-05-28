package com.redhat.ceylon.ide.netbeans.model;

import java.util.List;

import javax.swing.text.BadLocationException;
import javax.swing.text.Document;

import org.antlr.runtime.ANTLRStringStream;
import org.antlr.runtime.CommonToken;
import org.antlr.runtime.CommonTokenStream;
import org.antlr.runtime.RecognitionException;
import org.netbeans.api.java.project.JavaProjectConstants;
import org.netbeans.api.project.FileOwnerQuery;
import org.netbeans.api.project.Project;
import org.netbeans.api.project.ProjectUtils;
import org.netbeans.api.project.SourceGroup;
import org.netbeans.modules.editor.NbEditorUtilities;
import org.openide.filesystems.FileObject;
import org.openide.filesystems.FileUtil;
import org.openide.loaders.DataObject;
import org.openide.util.Exceptions;
import org.openide.windows.TopComponent;

import com.redhat.ceylon.compiler.typechecker.TypeChecker;
import com.redhat.ceylon.compiler.typechecker.context.PhasedUnit;
import com.redhat.ceylon.compiler.typechecker.io.VirtualFile;
import com.redhat.ceylon.compiler.typechecker.parser.CeylonLexer;
import com.redhat.ceylon.compiler.typechecker.parser.CeylonParser;
import com.redhat.ceylon.compiler.typechecker.parser.LexError;
import com.redhat.ceylon.compiler.typechecker.parser.ParseError;
import com.redhat.ceylon.compiler.typechecker.tree.Tree;
import com.redhat.ceylon.ide.common.model.CeylonProject;
import com.redhat.ceylon.ide.common.platform.CommonDocument;
import com.redhat.ceylon.ide.common.settings.CompletionOptions;
import com.redhat.ceylon.ide.common.typechecker.LocalAnalysisResult;
import com.redhat.ceylon.ide.common.vfs.LocalFileVirtualFile;
import com.redhat.ceylon.ide.common.vfs.LocalFolderVirtualFile;
import com.redhat.ceylon.model.typechecker.model.Module;

/**
 *
 * @author bastien
 */
public class CeylonParseController implements LocalAnalysisResult {

    private static Object DOC_PROPERTY = "CeylonParseController";
    
    public static CeylonParseController get(Document doc) {
        CeylonParseController cpc = (CeylonParseController) doc.getProperty(DOC_PROPERTY);
        
        if (cpc != null) {
            return cpc;
        }
        
        cpc = new CeylonParseController(doc);
        doc.putProperty(DOC_PROPERTY, cpc);
        return cpc;
    }
    
    private TypeChecker typeChecker;
    private Tree.CompilationUnit lastCompilationUnit;
    private PhasedUnit lastPhasedUnit;
    private Document document;

    private CeylonParseController(Document doc) {
        this.document = doc;
        
        Project p = getProject();
        if (typeChecker == null && p != null) {
            //typeChecker = ceylonBuilder_.get_().getOrCreateTypeChecker(p);
        }
    }

    public PhasedUnit typeCheck(Tree.CompilationUnit cu) {
//        try {
//            Project project = getProject();
//            if (project == null) {
//                return null; // happens for units in dependencies
//            }
//            FileObject fileObject = NbEditorUtilities.getFileObject(document);
//            String text;
////            if (cu == null) {
//                text = document.getText(0, document.getLength());
////            } else {
////                text = cu.getText();
////            }
//            ANTLRStringStream input = new ANTLRStringStream(text);
//            CeylonLexer ceylonLexer = new CeylonLexer(input);
//            CommonTokenStream cts = new CommonTokenStream(ceylonLexer);
//            cts.fill();
//            
////            if (cu == null) {    
//                CeylonParser ceylonParser = new CeylonParser(cts);
//                cu = ceylonParser.compilationUnit();
//    
//                collectLexAndParseErrors(ceylonLexer, ceylonParser, cu);
////            }
//            
//            com.redhat.ceylon.model.typechecker.model.Package pack = null;
//
//            VirtualFile vf = new LocalFileVirtualFile(FileUtil.toFile(fileObject));
//            VirtualFile src = null;
//
//            SourceGroup[] roots = ProjectUtils.getSources(project).getSourceGroups(JavaProjectConstants.SOURCES_TYPE_JAVA);
//
//            for (SourceGroup root : roots) {
//                if (FileUtil.isParentOf(root.getRootFolder(), fileObject)) {
//                    src = new LocalFolderVirtualFile(FileUtil.toFile(root.getRootFolder()));
//                }
//            }
//
//            if (src != null) {
//                String packageName = vf.getPath().substring(src.getPath().length() + 1)
//                        .replace("/" + vf.getName(), "").replace('/', '.');
//
//                for (Module mod : typeChecker.getContext().getModules().getListOfModules()) {
//                    if (packageName.startsWith(mod.getNameAsString())) {
//                        pack = mod.getDirectPackage(packageName);
//                    }
//                }
//            }
//
//            PhasedUnit phasedUnit = new PhasedUnit(vf, src, cu, pack,
//                    typeChecker.getPhasedUnits().getModuleManager(),
//                    typeChecker.getPhasedUnits().getModuleSourceMapper(),
//                    typeChecker.getContext(), cts.getTokens());
//
//            phasedUnit.validateTree();
//            phasedUnit.visitSrcModulePhase();
//            phasedUnit.visitRemainingModulePhase();
//            phasedUnit.scanDeclarations();
//            phasedUnit.scanTypeDeclarations();
//            phasedUnit.validateRefinement();
//            phasedUnit.analyseTypes();
//            phasedUnit.analyseUsage();
//            phasedUnit.analyseFlow();
//
//            if (typeChecker.getPhasedUnitFromRelativePath(phasedUnit.getPathRelativeToSrcDir()) != null) {
//                typeChecker.getPhasedUnits().removePhasedUnitForRelativePath(phasedUnit.getPathRelativeToSrcDir());
//            }
//            typeChecker.getPhasedUnits().addPhasedUnit(phasedUnit.getUnitFile(), phasedUnit);
//
//            lastCompilationUnit = cu;
//            lastPhasedUnit = phasedUnit;
//
//            return phasedUnit;
//        } catch (BadLocationException | RecognitionException ex) {
//            Exceptions.printStackTrace(ex);
//        }

        return null;
    }

    private void collectLexAndParseErrors(CeylonLexer lexer,
            CeylonParser parser, Tree.CompilationUnit cu) {
        List<LexError> lexerErrors = lexer.getErrors();
        for (LexError le : lexerErrors) {
            cu.addLexError(le);
        }
        lexerErrors.clear();
        
        List<ParseError> parserErrors = parser.getErrors();
        for (ParseError pe : parserErrors) {
            cu.addParseError(pe);
        }
        parserErrors.clear();
    }


    @Override
    public Tree.CompilationUnit getLastCompilationUnit() {
        return lastCompilationUnit;
    }

    @Override
    public Tree.CompilationUnit getParsedRootNode() {
        return lastCompilationUnit;
    }

    @Override
    public Tree.CompilationUnit getTypecheckedRootNode() {
        return lastCompilationUnit;
    }

    @Override
    public PhasedUnit getLastPhasedUnit() {
        return lastPhasedUnit;
    }

    public Document getDocument() {
        return document;
    }

    @Override
    public List<CommonToken> getTokens() {
        return lastPhasedUnit.getTokens();
    }

    @Override
    public TypeChecker getTypeChecker() {
        return typeChecker;
    }

    @Override
    public CeylonProject<Project,String,String,String> getCeylonProject() {
        return null;
    }

    public Project getProject() {
        Project p = TopComponent.getRegistry().getActivated().getLookup().lookup(Project.class);
        if (p == null) {
            DataObject dob = TopComponent.getRegistry().getActivated().getLookup().lookup(DataObject.class);
            if (dob != null) {
                FileObject fo = dob.getPrimaryFile();
                p = FileOwnerQuery.getOwner(fo);
            }
        }
        return p;
    }

    @Override
    public CommonDocument getCommonDocument() {
        return null; //new NbDocument(document);
    }
}
