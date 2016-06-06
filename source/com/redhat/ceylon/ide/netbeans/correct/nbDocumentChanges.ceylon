import ceylon.collection {
    ArrayList
}
import ceylon.interop.java {
    JavaRunnable
}

import com.redhat.ceylon.ide.common.platform {
    CommonDocument,
    TextChange,
    TextEdit,
    DefaultDocument,
    DefaultCompositeChange
}

import java.io {
    OutputStreamWriter
}

import javax.swing.text {
    Document,
    BadLocationException,
    StyledDocument
}

import org.netbeans.modules.editor {
    NbEditorUtilities
}
import org.openide.filesystems {
    FileObject
}
import org.openide.text {
    DocumentUtil=NbDocument
}
import org.openide.util {
    Exceptions
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

shared class NbFileObjectDocument(shared FileObject fo)
        extends DefaultDocument(fo.asText()) {
    
}


shared class NbTextChange(document) satisfies TextChange {
    
    shared actual NbDocument|NbFileObjectDocument document;
    
    value edits = ArrayList<TextEdit>();
    
    shared actual void addEdit(TextEdit change) {
        edits.add(change);
    }
    
    shared actual void apply() {
        try {
            if (is NbDocument document) {
                value doc = document.nativeDocument;
                
                value markers = edits.collect(
                    (e) => doc.createPosition(e.start)
                );
                
                value run = () {
                    for (change -> marker in zipEntries(edits, markers)) {
                        doc.remove(marker.offset, change.length);
                        doc.insertString(marker.offset, change.text, null);
                    }
                };
                
                if (is StyledDocument doc) {
                    DocumentUtil.runAtomic(doc, JavaRunnable(run));
                } else {
                    run();
                }
            } else {
                Integer len = document.size;
                String text = document.getText(0, len);
                value newText = mergeToCharArray(text, len, edits);
                value os = OutputStreamWriter(document.fo.outputStream);
                os.write(newText);
                os.close();
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

shared class NbCompositeChange(String desc) extends DefaultCompositeChange(desc) {
    shared void apply() {
        changes.narrow<NbTextChange>().each((chg) => chg.apply());
    }
}
