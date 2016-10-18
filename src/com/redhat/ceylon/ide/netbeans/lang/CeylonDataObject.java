package com.redhat.ceylon.ide.netbeans.lang;

import com.redhat.ceylon.ide.netbeans.util.nbIcons_;
import com.redhat.ceylon.model.typechecker.util.ModuleManager;
import java.awt.Image;
import java.io.IOException;
import org.netbeans.core.spi.multiview.MultiViewElement;
import org.netbeans.core.spi.multiview.text.MultiViewEditorElement;
import org.openide.filesystems.FileObject;
import org.openide.loaders.DataNode;
import org.openide.loaders.DataObject;
import org.openide.loaders.DataObjectExistsException;
import org.openide.loaders.MultiDataObject;
import org.openide.loaders.MultiFileLoader;
import org.openide.nodes.Children;
import org.openide.nodes.Node;
import org.openide.util.Lookup;
import org.openide.util.NbBundle.Messages;
import org.openide.windows.TopComponent;

public class CeylonDataObject extends MultiDataObject {

    public CeylonDataObject(FileObject file, MultiFileLoader loader)
            throws DataObjectExistsException, IOException {
        super(file, loader);
        registerEditor(AnnotatedCeylonLanguage.MIME_TYPE, true);
    }

    @Override
    protected int associateLookup() {
        return 1;
    }

    @MultiViewElement.Registration(
            displayName = "#LBL_Ceylon_EDITOR",
            iconBase = "icons/ceylonFile.png",
            mimeType = AnnotatedCeylonLanguage.MIME_TYPE,
            persistenceType = TopComponent.PERSISTENCE_ONLY_OPENED,
            preferredID = "Ceylon",
            position = 1000
    )
    @Messages("LBL_Ceylon_EDITOR=Source")
    public static MultiViewEditorElement createEditor(Lookup lkp) {
        return new MultiViewEditorElement(lkp);
    }

    @Override
    protected Node createNodeDelegate() {
        if (associateLookup() >= 1) {
            return new CustomDataNode(this, Children.LEAF, getLookup());
        }
        return new CustomDataNode(this, Children.LEAF);
    }
}

/* This allows rendering @2x icons on hidpi screens. */
class CustomDataNode extends DataNode {

    public CustomDataNode(DataObject obj, Children ch) {
        super(obj, ch);
    }

    public CustomDataNode(DataObject obj, Children ch, Lookup lookup) {
        super(obj, ch, lookup);
    }

    @Override
    public Image getIcon(int type) {
        String name = getDataObject().getPrimaryFile().getNameExt();

        switch (name) {
            case ModuleManager.MODULE_FILE:
                return nbIcons_.get_().getModules();
            case ModuleManager.PACKAGE_FILE:
                return nbIcons_.get_().getPackages();
            default:
                return nbIcons_.get_().getCeylonFile();
        }
    }

    @Override
    public Image getOpenedIcon(int type) {
        return getIcon(type);
    }

}
