import org.eclipse.ceylon.model.loader.mirror {
	FieldMirror
}

import javax.lang.model.element {
	VariableElement,
	Modifier
}

class FieldElementMirror(VariableElement el) 
		extends AnnotatedMirror(el)
		satisfies FieldMirror {
    
    defaultAccess
            => !public && !protected && !el.modifiers.contains(Modifier.private);
    
    final => el.modifiers.contains(Modifier.final);
    
    name => el.simpleName.string;
    
    protected => el.modifiers.contains(Modifier.protected);
    
    public => el.modifiers.contains(Modifier.public);
    
    static => el.modifiers.contains(Modifier.static);
    
    type => TypeMirror(el.asType());
}
