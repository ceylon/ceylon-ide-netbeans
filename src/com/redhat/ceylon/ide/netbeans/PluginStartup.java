package com.redhat.ceylon.ide.netbeans;

import com.redhat.ceylon.cmr.api.ArtifactContext;
import com.redhat.ceylon.cmr.api.RepositoryManager;
import com.redhat.ceylon.cmr.api.RepositoryManagerBuilder;
import com.redhat.ceylon.cmr.impl.CMRJULLogger;
import com.redhat.ceylon.cmr.impl.DefaultRepository;
import com.redhat.ceylon.cmr.impl.FileContentStore;
import com.redhat.ceylon.cmr.impl.FlatRepository;
import com.redhat.ceylon.common.Constants;
import com.redhat.ceylon.compiler.java.runtime.metamodel.Metamodel;
import com.redhat.ceylon.model.cmr.ArtifactResult;
import com.redhat.ceylon.model.cmr.ArtifactResultType;
import com.redhat.ceylon.model.cmr.Exclusion;
import com.redhat.ceylon.model.cmr.ModuleScope;
import com.redhat.ceylon.model.cmr.PathFilter;
import com.redhat.ceylon.model.cmr.Repository;
import com.redhat.ceylon.model.cmr.VisibilityType;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Method;
import java.math.BigInteger;
import java.net.Proxy;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Logger;
import java.util.regex.Pattern;
import org.openide.modules.Dependency;
import org.openide.modules.InstalledFileLocator;
import org.openide.modules.ModuleInfo;
import org.openide.modules.Modules;
import org.openide.modules.OnStart;
import org.openide.util.Exceptions;
import org.openide.util.Lookup;

@OnStart
public class PluginStartup implements Runnable {
    private static final Pattern moduleArchivePatternCar 
            = Pattern.compile("([^\\-]+)-(.+)\\.(c|C)ar");
    private static final Pattern moduleArchivePatternJar 
            = Pattern.compile("(.+)-([^\\-]+)\\.(j|J)ar");

    private static final Map<String, String> registeredModules = new HashMap<>();

    private static final String MODULE_NAME = "com.redhat.ceylon.ide.netbeans";

    private final FilenameFilter archivesFilter = new FilenameFilter() {
        @Override
        public boolean accept(File dir, String name) {
            return name.endsWith(".car") || name.endsWith(".jar");
        }
    };
    
    private final FileFilter directoryFilter = new FileFilter() {
        @Override
        public boolean accept(File pathname) {
            return pathname.isDirectory();
        }
    };

    @Override
    public void run() {
        registerCeylonModules();
        registerNetbeansModules();
    }

    private void registerNetbeansModules() {
        final Modules modules = Lookup.getDefault().lookup(Modules.class);
        ModuleInfo mod = modules.findCodeNameBase(MODULE_NAME);
        final Set<Dependency> deps = mod.getDependencies();
        
        for (Dependency dep : deps) {
            String depName = dep.getName();
            int slash = depName.indexOf('/');
            if (slash > 0) {
                depName = depName.substring(0, slash);
            }
            
            ModuleInfo depInfo = modules.findCodeNameBase(depName);

            if (depInfo == null) {
                Logger.getLogger(getClass().getName()).warning(
                        "Can't find dependency info for module " + depName);
            } else {
                try {
                    Method meth = depInfo.getClass().getDeclaredMethod("getJarFile");
                    meth.setAccessible(true);
                    File jarFile = (File) meth.invoke(depInfo);

                    registerNetbeansModule(jarFile, depName.replaceAll("-", "."));
                } catch (ReflectiveOperationException ex) {
                    // TODO look for JARs in platform/core and platform/lib
                    Logger.getLogger(getClass().getName()).warning(
                        "Can't get JAR file for module " + depName);
                }
            }
        }
    }

    private void registerNetbeansModule(final File jar, final String moduleName) {
        ArtifactResult artifactResult = new ArtifactResult() {
            @Override
            public String name() {
                return moduleName;
            }

            @Override
            public String version() {
                return "current";
            }

            @Override
            public ArtifactResultType type() {
                return ArtifactResultType.CEYLON;
            }

            @Override
            public VisibilityType visibilityType() {
                return VisibilityType.STRICT;
            }

            @Override
            public File artifact() {
                return jar;
            }

            @Override
            public PathFilter filter() {
                return null;
            }

            @Override
            public List<ArtifactResult> dependencies() {
                return Collections.emptyList();
            }

            @Override
            public String repositoryDisplayString() {
                return null;
            }

            @Override
            public Repository repository() {
                return null;
            }

            @Override
            public String namespace() {
                return null;
            }

            @Override
            public boolean optional() {
                return false;
            }

            @Override
            public boolean exported() {
                return false;
            }

            @Override
            public ModuleScope moduleScope() {
                return null;
            }

            @Override
            public List<Exclusion> getExclusions() {
                return Collections.emptyList();
            }

            @Override
            public String groupId() {
                return null;
            }

            @Override
            public String artifactId() {
                return moduleName;
            }

            @Override
            public String classifier() {
                return null;
            }
        };
        
        registerModule(artifactResult, getClass().getClassLoader());
    }

