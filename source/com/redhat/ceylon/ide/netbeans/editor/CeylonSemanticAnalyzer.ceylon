import org.eclipse.ceylon.compiler.typechecker.tree {
	VisitorAdaptor,
	Tree
}
import com.redhat.ceylon.ide.netbeans.lang {
	NBCeylonParser
}

import java.util {
	Set,
	HashMap,
	Collections {
		singleton
	}
}

import org.netbeans.modules.csl.api {
	SemanticAnalyzer,
	ColoringAttributes,
	OffsetRange
}
import org.netbeans.modules.parsing.spi {
	SchedulerEvent,
	Scheduler
}

"Provides additional syntax highlights based on the parser result (for annotations, ...)"
shared class CeylonSemanticAnalyzer()
        extends SemanticAnalyzer<NBCeylonParser.CeylonParserResult>() {
    
    cancel() => noop();
    
    highlights = HashMap<OffsetRange, Set<ColoringAttributes>>();
    
    priority => 1;
    
    shared actual void run(NBCeylonParser.CeylonParserResult res, SchedulerEvent schedulerEvent) {
        highlights.clear();
        
        object extends VisitorAdaptor() {
            shared actual void visitAnnotation(Tree.Annotation annotation) {
                super.visitAnnotation(annotation);
                
                if (exists name = annotation.primary) {
                    value start = name.startIndex.intValue();
                    value end = name.endIndex.intValue();
                    value range = OffsetRange(start, end);
                    highlights.put(range, singleton(ColoringAttributes.annotationType));
                }
            }
            
            shared actual void visitImportPath(Tree.ImportPath path) {
                super.visitImportPath(path);
                
                if (exists startIndex = path.startIndex,
                	exists endIndex = path.endIndex) {
	                value start = startIndex.intValue();
	                value end = endIndex.intValue();
	                value range = OffsetRange(start, end);
	                highlights.put(range, singleton(ColoringAttributes.custom1));
	            }
            }

            shared actual void visitQualifiedMemberExpression(
                Tree.QualifiedMemberExpression qme) {
                
                super.visitQualifiedMemberExpression(qme);
                
                if (exists p = qme.identifier) {
                    value start = p.startIndex.intValue();
                    value end = p.endIndex.intValue();
                    value range = OffsetRange(start, end);
                    highlights.put(range, singleton(ColoringAttributes.custom2));
                }
            }
        }.visitCompilationUnit(res.rootNode);

    }
    
    schedulerClass
            => Scheduler.editorSensitiveTaskScheduler;
}
