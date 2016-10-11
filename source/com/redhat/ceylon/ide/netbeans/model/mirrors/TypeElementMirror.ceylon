import com.redhat.ceylon.ide.common.model.mirror {
	IdeClassMirror
}
import com.redhat.ceylon.model.loader {
	AbstractModelLoader {
		getCacheKeyByModule
	}
}
import com.redhat.ceylon.model.loader.mirror {
	ClassMirror,
	MTypeParameterMirror=TypeParameterMirror,
	FieldMirror,
	MTypeMirror=TypeMirror,
	MethodMirror
}
import com.redhat.ceylon.model.typechecker.model {
	Module
}
import com.sun.tools.javac.code {
	Symbol
}

import java.util {
	List,
	ArrayList
}

import javax.lang.model.element {
	TypeElement,
	Modifier,
	NestingKind,
	ElementKind,
	TypeParameterElement,
	PackageElement,
	Element,
	ExecutableElement,
	VariableElement
}
import javax.lang.model.type {
	JTypeMirror=TypeMirror
}

shared class TypeElementMirror(shared TypeElement te,
							   ClassMirror? forcedEnclosingClass = null,
                               enclosingMethod = null)
		extends AnnotatedMirror(te)
        satisfies IdeClassMirror {
    
    variable String? cacheKey = null;

    abstract => te.modifiers.contains(Modifier.abstract);
    
    annotationType => te.kind == ElementKind.annotationType;
    
    anonymous => te.nestingKind == NestingKind.anonymous;
    
    ceylonToplevelAttribute
            => findAnnotation(te, Annotations.attribute) exists;
    
    ceylonToplevelMethod
            => findAnnotation(te, Annotations.method) exists;
    
    ceylonToplevelObject
            => findAnnotation(te, Annotations.\iobject) exists;
    
    defaultAccess => !(public || protected || te.modifiers.contains(Modifier.private));
    
    shared actual List<FieldMirror> directFields {
        value mirrors = ArrayList<FieldMirror>();
        
        for (el in te.enclosedElements) {
            if (el.kind.field, is VariableElement el) {
                mirrors.add(FieldElementMirror(el));
            }
        }
        
        return mirrors;
    }
    
    shared actual List<ClassMirror> directInnerClasses {
        value mirrors = ArrayList<ClassMirror>();
        
        for (el in te.enclosedElements) {
            if (el.kind in [ElementKind.\iCLASS, ElementKind.\iINTERFACE],
                is TypeElement el) {
                
                mirrors.add(TypeElementMirror(el, this));
            }
        }
        
        return mirrors;
    }
    
    shared actual List<MethodMirror> directMethods {
        value mirrors = ArrayList<MethodMirror>();
        
        for (el in te.enclosedElements) {
            if (el.kind in [ElementKind.method, ElementKind.constructor, ElementKind.staticInit],
                is ExecutableElement el) {
                
                mirrors.add(ExecutableElementMirror(el, this));
            }
        }
        
        return mirrors;
    }
    
    enclosingClass 
            => forcedEnclosingClass 
    			else (if (is TypeElement parent = te.enclosingElement)
    			then TypeElementMirror(parent)
    			else null);
    
    shared actual MethodMirror? enclosingMethod;
    
    enum => te.kind == ElementKind.enum;
    
    final => te.modifiers.contains(Modifier.final);
    
    flatName => te.qualifiedName.string; // TODO not sure about this one
    
    getCacheKey(Module mod)
            => cacheKey else (cacheKey = getCacheKeyByModule(mod, qualifiedName));
    
    innerClass => te.nestingKind == NestingKind.member;
    
    \iinterface => te.kind.\iinterface;
    
    interfaces
            => transform<JTypeMirror, MTypeMirror>(te.interfaces, TypeMirror);
    
    shared actual Boolean javaSource => false; // TODO
    
    shared actual Boolean loadedFromSource => false; // TODO

    localClass => te.nestingKind == NestingKind.local;
    
    name => te.simpleName.string;
    
    function findPackage() {
        variable Element el = te.enclosingElement;
        
        while (!is PackageElement? candidate = el) {
            el = el.enclosingElement;
        }
        
        if (is PackageElement pkg = el) {
            return pkg;
        }
        throw Exception("Couldn't find package of type " + qualifiedName);
    }
    
    \ipackage => PackageElementMirror(findPackage());
    
    protected => te.modifiers.contains(Modifier.protected);
    
    public => te.modifiers.contains(Modifier.public);
    
    qualifiedName => te.qualifiedName.string;
    
    static => te.modifiers.contains(Modifier.static);
    
    superclass => TypeMirror(te.superclass);
    
    typeParameters
             => transform<TypeParameterElement,MTypeParameterMirror>(te.typeParameters, TypeParameterMirror);

    fileName => if (is Symbol.ClassSymbol te) then te.classfile.name else "unknown";
    
    fullPath => if (is Symbol.ClassSymbol te) 
    	then te.classfile.toUri().string.removeInitial("jar:file:")
    	else "unknown";
    
    isBinary => true;
    
    isCeylon => findAnnotation(te, Annotations.ceylon) exists;
}
