import com.redhat.ceylon.ide.common.open {
	AbstractNavigation
}
import com.redhat.ceylon.ide.common.util {
	Path
}
import com.redhat.ceylon.model.typechecker.model {
	Declaration
}

import java.lang {
	JInteger=Integer
}

import org.netbeans.modules.editor {
	NbEditorUtilities
}
import org.openide.cookies {
	EditorCookie
}
import org.openide.filesystems {
	FileObject,
	FileUtil
}
import org.openide.loaders {
	DataObject
}
import org.openide.text {
	Line,
	DocumentUtil=NbDocument
}

object nbNavigation extends AbstractNavigation<Anything, FileObject>() {
	
	filePath(FileObject file) => Path(file.path);
	
	shared actual void gotoFile(FileObject file, JInteger offset, JInteger length) {
		if (exists cookie = DataObject.find(file).lookup.lookup(`EditorCookie`),
			exists doc = cookie.openDocument()) {
			
			value line = NbEditorUtilities.getLine(doc, offset.intValue(), true);
			value column = offset.intValue() - DocumentUtil.findLineOffset(doc, line.lineNumber);
			line.show(Line.ShowOpenType.open, Line.ShowVisibilityType.focus, column);
		}
	}
	
	shared actual void gotoJavaNode(Declaration declaration) {
		// TODO
		print("goto java");
	}
	
	shared actual void gotoLocation(Path? path, JInteger offset, JInteger length) {
		if (exists path,
			exists fo = FileUtil.toFileObject(path.file)) {
			
			gotoFile(fo, offset, length);
		}
	}
}
