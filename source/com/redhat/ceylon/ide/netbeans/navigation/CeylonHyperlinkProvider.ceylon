import ceylon.interop.java {
	createJavaIntArray
}

import com.redhat.ceylon.compiler.typechecker.tree {
	Node
}
import com.redhat.ceylon.ide.common.util {
	nodes
}
import com.redhat.ceylon.ide.netbeans.model {
	findParseController
}
import com.redhat.ceylon.ide.netbeans.util {
	highlight
}
import com.redhat.ceylon.model.typechecker.model {
	Referenceable
}

import java.lang {
	IntArray
}
import java.util {
	Collections
}

import javax.swing.text {
	Document
}

import org.netbeans.api.editor.mimelookup {
	mimeRegistration
}
import org.netbeans.lib.editor.hyperlink.spi {
	HyperlinkProviderExt,
	HyperlinkType
}

mimeRegistration {
	mimeType = "text/x-ceylon";
	service = `interface HyperlinkProviderExt`;
	position = 1000;
}
shared class CeylonHyperlinkProvider() satisfies HyperlinkProviderExt {

	variable Node? node = null;
	variable Referenceable? model = null;
	
	shared actual Boolean isHyperlinkPoint(Document doc, Integer offset, HyperlinkType type) {
		this.node = null;
		this.model = null;

		if (exists controller = findParseController(doc),
			exists la = controller.lastAnalysis,
			exists cu = la.typecheckedRootNode,
			exists node = nodes.findNode(cu, la.tokens, offset),
			exists id = nodes.getIdentifyingNode(node)) {
			
			if (exists target = nbNavigation.getTarget(cu, id)) {
				model = nodes.getReferencedModel(target);
			} else {
				model = nodes.getReferencedModel(node);
			}
			
			this.node = id;
		}
		return this.model exists;
	}

	shared actual IntArray getHyperlinkSpan(Document doc, Integer offset, HyperlinkType type) {
		assert(exists n = node);
		return createJavaIntArray({n.startIndex.intValue(), n.stopIndex.intValue() + 1});
	}
	
	getTooltipText(Document doc, Integer offset, HyperlinkType type)
			=> if (exists m = model) then "<html>``highlight(m.string)``</html>" else null;
	
	shared actual void performClickAction(Document doc, Integer offset, HyperlinkType type) {
		// TODO does not work for declaration in ExternalSourceFiles
		nbNavigation.gotoDeclaration(model);
	}
	
	supportedHyperlinkTypes => Collections.singleton(HyperlinkType.goToDeclaration);
}
