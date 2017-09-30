import org.eclipse.ceylon.model.loader.mirror {
    PackageMirror
}
import javax.lang.model.element {
    PackageElement
}

class PackageElementMirror(PackageElement pkg) satisfies PackageMirror {
    qualifiedName => pkg.qualifiedName.string;
}
