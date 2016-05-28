import com.redhat.ceylon.model.loader.mirror {
    MTypeMirror=TypeMirror,
    TypeParameterMirror,
    ClassMirror,
    TypeKind
}

import java.util {
    List,
    Collections
}

import javax.lang.model.type {
    JTypeMirror=TypeMirror
}

class TypeMirror(JTypeMirror type) satisfies MTypeMirror {
    
    shared actual MTypeMirror? componentType => null;
    
    shared actual ClassMirror? declaredClass => null;
    
    shared actual TypeKind? kind => null;
    
    shared actual MTypeMirror? lowerBound => null;
    
    primitive => type.kind.primitive;
    
    shared actual String qualifiedName => type.string; // TODO
    
    shared actual MTypeMirror? qualifyingType => null;
    
    shared actual Boolean raw => false;
    
    shared actual List<MTypeMirror> typeArguments
            => Collections.emptyList<MTypeMirror>();
    
    shared actual TypeParameterMirror? typeParameter => null;
    
    shared actual MTypeMirror? upperBound => null;
    
    
}