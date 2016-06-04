import ceylon.collection {
    ArrayList
}

import com.redhat.ceylon.ide.common.platform {
    CommonDocument,
    TextChange,
    TextEdit
}

import java.lang {
    Runnable
}

import javax.swing.text {
    Document,
    BadLocationException,
    StyledDocument
}

import org.openide.util {
    Exceptions
}
import org.openide.text {
    DocumentUtil=NbDocument
}
import org.netbeans.modules.editor {
    NbEditorUtilities
}

shared class NbDocument(nativeDocument) satisfies CommonDocument {
    shared Document nativeDocument;

    defaultLineDelimiter => "\n";
    
    shared actual Integer getLineEndOffset(Integer line) {
        value start = getLineStartOffset(line);
        return nativeDocument.defaultRootElement.getElement(
            nativeDocument.defaultRootElement.getElementIndex(start)
        ).endOffset;
    }
    
    getLineOfOffset(Integer offset)
            => NbEditorUtilities.getLine(nativeDocument, offset, false).lineNumber;
    
    shared actual Integer getLineStartOffset(Integer line) {
        assert(is StyledDocument nativeDocument);
        return DocumentUtil.findLineOffset(nativeDocument, line);
    }
    
    getText(Integer offset, Integer length)
            => nativeDocument.getText(offset, length);
    
    size => nativeDocument.length;
    
}


shared class NbTextChange(shared actual NbDocument document) satisfies TextChange {
    
    value edits = ArrayList<TextEdit>();
    
    shared actual void addEdit(TextEdit change) {
        edits.add(change);
    }
    
    shared actual void apply() {
        try {
            Integer len = document.size;
            String text = document.getText(0, len);
            value newText = mergeToCharArray(text, len, edits);

            if (is StyledDocument document) {
                // TODO the editor scrolls down when we do this, and the cursor is at the end of the doc
                DocumentUtil.runAtomic(document, object satisfies Runnable {
                    shared actual void run() {
                        document.remove(0, len);
                        document.insertString(0, newText, null);
                    }
                });
            } else { 
                document.nativeDocument.remove(0, len);
                document.nativeDocument.insertString(0, newText, null);
            }
        } catch (BadLocationException ex) {
            Exceptions.printStackTrace(ex);
        }
    }
    
    String mergeToCharArray(String text, Integer textLength, List<TextEdit> changes) {
        variable Integer newLength = textLength;
        for (change in changes) {
            newLength += change.text.size - (change.end - change.start);
        }
        value data = Array<Character>.ofSize(newLength, ' ');
        variable Integer oldEndOffset = textLength;
        variable Integer newEndOffset = data.size;
        variable Integer i = changes.size - 1;
        while (i >= 0) {
            assert(exists change = changes.get(i));
            Integer symbolsToMoveNumber = oldEndOffset - change.end;
            text.copyTo(data, change.end, newEndOffset - symbolsToMoveNumber, symbolsToMoveNumber);
            newEndOffset -= symbolsToMoveNumber;
            String changeSymbols = change.text;
            newEndOffset -= changeSymbols.size;
            changeSymbols.copyTo(data, 0, newEndOffset, changeSymbols.size);
            oldEndOffset = change.start;
            i--;
        }
        
        if (oldEndOffset > 0) {
            text.copyTo(data, 0, 0, oldEndOffset);
        }
        return String(data);
    }
    
    hasEdits => edits.size > 0;
    
    initMultiEdit() => noop();
    
    length => if (exists e = edits.first) then e.length else 0;
    
    offset => if (exists e = edits.first) then e.start else 0;
    
}
