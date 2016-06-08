import ceylon.interop.java {
    javaString,
    javaClass
}

import com.redhat.ceylon.ide.common.doc {
    convertToHTML
}
import com.redhat.ceylon.ide.netbeans.lang {
    ceylonLanguageHierarchy,
    CeylonTokenId
}

import java.awt {
    Color
}
import java.lang {
    JInteger=Integer
}

import javax.swing.text {
    AttributeSet,
    StyleConstants
}

import org.netbeans.api.editor.mimelookup {
    MimeLookup
}
import org.netbeans.api.editor.settings {
    FontColorSettings
}
import org.netbeans.api.lexer {
    TokenHierarchy,
    Token
}

shared String highlight(String rawText) {
    value lang = ceylonLanguageHierarchy.language();
    value hierarchy = TokenHierarchy.create(javaString(rawText), lang);
    
    value ts = hierarchy.tokenSequence(lang);
    value sb = StringBuilder();
    value fcs = MimeLookup.getLookup(lang.mimeType())
            .lookup(javaClass<FontColorSettings>());
    
    while (ts.moveNext()) {
        sb.append(color(ts.token(), fcs));
    }
    
    return sb.string;
}

String color(Token<CeylonTokenId> token, FontColorSettings fcs) {
    value text = convertToHTML(token.text().string);
    AttributeSet? attributes = fcs.getTokenFontColors(token.id().name())
        else fcs.getTokenFontColors(token.id().primaryCategory());
    
    if (exists attributes,
        token.id().primaryCategory() != "whitespace") {
        
        assert(is Color color = attributes.getAttribute(StyleConstants.foreground));
        return "<font color='#``toHex(color)``'>``text``</font>";
    }

    return text;
}

String toHex(Color c) {
    value r = JInteger.toHexString(c.red);
    value g = JInteger.toHexString(c.green);
    value b = JInteger.toHexString(c.blue);
    
    return (if (r.size < 2) then "0" else "") + r
             + (if (g.size < 2) then "0" else "") + g
             + (if (b.size < 2) then "0" else "") + b;
}
