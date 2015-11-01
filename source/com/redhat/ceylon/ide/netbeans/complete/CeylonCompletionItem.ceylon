import ceylon.interop.java {
    javaString
}

import java.awt {
    Color,
    Font,
    Graphics,
    Image
}
import java.awt.event {
    KeyEvent
}
import java.lang {
    CharSequence
}

import javax.swing {
    ImageIcon
}
import javax.swing.text {
    BadLocationException,
    JTextComponent,
    StyledDocument
}

import org.netbeans.api.editor.completion {
    Completion
}
import org.netbeans.spi.editor.completion {
    CompletionItem,
    CompletionTask
}
import org.netbeans.spi.editor.completion.support {
    CompletionUtilities
}
import org.openide.util {
    Exceptions
}
import org.openide.xml {
    XMLUtil
}

shared object nbCompletionItemPosition {
    variable Integer counter = 0;
    
    shared void reset() {
        counter = 0;
    }
    
    shared Integer next() {
        counter--;
        return counter;
    }
}

shared class CeylonCompletionItem(String text, shared String desc, Integer dotOffset, String prefix, Image? icon = null)
        satisfies CompletionItem {
    
    Color fieldColor = Color.decode("0x0000B2");
    
    shared actual default void defaultAction(JTextComponent? jtc) {
        try {
            assert (exists jtc, is StyledDocument doc = jtc.document);
            doc.remove(dotOffset - prefix.size, prefix.size);
            doc.insertString(dotOffset - prefix.size, text, null);
            Completion.get().hideAll();
        } catch (BadLocationException ex) {
            Exceptions.printStackTrace(ex);
        }
    }
    
    shared actual void processKeyEvent(KeyEvent ke) {
    }
    
    shared actual Integer getPreferredWidth(Graphics graphics, Font font) {
        return CompletionUtilities.getPreferredWidth(escape(desc), null, graphics, font);
    }
    
    shared actual void render(Graphics g, Font defaultFont, Color defaultColor,
        Color backgroundColor, Integer width, Integer height, Boolean selected) {
        
        value image = if (exists icon) then ImageIcon(icon) else null;
        
        // TODO syntax highlight
        CompletionUtilities.renderHtml(image, escape(desc), null, g,
            defaultFont,
            (if (selected) then Color.white else fieldColor),
            width, height, selected);
    }
    
    shared default actual CompletionTask? createDocumentationTask() => null;
    
    shared actual CompletionTask? createToolTipTask() {
        return null;
    }
    
    shared actual Boolean instantSubstitution(JTextComponent jtc) {
        return false;
    }
    
    shared actual Integer sortPriority {
        return nbCompletionItemPosition.next();
    }
    
    shared actual CharSequence sortText {
        return javaString(text);
    }
    
    shared actual CharSequence insertPrefix {
        return javaString(text);
    }
    
    String escape(String text) => XMLUtil.toElementContent(text);
}
