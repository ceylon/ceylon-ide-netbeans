import org.eclipse.ceylon.ide.common.model {
	unknownClassMirror
}
import org.eclipse.ceylon.model.loader.mirror {
	MTypeMirror=TypeMirror,
	MTypeKind=TypeKind
}

import java.util {
	Collections,
	Arrays
}

import javax.lang.model.element {
	TypeElement,
	TypeParameterElement
}
import javax.lang.model.type {
	JTypeMirror=TypeMirror,
	DeclaredType,
	ArrayType,
	WildcardType,
	TypeVariable
}

class TypeMirror(JTypeMirror type) satisfies MTypeMirror {
    
    componentType =>
        if (is ArrayType type) 
        then TypeMirror(type.componentType)
        else null;
    
    declaredClass =>
        if (is DeclaredType type,
            is TypeElement el = type.asElement())
        then TypeElementMirror(el)
        else unknownClassMirror;
    
    kind => MTypeKind.valueOf(type.kind.name());
    
    lowerBound =>
        if (is WildcardType type,
    		exists bound = type.superBound)
    	then TypeMirror(bound)
    	else null;
    
    primitive => type.kind.primitive;
    
    qualifiedName =>
        if (exists pos = type.string.firstOccurrence('<'))
        then type.string.spanTo(pos - 1)
        else type.string;
    
    shared actual MTypeMirror? qualifyingType => null; // TODO probably?
    
    shared actual Boolean raw => false; // TODO I think
    
    typeArguments =>
            if (is DeclaredType type)
    		then Arrays.asList<MTypeMirror>(
        		for (arg in type.typeArguments)
        		TypeMirror(arg)
    		)
    		else Collections.emptyList<MTypeMirror>();
    
    typeParameter => 
            if (is TypeVariable type,
    			is TypeParameterElement element = type.asElement())
    		then TypeParameterMirror(element)
    		else null;
    
    upperBound =>
        if (is WildcardType type,
    		exists bound = type.extendsBound)
    	then TypeMirror(bound)
    	else null;
}