    private void registerCeylonModules() throws RuntimeException {
        File archiveDirectory = getDirectory("ceylon/embeddedRepo");
        File embeddedDist = getDirectory("ceylon/embeddedDist/repo");
        
        Logger.getLogger("PluginStartup").info("Scanning archives in " 
        		+ archiveDirectory + " and " + embeddedDist);
        RepositoryManagerBuilder builder = new RepositoryManagerBuilder(
                archiveDirectory, new CMRJULLogger(), true,
                Constants.DEFAULT_TIMEOUT, Proxy.NO_PROXY);
        
        FileContentStore structureBuilder = new FileContentStore(archiveDirectory);
        builder.addRepository(new FlatRepository(structureBuilder.createRoot()));
        structureBuilder = new FileContentStore(embeddedDist);
        builder.addRepository(new DefaultRepository(structureBuilder.createRoot()));

        RepositoryManager repoManager = builder.buildRepository();

        for (File file : getArchives(archiveDirectory, embeddedDist)) {
            File dir = file.getParentFile();
            String name = file.getName();
            String moduleName;
            String moduleVersion;
            String moduleType;

            if (name.endsWith(".car") || name.endsWith(".jar")){
                // Use the repo layout to determine name and version
                moduleVersion = dir.getName();
                int versionPos = name.indexOf(moduleVersion);
                moduleName = name.substring(0, versionPos - 1);
                moduleType = name.endsWith(".car") ?
                        ArtifactContext.CAR : ArtifactContext.JAR;
            } else {
                continue;
            }

            ArtifactContext ctx = new ArtifactContext(
                    null,
                    moduleName,
                    moduleVersion,
                    moduleType
            );
            ArtifactResult result = repoManager.getArtifactResult(ctx);

            if (result == null) {
                throw new RuntimeException("Ceylon Metamodel Registering failed : module '"
                        + ctx.getName() + "' could not be registered.");
            } else {
                registerModule(result, getClass().getClassLoader());
            }
        }
    }

    private List<File> getArchives(File archiveDirectory, File embeddedDist) {
        List<File> archives = new ArrayList<>();
        
        visitDirectory(archiveDirectory, archives);
        visitDirectory(embeddedDist, archives);
        
        return archives;
    }
    
    private void visitDirectory(File directory, List<File> archives) {
        archives.addAll(Arrays.asList(directory.listFiles(archivesFilter)));
        
        for (File subdir : directory.listFiles(directoryFilter)) {
            visitDirectory(subdir, archives);
        }
    }
    
    private void registerModule(ArtifactResult moduleArtifact, ClassLoader classLoader) {
        String artifactFileName = moduleArtifact.artifact().getName();
        String artifactMD5 = "";
        try {
            artifactMD5 = generateBufferedHash(moduleArtifact.artifact());
        } catch (NoSuchAlgorithmException | IOException e) {
            Exceptions.printStackTrace(e);
        }

        String alreadyRegisteredModuleMD5 = registeredModules.get(artifactFileName);
        if (alreadyRegisteredModuleMD5 == null) {
            Metamodel.loadModule(moduleArtifact.name(), moduleArtifact.version(), moduleArtifact, classLoader);
            registeredModules.put(artifactFileName, artifactMD5);
        } else if (alreadyRegisteredModuleMD5.isEmpty() ||
                !alreadyRegisteredModuleMD5.equals(artifactMD5)) {
            throw new RuntimeException("Ceylon Metamodel Registering failed : the module '" +
                    moduleArtifact.name() + "/" + moduleArtifact.version() +
                    "' cannot be registered since it has already been registered " +
                    "by another plugin with a different binary archive");
        }
        // In other cases, we don't need to register again
    }
        
    
    private String generateBufferedHash(File file)
            throws NoSuchAlgorithmException,
            IOException {

        MessageDigest md = MessageDigest.getInstance("MD5");

        InputStream is = new FileInputStream(file);

        byte[] buffer = new byte[8192];
        int read;

        while ((read = is.read(buffer)) > 0)
            md.update(buffer, 0, read);

        byte[] md5 = md.digest();
        BigInteger bi = new BigInteger(1, md5);

        return bi.toString(16);
    }

    private File getDirectory(String name) {
        File dir = InstalledFileLocator.getDefault().locate(
                name, MODULE_NAME, false);
        
        if (dir == null || !dir.exists() || !dir.isDirectory()) {
            throw new RuntimeException("Could not find installed directory "
                + name);
        }
        
        return dir;
    }
}
