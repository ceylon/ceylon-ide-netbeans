import com.redhat.ceylon.model.loader.mirror {
    VariableMirror,
    MAnnotationMirror=AnnotationMirror
}
import javax.lang.model.element {
    VariableElement
}

class VariableElementMirror(VariableElement el) satisfies VariableMirror {
    
    shared actual MAnnotationMirror? getAnnotation(String string)
            => if (exists ann = findAnnotation(el, string))
               then AnnotationMirror(ann)
               else null;
    
    name => el.simpleName.string;
    
    type => TypeMirror(el.asType());
    
}
