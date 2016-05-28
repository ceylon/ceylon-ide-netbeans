import com.redhat.ceylon.model.loader.mirror {
    MAnnotationMirror=AnnotationMirror
}
import javax.lang.model.element {
    JAnnotationMirror=AnnotationMirror
}

class AnnotationMirror(JAnnotationMirror ann) satisfies MAnnotationMirror {
    
    // TODO
    shared actual Object? getValue(String? string) => null;
    
    shared actual Object? \ivalue => null;
    
}