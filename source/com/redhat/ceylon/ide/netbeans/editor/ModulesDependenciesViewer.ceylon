import ceylon.interop.java {
    createJavaObjectArray,
    javaClass,
    javaString,
    CeylonIterable,
    createJavaStringArray
}

import com.redhat.ceylon.ide.common.model {
    ModuleDependencies,
    BaseIdeModule
}

import com.redhat.ceylon.ide.netbeans.model {
    findParseController
}
import com.redhat.ceylon.ide.netbeans.util {
    editorUtil,
	nbIcons
}
import com.redhat.ceylon.model.typechecker.model {
    Module
}

import java.awt {
    BorderLayout,
    Color,
    FlowLayout
}
import java.awt.event {
    ItemListener,
    ItemEvent
}
import java.util {
    ArrayList
}

import javax.swing {
    JPanel,
    Action,
    JScrollPane,
    JComboBox
}

import org.netbeans.api.visual.action {
    ActionFactory
}
import org.netbeans.api.visual.anchor {
    AnchorShape,
    AnchorFactory
}
import org.netbeans.api.visual.border {
    BorderFactory
}
import org.netbeans.api.visual.graph {
    GraphScene
}
import org.netbeans.api.visual.graph.layout {
    GraphLayoutFactory
}
import org.netbeans.api.visual.layout {
    LayoutFactory
}
import org.netbeans.api.visual.widget {
    Widget,
    LayerWidget,
    ConnectionWidget,
    LabelWidget
}
import org.netbeans.api.visual.widget.general {
    IconNodeWidget
}
import org.netbeans.core.spi.multiview {
    MultiViewElement,
    CloseOperationState,
    MultiViewElementCallback
}
import org.openide.awt {
    UndoRedo
}
import org.openide.loaders {
    MultiDataObject
}
import org.openide.util {
    Lookup
}

shared class ModulesDependenciesViewer(Lookup lkp) 
        extends JPanel()
        satisfies MultiViewElement {
    
    value dataObject = lkp.lookup(javaClass<MultiDataObject>());
    value scene = MyScene();
    value toolbar = JPanel(FlowLayout(FlowLayout.left, 0, 0));
    value layoutCombo = JComboBox(createJavaStringArray({
        "Hierarchical layout",
        "Orthogonal layout"
        //"Tree layout"
    }));
    
    actions => createJavaObjectArray<Action>({});
    
    canCloseElement() => CloseOperationState.stateOk;
    
    componentActivated() => noop();
    
    void generateGraph(ModuleDependencies mod) {
        for (dep in mod.allDependencies) {
            scene.myAddEdge(dep.source, dep.target);
        }
        doLayout();
    }
    
    componentClosed() => noop();
    
    componentDeactivated() => noop();
    
    componentHidden() => noop();
    
    shared actual void componentOpened() {
        scene.init();
        this.layout = BorderLayout();
        value scrollPane = JScrollPane();
        add(scrollPane, javaString(BorderLayout.center));
        scrollPane.setViewportView(scene.createView());
        add(scene.createSatelliteView(), javaString(BorderLayout.west));
        
        toolbar.add(layoutCombo);
        layoutCombo.addItemListener(object satisfies ItemListener {
            shared actual void itemStateChanged(ItemEvent evt) {
                if (evt.stateChange == ItemEvent.selected) {
                    doLayout();
                }
            }
        });
    }
    
    void doLayout() {
        value layout = switch (layoutCombo.selectedIndex)
        case (0) GraphLayoutFactory.createHierarchicalGraphLayout(scene, true)
        else GraphLayoutFactory.createOrthogonalGraphLayout(scene, true);
        // else GraphLayoutFactory.createTreeGraphLayout(0, 0, 5, 5, true);
        
        value sgl = LayoutFactory.createSceneGraphLayout(scene, layout);
        sgl.invokeLayout();
    }
    
    shared actual void componentShowing() {
        if (//dataObject.primaryFile.nameExt == "module.ceylon",
            exists doc = editorUtil.findOpenedDocument(dataObject.primaryFile),
            exists cpc = findParseController(doc)) {
            
            value deps = cpc.ceylonProject.moduleDependencies;
            scene.clear();
            generateGraph(deps);
        }
    }
    
    lookup => lkp;
    
    setMultiViewCallback(MultiViewElementCallback? multiViewElementCallback) => noop();
    
    toolbarRepresentation => toolbar;
    
    undoRedo => UndoRedo.none;
    
    visualRepresentation => this;
}

