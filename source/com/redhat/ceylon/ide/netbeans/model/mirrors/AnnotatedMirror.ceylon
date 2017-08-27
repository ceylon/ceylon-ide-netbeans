import com.redhat.ceylon.model.loader.mirror {
	MAnnotatedMirror=AnnotatedMirror
}

import java.lang {
	JString=String,
	Types {
		nativeString
	}
}
import java.util {
	Set,
	HashSet
}

import javax.lang.model.element {
	Element
}

shared abstract class AnnotatedMirror(Element el) satisfies MAnnotatedMirror {
	
	getAnnotation(String string)
			=> if (exists ann = findAnnotation(el, string))
				then AnnotationMirror(ann)
				else null;

	shared actual Set<JString> annotationNames {
		value set = HashSet<JString>();
		
		for (mirr in el.annotationMirrors) {
			set.add(nativeString(mirr.annotationType.string));
		}
		
		return set;
	}
}
