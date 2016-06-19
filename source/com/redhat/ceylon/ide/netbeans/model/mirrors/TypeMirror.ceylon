import com.redhat.ceylon.model.loader.mirror {
    MTypeMirror=TypeMirror,
    TypeParameterMirror,
    ClassMirror,
    MTypeKind=TypeKind
}

import java.util {
    List,
    Collections
}

import javax.lang.model.element {
    TypeElement
}
import javax.lang.model.type {
    JTypeMirror=TypeMirror,
    DeclaredType,
    ArrayType
}
import com.redhat.ceylon.ide.common.model {
    unknownClassMirror
}

class TypeMirror(JTypeMirror type) satisfies MTypeMirror {
    
    shared actual MTypeMirror? componentType {
        if (is ArrayType type) {
            return TypeMirror(type.componentType);
        }
        return null;
    }
    
    shared actual ClassMirror? declaredClass {
        if (is DeclaredType type,
            is TypeElement el = type.asElement()) {
            
            return TypeElementMirror(el);
        }
        return unknownClassMirror;
    }
    
    shared actual MTypeKind? kind => MTypeKind.valueOf(type.kind.name());
    
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
