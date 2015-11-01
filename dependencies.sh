#!/bin/bash

netbeansHome=`tail config-private.properties | grep netbeans.home | cut -d'=' -f2`

if [ -z "$netbeansHome" ]; then
    echo "Please set the property netbeans.home in config.properties"
    exit -1
elif [ ! -d "$netbeansHome/platform" ]; then
    echo "netbeans.home seems to point to an invalid directory, it should contain a subdirectory named platform"
    exit -1
fi

if [ -d flat-repo ]; then
    rm flat-repo/*
else
    mkdir flat-repo
fi

folders=("$netbeansHome/platform/lib" "$netbeansHome/platform/modules"
         "$netbeansHome/ide/modules" "$netbeansHome/platform/core"
         "$netbeansHome/java/modules")

for dependency in `grep code-name-base ./nbproject/project.xml | cut -d'>' -f 2 | cut -d'<' -f1` ; do
    dashedDependency=`echo $dependency | tr "." "-" `

    for folder in "${folders[@]}"; do
        if [ -f "$folder/$dashedDependency.jar" ]; then
            #ln -s "$folder/$dashedDependency.jar" "flat-repo//$dependency-current.jar"
            cp "$folder/$dashedDependency.jar" "flat-repo//$dependency-current.jar"
        fi
    done

    echo "    shared import $dependency \"current\";"
done

# Ceylon dependencies

if [ -d release/modules/ext ]; then
    rm release/modules/ext/*
else
    mkdir -p release/modules/ext
fi

distVersion=`grep ceylon.dist.version config.properties | cut -d'=' -f2`
ideCommonVersion=`grep ceylon.ide.common.version config.properties | cut -d'=' -f2`
ideNetbeansVersion=`grep ceylon.ide.netbeans.version config.properties | cut -d'=' -f2`

cd release/modules/ext

# TODO download from herd if it's not in the local repo

ln -s ~/.ceylon/repo/org/antlr/runtime/3.4/org.antlr.runtime-3.4.jar .
ln -s "~/.ceylon/repo/ceylon/collection/$distVersion/ceylon.collection-$distVersion.car"
ln -s "~/.ceylon/repo/ceylon/interop/java/$distVersion/ceylon.interop.java-$distVersion.car"
ln -s "~/.ceylon/repo/ceylon/language/$distVersion/ceylon.language-$distVersion.car"
ln -s "~/.ceylon/repo/ceylon/runtime/$distVersion/ceylon.runtime-$distVersion.jar"
ln -s "~/.ceylon/repo/com/redhat/ceylon/common/$distVersion/com.redhat.ceylon.common-$distVersion.jar"
ln -s "~/.ceylon/repo/com/redhat/ceylon/model/$distVersion/com.redhat.ceylon.model-$distVersion.jar"
ln -s "~/.ceylon/repo/com/redhat/ceylon/module-resolver/$distVersion/com.redhat.ceylon.module-resolver-$distVersion.jar"
ln -s "~/.ceylon/repo/com/redhat/ceylon/typechecker/$distVersion/com.redhat.ceylon.typechecker-$distVersion.jar"
ln -s "~/Dev/ceylon/ceylon-ide-common/modules/com/redhat/ceylon/ide/common/1.2.1/com.redhat.ceylon.ide.common-1.2.1.car"
ln -s "../../../modules/com/redhat/ceylon/ide/netbeans/$ideNetbeansVersion/com.redhat.ceylon.ide.netbeans-$ideNetbeansVersion.car"
ln -s ~/.ceylon/repo/org/jboss/modules/1.3.3.Final/org.jboss.modules-1.3.3.Final.jar
ln -s ~/.ceylon/repo/com/github/rjeschke/txtmark/0.13/com.github.rjeschke.txtmark-0.13.jar