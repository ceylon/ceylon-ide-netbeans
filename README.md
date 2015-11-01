# Ceylon IDE for NetBeans

## Status

This is still experimental, but please speak up if you're interested 
in helping get this project off the ground.

This plugin adds support for the [Ceylon programming language](ceylon-lang.org)
to NetBeans.

## Current features

* recognize Ceylon files and highlight them
* show parse and type chek errors
* a few quick fixes (mainly to add/remove annotations)
* code completion
* organize imports
* format code


## How to build

1. Clone this project
2. Run the script `./dependencies.sh`
3. Open the project in Eclipse<sup>1</sup>, this will build `com.redhat.ceylon.ide.netbeans-1.x.x.car`
4. Open the project in NetBeans, it should run as is

<sup>1</sup> This is needed because most of the plugin is written in Ceylon, and
the plugin cannot build Ceylon code yet.
