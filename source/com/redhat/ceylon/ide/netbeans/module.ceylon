native("jvm")
module com.redhat.ceylon.ide.netbeans "current" {
    shared import java.base "7";
    shared import java.desktop "7";
    
    shared import org.eclipse.ceylon.ide.common "1.3.4-SNAPSHOT";
    shared import com.github.rjeschke.txtmark "0.13";
    
    // NetBeans dependencies
    shared import maven:"org.netbeans.api:org-netbeans-api-templates" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-api-progress" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-api-progress-nb" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-api-visual" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-core-multiview" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-libs-javacapi" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-modules-csl-api" "RELEASE81";
    //    shared import maven:"org.netbeans.api:org-netbeans-modules-csl-types" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-modules-editor" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-modules-editor-bracesmatching" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-modules-editor-completion" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-modules-editor-document" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-modules-editor-fold" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-modules-editor-indent" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-modules-editor-lib" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-modules-editor-lib2" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-modules-editor-mimelookup" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-modules-lexer" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-modules-parsing-api" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-modules-projectapi" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-modules-projectuiapi" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-modules-projectuiapi-base" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-modules-settings" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-spi-editor-hints" "RELEASE81";
    shared import maven:"org.netbeans.api:org-openide-dialogs" "RELEASE81";
    shared import maven:"org.netbeans.api:org-openide-awt" "RELEASE81";
    shared import maven:"org.netbeans.api:org-openide-loaders" "RELEASE81";
    shared import maven:"org.netbeans.api:org-openide-modules" "RELEASE81";
    shared import maven:"org.netbeans.api:org-openide-nodes" "RELEASE81";
    shared import maven:"org.netbeans.api:org-openide-text" "RELEASE81";
    shared import maven:"org.netbeans.api:org-openide-util" "RELEASE81";
    shared import maven:"org.netbeans.api:org-openide-util-lookup" "RELEASE81";
    shared import maven:"org.netbeans.api:org-openide-util-ui" "RELEASE81";
    shared import maven:"org.netbeans.api:org-openide-windows" "RELEASE81";
    shared import maven:"org.netbeans.api:org-openide-filesystems" "RELEASE81";
    shared import maven:"org.netbeans.api:org-openide-filesystems-compat8" "RELEASE81";
    shared import maven:"org.netbeans.api:org-openide-filesystems-nb" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-modules-java-platform" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-modules-java-project" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-modules-java-source" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-modules-java-source-base" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-modules-editor-settings" "RELEASE81";
    shared import maven:"org.netbeans.api:org-netbeans-api-java-classpath" "RELEASE81";
    
    // Friend modules (not API)
    shared import maven:"org.netbeans.external:nb-javac-impl" "RELEASE81";

	// Needed by LanguageRegistrationProcessor
    shared import maven:"org.netbeans.modules:org-netbeans-modules-editor-errorstripe" "RELEASE81";
}
