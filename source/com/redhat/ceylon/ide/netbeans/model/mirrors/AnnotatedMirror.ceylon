import com.redhat.ceylon.model.loader.mirror {
	MAnnotatedMirror=AnnotatedMirror,
	MAnnotationMirror=AnnotationMirror
}
import ceylon.interop.java {
	javaString
}
import java.util {
	Set,
	HashSet
}
import java.lang {
	JString=String
}
import javax.lang.model.element {
	Element
}

shared abstract class AnnotatedMirror(Element el) satisfies MAnnotatedMirror {
	
	shared actual MAnnotationMirror? getAnnotation(String string)
			=> if (exists ann = findAnnotation(el, string))
				then AnnotationMirror(ann)
				else null;

	shared actual Set<JString> annotationNames {
		value set = HashSet<JString>();
		
		for (mirr in el.annotationMirrors) {
			set.add(javaString(mirr.annotationType.string));
		}
		
		return set;
	}
}
