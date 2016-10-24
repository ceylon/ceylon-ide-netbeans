import ceylon.interop.java {
	javaString
}

import com.redhat.ceylon.ide.netbeans.util {
	highlight
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
	CompletionItem
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

shared class CeylonCompletionItem(String text, String desc,
    Integer dotOffset, String prefix, Image? icon = null)
        satisfies CompletionItem {
    
    Color fieldColor = Color.decode("0x0000B2");
    
    shared actual default void defaultAction(JTextComponent jtc) {
        try {
            assert (is StyledDocument doc = jtc.document);
            doc.remove(dotOffset - prefix.size, prefix.size);
            doc.insertString(dotOffset - prefix.size, text, null);
            Completion.get().hideAll();
        } catch (BadLocationException ex) {
            Exceptions.printStackTrace(ex);
        }
    }
    
    processKeyEvent(KeyEvent ke) => noop();
    
    getPreferredWidth(Graphics graphics, Font font)
            => CompletionUtilities.getPreferredWidth(escape(desc), null, graphics, font);
    
    shared actual void render(Graphics g, Font defaultFont, Color defaultColor,
        Color backgroundColor, Integer width, Integer height, Boolean selected) {
        
        value image = if (exists icon) then ImageIcon(icon) else null;
        
        // TODO syntax highlight
        CompletionUtilities.renderHtml(image, 
            highlight(desc), null, g,
            defaultFont,
            (if (selected) then Color.white else fieldColor),
            width, height, selected);
    }
    
    createDocumentationTask() => null;
    
    createToolTipTask() => null;
    
    instantSubstitution(JTextComponent jtc) => false;
    
    sortPriority => nbCompletionItemPosition.next();
    
    sortText => javaString(text);
    
    insertPrefix => javaString(text);
    
    String escape(String text) => XMLUtil.toElementContent(text);
}
