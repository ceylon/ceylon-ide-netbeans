import ceylon.interop.java {
    CeylonIterable
}

import com.github.rjeschke.txtmark {
    BlockEmitter
}

import java.lang {
    StringBuilder,
    JString=String
}
import java.util {
    List
}
import com.redhat.ceylon.ide.netbeans.util {
    highlight
}
class CeylonBlockEmitter() satisfies BlockEmitter {
    
    shared actual void emitBlock(StringBuilder builder, List<JString> lines, String? meta) {
        if (!lines.empty) {
            builder.append("<div style='margin: 5px'><pre>");
            
            value code = "\n".join(CeylonIterable(lines)) + "\n";
            
            if (exists meta, (meta.empty || "ceylon".equals(meta))) {
                builder.append("<code>``highlight(code.string)``</code>"); // TODO
            } else {
                builder.append(code.string);
            }
            
            builder.append("</pre></div>\n");
        }
    }
}
