import java.util {
    List,
    ArrayList
}
import javax.lang.model.element {
    JAnnotationMirror=AnnotationMirror,
    Element
}

List<Out> transform<In,Out>(List<out In> input, Out(In) transformer) {
    value result = ArrayList<Out>(input.size());
    
    for (i in input) {
        result.add(transformer(i));
    }
    
    return result;
}

JAnnotationMirror? findAnnotation(Element te, Annotations|String annotation) {
    value name = switch(annotation)
    case(is String) annotation
    else annotation.klazz.canonicalName;
    
    for (mirr in te.annotationMirrors) {
        if (mirr.annotationType.string == name) {
            return mirr;
        }
    }
    
    return null;
}
