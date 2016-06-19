import com.redhat.ceylon.model.loader.mirror {
    FieldMirror,
    MAnnotationMirror=AnnotationMirror
}
import javax.lang.model.element {
    VariableElement,
    Modifier
}

class FieldElementMirror(VariableElement el) satisfies FieldMirror {
    
    defaultAccess
            => !public && !protected && !el.modifiers.contains(Modifier.private);
    
    final => el.modifiers.contains(Modifier.final);
    
    shared actual MAnnotationMirror? getAnnotation(String string)
            => if (exists ann = findAnnotation(el, string))
               then AnnotationMirror(ann)
               else null;
    
    name => el.simpleName.string;
    
    protected => el.modifiers.contains(Modifier.protected);
    
    public => el.modifiers.contains(Modifier.public);
    
    static => el.modifiers.contains(Modifier.static);
    
    type => TypeMirror(el.asType());
}
