import org.netbeans.spi.java.classpath {
    ClassPathImplementation,
    PathResourceImplementation
}
import java.util {
    List,
    Collections
}
import java.beans {
    PropertyChangeListener
}

shared class CeylonModulesClassPathImplementation()
         satisfies ClassPathImplementation {

    shared actual void addPropertyChangeListener(PropertyChangeListener? propertyChangeListener) {}
    
    shared actual void removePropertyChangeListener(PropertyChangeListener? propertyChangeListener) {}
    
    shared actual List<out PathResourceImplementation> resources {
        return Collections.emptyList<PathResourceImplementation>();
    }
}
