import com.redhat.ceylon.compiler.typechecker.context {
    PhasedUnit
}
import com.redhat.ceylon.ide.common.platform {
    DocumentServices,
    CompositeChange,
    TextChange,
    CommonDocument
}

object nbDocumentServices satisfies DocumentServices {
    
    shared actual CompositeChange createCompositeChange(String name) => nothing;
    
    shared actual TextChange createTextChange(String name, CommonDocument|PhasedUnit input)
            => /* NbTextChange(input) TODO */ nothing;
    
    indentSpaces => 4;
    
    indentWithSpaces => true;
}