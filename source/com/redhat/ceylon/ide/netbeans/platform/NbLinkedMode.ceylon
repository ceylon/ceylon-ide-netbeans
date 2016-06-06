import com.redhat.ceylon.ide.netbeans.correct {
    NbDocument
}
import com.redhat.ceylon.ide.common.platform {
    LinkedMode
}
import com.redhat.ceylon.ide.common.completion {
    ProposalsHolder
}

// TODO
shared class NbLinkedMode(NbDocument doc) extends LinkedMode(doc) {
    shared actual void addEditableGroup(Integer[3]+ positions) {}
    
    shared actual void addEditableRegion(Integer start, Integer length,
        Integer exitSeqNumber, ProposalsHolder proposals) {}
    
    shared actual void install(Object owner, Integer exitSeqNumber,
        Integer exitPosition) {}
}
