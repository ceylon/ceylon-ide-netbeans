import com.redhat.ceylon.model.loader.mirror {
    MTypeParameterMirror=TypeParameterMirror,
    MTypeMirror=TypeMirror
}

import javax.lang.model.element {
    TypeParameterElement
}
import javax.lang.model.type {
    JTypeMirror=TypeMirror
}

shared class TypeParameterMirror(TypeParameterElement tpe)
        satisfies MTypeParameterMirror {
    
    bounds => transform<JTypeMirror,MTypeMirror>(tpe.bounds, TypeMirror);
    
    name => tpe.simpleName.string;
    
}