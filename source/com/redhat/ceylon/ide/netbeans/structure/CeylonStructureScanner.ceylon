import com.redhat.ceylon.ide.netbeans.lang {
    NBCeylonParser
}

import java.lang {
    JString=String
}
import java.util {
    Map,
    List,
    HashMap,
    ArrayList
}

import org.netbeans.modules.csl.api {
    StructureScanner,
    StructureItem,
    OffsetRange
}
import org.netbeans.modules.csl.spi {
    ParserResult
}
import com.redhat.ceylon.ide.netbeans.model {
    CeylonParseController
}

shared object ceylonStructureScanner satisfies StructureScanner {
    
    shared actual StructureScanner.Configuration? configuration => null;
    
    shared actual Map<JString,List<OffsetRange>> folds(ParserResult result) {
        value myFolds = HashMap<JString,List<OffsetRange>>();
        
        if (is NBCeylonParser.CeylonParserResult result) {
            FoldingVisitor(myFolds).visitCompilationUnit(result.rootNode);
        }
        return myFolds;
    }
    
    shared actual List<out StructureItem> scan(ParserResult result) {
        value myScan = ArrayList<StructureItem>();
        
        if (is NBCeylonParser.CeylonParserResult result,
            exists doc = result.snapshot.source.getDocument(false)) {
            
            // TODO when we select a closed file in the Projects view,
            // there's no document so we show an empty structure
            // -> query the global model
            //CeylonParseController.get(doc).typeCheck(result.rootNode);
            StructureVisitor(myScan).visitCompilationUnit(result.rootNode);
        }
        
        return myScan;
    }
}