import com.redhat.ceylon.ide.common.platform {
    IdeUtils,
    Status
}
import java.lang {
    RuntimeException
}
import java.util.logging {
    Logger,
    Level
}

object nbIdeUtils satisfies IdeUtils {
    value logger = Logger.getLogger("nbIdeUtils");
    
    isOperationCanceledException(Exception exception)
            => exception is NbOperationCancelledException;
    
    shared actual void log(Status status, String message, Exception? e) {
        value level = switch(status)
        case(Status._ERROR) Level.severe
        case(Status._WARNING) Level.warning
        case(Status._INFO) Level.info
        case(Status._DEBUG) Level.fine
        case(Status._OK) Level.finer
        else null;
        
        if (exists level) {
            logger.log(level, message, e);
        }
    }
    
    newOperationCanceledException(String message)
            => NbOperationCancelledException(message);
    
}

class NbOperationCancelledException(String message)
        extends RuntimeException(message) {
    
}