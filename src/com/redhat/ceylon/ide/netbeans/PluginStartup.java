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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
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
    private static final Pattern moduleArchivePattern = 
            Pattern.compile("(.+)-([^\\-]+)\\.(j|J|c|C)ar");

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

                    System.out.println(jarFile.getAbsolutePath());
                } catch (ReflectiveOperationException ex) {
                    // TODO look for JARs in platform/core and platform/lib
                    Logger.getLogger(getClass().getName()).warning(
                        "Can't get JAR file for module " + depName);
                }
            }
        }
    }

    private void registerCeylonModules() throws RuntimeException {
        File archiveDirectory = getDirectory("modules/ext");
        File embeddedDist = getDirectory("embeddedDist/repo");
        
        RepositoryManagerBuilder builder = new RepositoryManagerBuilder(
                archiveDirectory, new CMRJULLogger(), true,
                Constants.DEFAULT_TIMEOUT, Proxy.NO_PROXY);
        
        FileContentStore structureBuilder = new FileContentStore(archiveDirectory);
        builder.addRepository(new FlatRepository(structureBuilder.createRoot()));
        structureBuilder = new FileContentStore(embeddedDist);
        builder.addRepository(new DefaultRepository(structureBuilder.createRoot()));

        RepositoryManager repoManager = builder.buildRepository();

        for (File file : getArchives(archiveDirectory, embeddedDist)) {
            Matcher matcher = moduleArchivePattern.matcher(file.getName());
            
            if (matcher.matches()) {
                ArtifactContext ctx = new ArtifactContext(
                        matcher.group(1),
                        matcher.group(2),
                        matcher.group(3).equalsIgnoreCase("C") ?
                                ArtifactContext.CAR : ArtifactContext.JAR
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
