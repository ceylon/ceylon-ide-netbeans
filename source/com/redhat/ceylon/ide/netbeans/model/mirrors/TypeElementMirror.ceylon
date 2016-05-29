import com.redhat.ceylon.model.loader {
    AbstractModelLoader {
        getCacheKeyByModule
    }
}
import com.redhat.ceylon.model.loader.mirror {
    ClassMirror,
    MTypeParameterMirror=TypeParameterMirror,
    FieldMirror,
    PackageMirror,
    MTypeMirror=TypeMirror,
    MethodMirror,
    MAnnotationMirror=AnnotationMirror
}
import com.redhat.ceylon.model.typechecker.model {
    Module
}

import java.util {
    List,
    Collections
}

import javax.lang.model.element {
    TypeElement,
    Modifier,
    NestingKind,
    ElementKind,
    TypeParameterElement
}


shared class TypeElementMirror(shared TypeElement te) satisfies ClassMirror {
    
    variable String? cacheKey = null;

    abstract => te.modifiers.contains(Modifier.abstract);
    
    annotationType => te.kind == ElementKind.annotationType;
    
    anonymous => te.nestingKind == NestingKind.anonymous;
    
    function findAnnotation(Annotations|String annotation) {
        value name = switch(annotation)
        case(is String) annotation
        else annotation.klazz.canonicalName;
        
        for (mirr in te.annotationMirrors) {
            if (mirr.annotationType.string == name) {
                return mirr;
            }
        }
        
        return null;
    }

    ceylonToplevelAttribute
            => findAnnotation(Annotations.attribute) exists;
    
    ceylonToplevelMethod
            => findAnnotation(Annotations.method) exists;
    
    ceylonToplevelObject
            => findAnnotation(Annotations.\iobject) exists;
    
    defaultAccess => !(public || protected || te.modifiers.contains(Modifier.private));
    
    shared actual List<FieldMirror> directFields
            => Collections.emptyList<FieldMirror>();
    
    shared actual List<ClassMirror> directInnerClasses
            => Collections.emptyList<ClassMirror>();
    
    shared actual List<MethodMirror> directMethods
            => Collections.emptyList<MethodMirror>();
    
    shared actual ClassMirror? enclosingClass => null;
    
    shared actual MethodMirror? enclosingMethod => null;
    
    enum => te.kind == ElementKind.enum;
    
    final => te.modifiers.contains(Modifier.final);
    
    flatName => te.qualifiedName.string; // TODO not sure about this one
    
    shared actual MAnnotationMirror? getAnnotation(String string)
            => if (exists ann = findAnnotation(string))
                then AnnotationMirror(ann)
                else null;
    
    getCacheKey(Module mod)
            => cacheKey else (cacheKey = getCacheKeyByModule(mod, qualifiedName));
    
    innerClass => te.nestingKind == NestingKind.member;
    
    \iinterface => te.kind.\iinterface;
    
    shared actual List<MTypeMirror> interfaces
            => Collections.emptyList<MTypeMirror>();
    
    shared actual Boolean javaSource => false; // TODO
    
    shared actual Boolean loadedFromSource => false; // TODO

    localClass => te.nestingKind == NestingKind.local;
    
    name => te.simpleName.string;
    
    shared actual PackageMirror? \ipackage => null;
    
    protected => te.modifiers.contains(Modifier.protected);
    
    public => te.modifiers.contains(Modifier.public);
    
    qualifiedName => te.qualifiedName.string;
    
    static => te.modifiers.contains(Modifier.static);
    
    superclass => TypeMirror(te.superclass);
    
    typeParameters
             => transform<TypeParameterElement,MTypeParameterMirror>(te.typeParameters, TypeParameterMirror);
    
}