import org.eclipse.ceylon.model.loader.mirror {
	MAnnotationMirror=AnnotationMirror
}

import java.lang {
	Types {
		nativeString
	}
}
import java.util {
	List,
	ArrayList
}

import javax.lang.model.element {
	JAnnotationMirror=AnnotationMirror,
	AnnotationValue,
	VariableElement
}
import javax.lang.model.type {
	JTypeMirror=TypeMirror
}

class AnnotationMirror(JAnnotationMirror ann) satisfies MAnnotationMirror {
    
    Anything convertValue(Anything val) {
        if (is VariableElement val) {
            return val.constantValue else nativeString(val.simpleName.string); 
        }
        if (is JAnnotationMirror val) {
            return AnnotationMirror(val);
        }
        if (is AnnotationValue val) {
            return val.\ivalue;
        }
        if (is JTypeMirror val) {
            return TypeMirror(val);
        }
        
        if (is List<out Anything> val) {
            value list = ArrayList<Anything>();
            
            for (o in val) {
                list.add(convertValue(o));
            }
            return list;
        }

        return val;
    }
    
    shared actual Object? getValue(String name) {
        for (entry in ann.elementValues.entrySet()) {
            if (entry.key.simpleName.string == name) {
                return convertValue(entry.\ivalue.\ivalue) else null;
            }
        }
        return null;
    }
    
    \ivalue => getValue("value");
    
}