package com.redhat.ceylon.ide.netbeans.model.mirrors;

enum Annotations {
    attribute(org.eclipse.ceylon.compiler.java.metadata.Attribute.class),
    object(org.eclipse.ceylon.compiler.java.metadata.Object.class),
    method(org.eclipse.ceylon.compiler.java.metadata.Method.class),
    container(org.eclipse.ceylon.compiler.java.metadata.Container.class),
    localContainer(org.eclipse.ceylon.compiler.java.metadata.LocalContainer.class),
    ceylon(org.eclipse.ceylon.compiler.java.metadata.Ceylon.class);
    
    final Class<?> klazz;

    private Annotations(Class<?> klazz) {
        this.klazz = klazz;
    }
}
