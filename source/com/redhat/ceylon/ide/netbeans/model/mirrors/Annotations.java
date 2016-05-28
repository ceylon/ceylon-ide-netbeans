package com.redhat.ceylon.ide.netbeans.model.mirrors;

enum Annotations {
    attribute(com.redhat.ceylon.compiler.java.metadata.Attribute.class),
    object(com.redhat.ceylon.compiler.java.metadata.Object.class),
    method(com.redhat.ceylon.compiler.java.metadata.Method.class),
    container(com.redhat.ceylon.compiler.java.metadata.Container.class),
    localContainer(com.redhat.ceylon.compiler.java.metadata.LocalContainer.class),
    ceylon(com.redhat.ceylon.compiler.java.metadata.Ceylon.class);
    
    final Class<?> klazz;

    private Annotations(Class<?> klazz) {
        this.klazz = klazz;
    }
}
