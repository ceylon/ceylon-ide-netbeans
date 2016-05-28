import ceylon.collection {
    HashMap
}
import ceylon.interop.java {
    CeylonIterable
}

import com.redhat.ceylon.cmr.ceylon {
    CeylonUtils
}
import com.redhat.ceylon.common {
    Backend,
    Backends
}
import com.redhat.ceylon.compiler.typechecker {
    TypeChecker,
    TypeCheckerBuilder
}
import com.redhat.ceylon.compiler.typechecker.analyzer {
    ModuleSourceMapper
}
import com.redhat.ceylon.compiler.typechecker.context {
    PhasedUnit,
    Context
}
import com.redhat.ceylon.compiler.typechecker.util {
    ModuleManagerFactory
}
import com.redhat.ceylon.model.loader.model {
    LazyModule
}
import com.redhat.ceylon.model.typechecker.model {
    ModuleImport
}
import com.redhat.ceylon.model.typechecker.util {
    ModuleManager
}

import java.util {
    ArrayList
}

import org.netbeans.api.java.project {
    JavaProjectConstants
}
import org.netbeans.api.project {
    Project,
    ProjectUtils
}
import org.openide.filesystems {
    FileUtil
}

shared object ceylonBuilder {
    
    value typeCheckersByProject = HashMap<Project, TypeChecker>();

    TypeChecker initTypeChecker(Project project) {
        value builder = TypeCheckerBuilder();
        
        value repositoryManager = CeylonUtils.repoManager()
                .offline(true)
                .systemRepo("/Users/bastien/Dev/ceylon/ceylon/dist/dist/repo") // TODO
                .isJDKIncluded(true)
                .buildManager();
        
        builder.setRepositoryManager(repositoryManager);
        
        builder.moduleManagerFactory(object satisfies ModuleManagerFactory {
            shared actual ModuleManager createModuleManager(Context context) {
                // FIXME use a real LazyModuleManager to remove this hack
                return object extends ModuleManager() {
                    shared actual Backends supportedBackends {
                        return Backend.\iJava.asSet();
                    }
                    
                    shared actual void addImplicitImports() {
                        value languageModule = modules.languageModule;
                        for (m in CeylonIterable(modules.listOfModules)) {
                            // Java modules don't depend on ceylon.language
                            if ((!(m is LazyModule) || !m.java) && !m.equals(languageModule)) {
                                // add ceylon.language if required
                                if (!exists moduleImport = findImport(m, languageModule)) {
                                    m.addImport(ModuleImport(languageModule, false, true));
                                }
                            }
                        }
                    }
                };
            }
            
            shared actual ModuleSourceMapper createModuleManagerUtil(Context context, ModuleManager moduleManager) {
                return ModuleSourceMapper(context, moduleManager);
            }
        });
        
        value roots = ProjectUtils.getSources(project)
                .getSourceGroups(JavaProjectConstants.\iSOURCES_TYPE_JAVA);
        
        for (root in roots.iterable) {
            if (exists root) {
                builder.addSrcDirectory(FileUtil.toFile(root.rootFolder));
            }
        }
        
        TypeChecker tc = builder.typeChecker;
        tc.process();
        
        value phasedUnitsOfDependencies = ArrayList<PhasedUnit>();
        
        for (phasedUnits in CeylonIterable(tc.phasedUnitsOfDependencies)) {
            for (PhasedUnit pu in CeylonIterable(phasedUnits.phasedUnits)) {
                phasedUnitsOfDependencies.add(pu);
            }
        }
        
        for (pu in CeylonIterable(phasedUnitsOfDependencies)) {
            pu.scanDeclarations();
        }
        
        for (pu in CeylonIterable(phasedUnitsOfDependencies)) {
            pu.scanTypeDeclarations();
        }
        
        for (pu in CeylonIterable(phasedUnitsOfDependencies)) {
            pu.analyseTypes();
        }
        
        return tc;
    }
        
    shared TypeChecker getOrCreateTypeChecker(Project p) {
        if (!typeCheckersByProject.defines(p)) {
            typeCheckersByProject.put(p, initTypeChecker(p));
        }
        
        assert(exists tc = typeCheckersByProject.get(p));
        return tc;
    }
}