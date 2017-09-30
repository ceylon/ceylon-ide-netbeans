import ceylon.interop.java {
	createJavaObjectArray
}

import org.eclipse.ceylon.ide.common.util {
	FindReferencesVisitor,
	nodes
}
import com.redhat.ceylon.ide.netbeans.model {
	findParseController
}

import java.awt {
	Color
}
import java.lang.ref {
	WeakReference
}

import javax.swing.event {
	CaretListener,
	CaretEvent
}
import javax.swing.text {
	Document,
	StyleConstants,
	JTextComponent
}

import org.netbeans.api.editor.mimelookup {
	mimeRegistration
}
import org.netbeans.api.editor.settings {
	AttributesUtilities
}
import org.netbeans.modules.editor {
	NbEditorUtilities
}
import org.netbeans.spi.editor.highlighting {
	HighlightsLayerFactory,
	HighlightsLayer,
	ZOrder
}
import org.netbeans.spi.editor.highlighting.support {
	OffsetsBag
}
import org.openide.cookies {
	EditorCookie
}
import org.openide.util {
	RequestProcessor
}

mimeRegistration {
	mimeType = "text/x-ceylon";
	service = `interface HighlightsLayerFactory`;
}
shared class MarkOccurrencesHighlightsLayerFactory() satisfies HighlightsLayerFactory {
	
	MarkOccurrencesHighlighter getMarkOccurrencesHighlighter(Document doc) {
		assert (is MarkOccurrencesHighlighter? highlighter
					= doc.getProperty(`MarkOccurrencesHighlighter`));
		if (!exists highlighter) {
			value h = MarkOccurrencesHighlighter(WeakReference(doc));
			h.setup();
			doc.putProperty(`MarkOccurrencesHighlighter`, h);
			return h;
		}
		
		return highlighter;
	}
	
	createLayers(HighlightsLayerFactory.Context context) => 
			createJavaObjectArray({
				HighlightsLayer.create(
					"MarkOccurrencesHighlighter",
					ZOrder.caretRack.forPosition(2000),
					true,
					getMarkOccurrencesHighlighter(context.document).highlightsBag
				)
			});
}

class MarkOccurrencesHighlighter(WeakReference<Document> doc) satisfies CaretListener {
	
	value defaultColors =
		AttributesUtilities.createImmutable(StyleConstants.\iBackground, Color(236, 235, 163));
	value declColors =
			AttributesUtilities.createImmutable(StyleConstants.\iBackground, Color(236, 200, 163));
	value bag = OffsetsBag(doc.get());
	value rp = RequestProcessor(`MarkOccurrencesHighlighter`);
	variable RequestProcessor.Task? lastRefreshTask = null;

	late JTextComponent? comp;
	
	shared void setup() {
		if (exists dobj = NbEditorUtilities.getDataObject(doc.get())) {
			value pane = dobj.lookup.lookup(`EditorCookie`);
			if (exists panes = pane.openedPanes,
				panes.size > 0) {
				
				value c = panes.get(0);
				c.addCaretListener(this);
				comp = c;
			} else {
				comp = null;
			}
		} else {
			comp = null;
		}
	}
	
	shared actual void caretUpdate(CaretEvent e) {
		bag.clear();
		setupAutoRefresh();
	}
	
	shared void setupAutoRefresh() {
		if (!exists t = lastRefreshTask) {
			lastRefreshTask = rp.post(
				() {
					value myDoc = doc.get();
					
					if (exists pos = comp?.caret?.dot,
						exists controller = findParseController(myDoc),
						exists lar = controller.lastAnalysis,
						exists node = nodes.findNode(lar.parsedRootNode, lar.tokens, pos),
						exists model = nodes.getReferencedModel(node)) {
						
						value vis = FindReferencesVisitor(model);
						lar.parsedRootNode.visit(vis);
						
						for (ref in vis.referenceNodes) {
							value id = nodes.getIdentifyingNode(ref);
							assert(exists id);
							bag.addHighlight(
								id.startIndex.intValue(),
								id.stopIndex.intValue() + 1,
								defaultColors
							);
						}
						
						if (exists decl = nodes.findReferencedNode(lar.parsedRootNode, vis.declaration),
							exists id = nodes.getIdentifyingNode(decl)) {
							bag.addHighlight(
								id.startIndex.intValue(),
								id.stopIndex.intValue() + 1,
								declColors
							);
						}
					}
					
					lastRefreshTask = null;
				}
			, 100);
		}
	}
	
	shared OffsetsBag highlightsBag {
		return bag;
	}
}
