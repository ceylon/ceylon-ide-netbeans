import com.redhat.ceylon.ide.common.model {
	CeylonProjectBuild
}
import org.openide.filesystems {
	FileObject
}
import org.netbeans.api.project {
	Project
}

shared alias BuildMsg => CeylonProjectBuild<Project,FileObject,FileObject,FileObject>.BuildMessage;
shared alias SourceMsg => CeylonProjectBuild<Project,FileObject,FileObject,FileObject>.SourceFileMessage;
shared alias ProjectMsg => CeylonProjectBuild<Project,FileObject,FileObject,FileObject>.ProjectMessage;
