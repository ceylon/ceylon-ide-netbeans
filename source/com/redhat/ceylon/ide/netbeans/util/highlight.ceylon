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
	JInteger=Integer,
	StringBuffer,
	Types
}
import java.util {
	StringTokenizer
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

// TODO extract this and iterateTokens in ide-common
"Highlights a message that contains code snippets in single quotes, and returns
 an HTML representation of that message surrounded by `<html>` tags."
shared String highlightQuotedMessage(String description, Boolean eliminateQuotes = true) {
	
	value result = StringBuffer();
	result.append("<html>");
	
	iterateTokens(description, eliminateQuotes, (token, highlightMode) {
		switch(highlightMode)
		case (is Boolean) {
			result.append(highlight(token));
		}
		case (is String) {
			result.append(highlight(token));
		}
		else {
			result.append(token);
		}
	});
	
	result.append("</html>");
	
	return result.string;
}

void iterateTokens(String description, Boolean eliminateQuotes,
	Anything(String, <String|Boolean>?) consume) {
	
	value tokens = StringTokenizer(description, "'\"", true);
	
	while (tokens.hasMoreTokens()) {
		String tok = tokens.nextToken();
		if (tok=="'") {
			if (!eliminateQuotes) {
				consume(tok, null);
			}
			while (tokens.hasMoreTokens()) {
				value token = tokens.nextToken();
				if (token=="'") {
					if (!eliminateQuotes) {
						consume(token, null);
					}
					break;
				} else if (token=="\"") {
					consume(token, "stringAttrs");
					while (tokens.hasMoreTokens()) {
						String quoted = tokens.nextToken();
						consume(quoted, "stringAttrs");
						if (quoted=="\"") {
							break;
						}
					}
				} else {
					consume(token, true);
				}
			}
		} else {
			consume(tok, null);
		}
	}
}


shared String highlight(String rawText) {
    value lang = ceylonLanguageHierarchy.language();
    value hierarchy = TokenHierarchy.create(Types.nativeString(rawText), lang);
    
    value ts = hierarchy.tokenSequence(lang);
    value sb = StringBuilder();
    value fcs = MimeLookup.getLookup(lang.mimeType())
            .lookup(`FontColorSettings`);
    
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
