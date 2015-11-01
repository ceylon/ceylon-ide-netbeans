#!/bin/bash

if [ -d flat-repo ]; then
    rm flat-repo/*
else
    mkdir flat-repo
fi

folders=("/Applications/NetBeans/NetBeans 8.1 RC.app/Contents/Resources/NetBeans/platform/lib" "/Applications/NetBeans/NetBeans 8.1 RC.app/Contents/Resources/NetBeans/platform/modules" "/Applications/NetBeans/NetBeans 8.1 RC.app/Contents/Resources/NetBeans/ide/modules" "/Applications/NetBeans/NetBeans 8.1 RC.app/Contents/Resources/NetBeans/platform/core" "/Applications/NetBeans/NetBeans 8.1 RC.app/Contents/Resources/NetBeans/java/modules")

for dependency in `grep code-name-base /Users/bastien/Dev/ceylon/ceylon-ide-netbeans/nbproject/project.xml | cut -d'>' -f 2 | cut -d'<' -f1` ; do
    dashedDependency=`echo $dependency | tr "." "-" `

    for folder in "${folders[@]}"; do
        if [ -f "$folder/$dashedDependency.jar" ]; then
            #ln -s "$folder/$dashedDependency.jar" "flat-repo//$dependency-current.jar"
            cp "$folder/$dashedDependency.jar" "flat-repo//$dependency-current.jar"
        fi
    done

    echo "    shared import $dependency \"current\""
done

# Ceylon dependencies

if [ -d release/modules/ext ]; then
    rm release/modules/ext/*
else
    mkdir -p release/modules/ext
fi

cd release/modules/ext

ln -s ~/.ceylon/repo/org/antlr/runtime/3.4/org.antlr.runtime-3.4.jar .
ln -s ~/.ceylon/repo/ceylon/collection/1.2.0/ceylon.collection-1.2.0.car
ln -s ~/.ceylon/repo/ceylon/interop/java/1.2.0/ceylon.interop.java-1.2.0.car
ln -s ~/.ceylon/repo/ceylon/language/1.2.0/ceylon.language-1.2.0.car
ln -s ~/.ceylon/repo/ceylon/runtime/1.2.0/ceylon.runtime-1.2.0.jar
ln -s ~/.ceylon/repo/com/redhat/ceylon/common/1.2.0/com.redhat.ceylon.common-1.2.0.jar
ln -s ~/.ceylon/repo/com/redhat/ceylon/model/1.2.0/com.redhat.ceylon.model-1.2.0.jar
ln -s ~/.ceylon/repo/com/redhat/ceylon/module-resolver/1.2.0/com.redhat.ceylon.module-resolver-1.2.0.jar
ln -s ~/.ceylon/repo/com/redhat/ceylon/typechecker/1.2.0/com.redhat.ceylon.typechecker-1.2.0.jar
ln -s ~/Dev/ceylon/ceylon-ide-common/modules/com/redhat/ceylon/ide/common/1.2.1/com.redhat.ceylon.ide.common-1.2.1.car
ln -s ../../../modules/com/redhat/ceylon/ide/netbeans/1.2.0/com.redhat.ceylon.ide.netbeans-1.2.0.car
ln -s ~/.ceylon/repo/org/jboss/modules/1.3.3.Final/org.jboss.modules-1.3.3.Final.jar
ln -s ~/.ceylon/repo/com/github/rjeschke/txtmark/0.13/com.github.rjeschke.txtmark-0.13.jar
