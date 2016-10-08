import ceylon.collection {
    HashMap
}
import ceylon.interop.java {
    javaClass
}

import com.redhat.ceylon.compiler.typechecker.tree {
    Tree
}
import com.redhat.ceylon.ide.netbeans.model {
    CeylonParseController
}
import com.redhat.ceylon.model.typechecker.model {
    ModelUtil,
    NothingType,
    Class,
    Value,
    Declaration,
    Function,
    TypeParameter,
    Interface,
    TypeAlias
}

import java.awt {
    Toolkit,
    Image
}
import com.redhat.ceylon.ide.common.doc {
    Icons
}

shared object nbIcons {
    
    value paths = HashMap<Image, String>();

    Image loadIcon(String path) {
        value res = javaClass<CeylonParseController>().classLoader.getResource(path);
        value image = Toolkit.defaultToolkit.getImage(res);
        
        // TODO we should only do this on hidpi screens
        value fullPath = res.string.replace(".png", "@2x.png");
        
        paths.put(image, fullPath);
        return image;
    }

    shared Image ceylonFile => loadIcon("icons/ceylonFile.png");
    shared Image modules => loadIcon("icons/descriptor.png");
    shared Image packages => loadIcon("icons/packageDescriptor.png");
    
    shared Image classes => loadIcon("icons/class.png");
    shared Image interfaces => loadIcon("icons/interface.png");
    shared Image objects => loadIcon("icons/anonymousClass.png");
    shared Image methods => loadIcon("icons/method.png");
    shared Image attributes = loadIcon("icons/field.png");

    shared Image annotations => loadIcon("icons/annotationtype.png");
    shared Image enumerations => loadIcon("icons/enum.png");
    shared Image overrides => loadIcon("icons/overridingMethod.png");
    shared Image implements => loadIcon("icons/implementingMethod.png");
    shared Image exceptions => loadIcon("icons/exceptionClass.png");
    shared Image returns => loadIcon("icons/stepOut.png");
    shared Image param => loadIcon("icons/parameter.png");
    shared Image local => loadIcon("icons/ceylonLocal.png");
    shared Image values => loadIcon("icons/variable.png");
    shared Image anonymousFunction => loadIcon("icons/function.png");
    shared Image types => loadIcon("icons/ceylonTypes.png");
    shared Image correct => loadIcon("icons/redo.png");

    shared Image error => loadIcon("icons/error.png");
    shared Image warning => loadIcon("icons/warning.png");
    shared Image info => loadIcon("icons/information.png");

    shared Image? forDeclaration(Tree.Declaration|Declaration decl) {
        return switch (decl)
            case (is Tree.AnyClass)
                classes
            case (is Class)
                if (decl.anonymous) then objects else classes
            case (is Tree.AnyInterface|Interface)
                interfaces
            case (is Tree.AnyMethod|Function)
                methods
            case (is Tree.ObjectDefinition)
                objects
            case (is Value)
                if (ModelUtil.isObject(decl)) then objects else values
            case (is TypeAlias|NothingType)
                types
            case (is TypeParameter)
                param // TODO wrong!
            case (is Tree.AttributeDeclaration)
                values
            else
                null;
    }
    
    shared Image? forCommonIcon(Icons icon) {
        return switch(icon)
        case (Icons.annotations) annotations
        case (Icons.modules) modules
        case (Icons.packages) packages
        case (Icons.objects) objects
        case (Icons.classes) classes
        case (Icons.enumeration) enumerations
        case (Icons.exceptions) exceptions
        case (Icons.parameters) param
        case (Icons.types) null
        case (Icons.attributes) attributes
        case (Icons.interfaces) interfaces
        else null;
    }

    
    shared String getPath(Image img) {
        return paths.get(img) else "<err>";
    }
}
