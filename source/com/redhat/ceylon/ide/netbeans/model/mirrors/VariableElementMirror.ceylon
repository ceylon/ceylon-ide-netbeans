import com.redhat.ceylon.model.loader.mirror {
	VariableMirror
}

import javax.lang.model.element {
	VariableElement
}

class VariableElementMirror(VariableElement el)
		extends AnnotatedMirror(el)
		satisfies VariableMirror {
    
    name => el.simpleName.string;
    
    type => TypeMirror(el.asType());
    
}
