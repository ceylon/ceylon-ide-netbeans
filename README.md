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
* format code (using [ceylon.formatter](https://github.com/ceylon/ceylon.formatter))

## How to build

1. Clone the [Ceylon distribution](https://github.com/ceylon/ceylon)
2. From the `ceylon` directory, run `ant setup-sdk setup-ide` to pull all the 
required dependencies
3. Build the Ceylon distribution, SDK etc. by running `ant clean-all dist sdk intellij`
4. Clone this project
5. Build the NetBeans plugin using `ant clean create-update-center`
6. Open the project in Eclipse<sup>1</sup> to make changes to Ceylon files in `source`
7. Open the project in NetBeans to make changes to Java files in `src` and run the NetBeans module

<sup>1</sup> This is needed because most of the plugin is written in Ceylon, and
the plugin cannot build Ceylon code yet.