class MyScene() extends GraphScene<Module, String>() {

    late LayerWidget mainLayer;
    shared late LayerWidget connectionLayer;
    late LayerWidget interactionLayer;
    
    variable value edgeCnt = 0;

    shared void init() {
        mainLayer = LayerWidget(this);
        connectionLayer = LayerWidget(this);
        interactionLayer = LayerWidget(this);
        
        addChild(mainLayer);
        addChild(connectionLayer);
        addChild(interactionLayer);
    }

    shared actual void attachEdgeSourceAnchor(String e, Module old, Module mod) {
        assert(is ConnectionWidget w = findWidget(e));
        w.sourceAnchor = AnchorFactory.createRectangularAnchor(findWidget(mod));
    }
    
    shared actual void attachEdgeTargetAnchor(String e, Module old, Module mod) {
        assert(is ConnectionWidget w = findWidget(e));
        w.targetAnchor = AnchorFactory.createRectangularAnchor(findWidget(mod));
    }
    
    shared actual Widget attachEdgeWidget(String edge) {
        value connectionWidget = ConnectionWidget(this);
        connectionLayer.addChild(connectionWidget);
        connectionWidget.targetAnchorShape = AnchorShape.triangleFilled;
        return connectionWidget;
    }
    
    shared actual Widget attachNodeWidget(Module mod) {
        value widget = ModuleWidget(this, mod);
        
        widget.init();
        mainLayer.addChild(widget);
        
        return widget;
    }
    
    shared void myAddEdge(Object o1, Object o2) {
        if (is ModuleDependencies.ModuleWeakReference o1,
            is ModuleDependencies.ModuleWeakReference o2) {
            
            suppressWarnings("unusedDeclaration")
            value _ = findWidget(o1.get())
                else addNode(o1.get());
            
            suppressWarnings("unusedDeclaration")
            value __ = findWidget(o2.get())
                else addNode(o2.get());
            
            value id = "edge" + edgeCnt.string;
            edgeCnt++;
            addEdge(id);
            setEdgeSource(id, o1.get());
            setEdgeTarget(id, o2.get());
        }
    }
    
    shared void clear() {
        edgeCnt = 0;
        for (node in ArrayList(nodes)) {
            removeNodeWithEdges(node);
        }
        mainLayer.removeChildren();
    }
}

class ModuleWidget(MyScene scene, Module mod) 
        extends IconNodeWidget(scene, IconNodeWidget.TextOrientation.rightCenter) {
    
    shared void init() {
        setImage(nbIcons.modules);
        labelWidget.layout = LayoutFactory.createVerticalFlowLayout(null, 0);
        labelWidget.addChild(LabelWidget(scene, mod.nameAsString));
        labelWidget.addChild(LabelWidget(scene, mod.version));
         
        opaque = true;
        border = BorderFactory.createRoundedBorder(10, 10, 2, 0, modColor, Color.gray);
        labelWidget.font = scene.defaultFont;
        
        actions.addAction(ActionFactory.createMoveAction());
    }
    
    Color modColor {
        if (is BaseIdeModule mod) {
            if (mod.isProjectModule) {
                return Color.yellow;
            } 
            
            if (mod.referencingModules.narrow<BaseIdeModule>() // find referencing modules
                .filter(BaseIdeModule.isProjectModule)         // that are project modules
                .any((projMod) {
                    return CeylonIterable(projMod.imports)     // that import...
                            .map((i) => i.\imodule)
                            .contains(mod);                    // our module
                })) {

                return Color.\iGREEN;
            }
        }
        
        return Color.cyan;
    }
}
