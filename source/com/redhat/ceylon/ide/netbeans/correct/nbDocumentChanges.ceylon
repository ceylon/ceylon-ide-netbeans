import ceylon.collection {
    ArrayList
}

import com.redhat.ceylon.ide.common.correct {
    DocumentChanges
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
    NbDocument
}
import java.lang {
    Runnable
}

shared interface NbDocumentChanges satisfies DocumentChanges<Document,InsertEdit,TextEdit,TextChange> {
    
    shared actual void addEditToChange(TextChange tc, TextEdit te) {
        tc.addChange(te);
    }
    
    shared actual Document getDocumentForChange(TextChange tc) {
        return tc.document;
    }
    
    shared actual String getInsertedText(InsertEdit ie) {
        return ie.text;
    }
    
    shared actual void initMultiEditChange(TextChange tc) {
        // nothing
    }
    
    shared actual TextEdit newDeleteEdit(Integer start, Integer len) {
        return DeleteEdit(start, len);
    }
    
    shared actual InsertEdit newInsertEdit(Integer position, String string) {
        return InsertEdit(position, string);
    }
    
    shared actual TextEdit newReplaceEdit(Integer position, Integer length, String string) {
        return ReplaceEdit(position, length, string);
    }
}

shared class TextChange(shared Document document) {
    
    value changes = ArrayList<TextEdit>();
    
    shared void addChange(TextEdit change) {
        changes.add(change);
    }
    
    shared void applyChanges() {
        try {
            Integer len = document.length;
            String text = document.getText(0, len);
            value newText = mergeToCharArray(text, len, changes);

            if (is StyledDocument document) {
                // TODO the editor scrolls down when we do this, and the cursor is at the end of the doc
                NbDocument.runAtomic(document, object satisfies Runnable {
                    shared actual void run() {
                        document.remove(0, len);
                        document.insertString(0, newText, null);
                    }
                });
            } else { 
                document.remove(0, len);
                document.insertString(0, newText, null);
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
}

shared interface TextEdit {
    shared formal Integer start;
    shared formal Integer end;
    shared formal String text;
}

shared class InsertEdit(Integer position, shared actual String text) satisfies TextEdit {
    shared actual Integer start => position;
    shared actual Integer end => position;
}

shared class DeleteEdit(shared actual Integer start, Integer length) satisfies TextEdit {
    shared actual Integer end => start + length;
    shared actual String text => "";
}

shared class ReplaceEdit(shared actual Integer start, Integer length, shared actual String text) satisfies TextEdit {
    shared actual Integer end => start + length;
}
