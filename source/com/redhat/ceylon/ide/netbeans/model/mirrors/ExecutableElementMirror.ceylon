import com.redhat.ceylon.model.loader.mirror {
    MethodMirror,
    MTypeParameterMirror=TypeParameterMirror,
    ClassMirror,
    VariableMirror,
    MAnnotationMirror=AnnotationMirror
}

import javax.lang.model.element {
    ExecutableElement,
    Modifier,
    ElementKind,
    TypeParameterElement,
    VariableElement
}
import javax.lang.model.type {
    NoType,
    TypeKind
}

class ExecutableElementMirror(ExecutableElement el, enclosingClass) satisfies MethodMirror {

    shared actual ClassMirror enclosingClass;
    
    abstract => el.modifiers.contains(Modifier.abstract);
    
    constructor => el.kind == ElementKind.constructor;
    
    declaredVoid => if (is NoType t = el.returnType, t.kind == TypeKind.\ivoid)
                    then true else false;
    
    default => false; // TODO
    
    defaultAccess 
            => !public && !protected && !el.modifiers.contains(Modifier.private);
    
    defaultMethod => el.default;
    
    final => el.modifiers.contains(Modifier.final);
    
    shared actual MAnnotationMirror? getAnnotation(String string)
            => if (exists ann = findAnnotation(el, string))
               then AnnotationMirror(ann)
               else null;
    
    name => el.simpleName.string;
    
    parameters
            => transform<VariableElement,VariableMirror>(el.parameters, VariableElementMirror);
    
    protected => el.modifiers.contains(Modifier.protected);
    
    public => el.modifiers.contains(Modifier.public);
    
    returnType => TypeMirror(el.returnType);
    
    static => el.modifiers.contains(Modifier.static);
    
    staticInit => el.kind == ElementKind.staticInit;
    
    typeParameters 
            => transform<TypeParameterElement,MTypeParameterMirror>(el.typeParameters, TypeParameterMirror);
    
    variadic => el.varArgs;
}
