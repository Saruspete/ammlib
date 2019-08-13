
* [_ammClean](#_ammClean)
* [ammLibLocate](#ammLibLocate)
* [ammLibLocatePattern](#ammLibLocatePattern)
* [ammLibNameFromPath](#ammLibNameFromPath)
* [ammLibGetSymbols](#ammLibGetSymbols)
* [ammLibIsSublib](#ammLibIsSublib)
* [ammLibMetaInitGetName](#ammLibMetaInitGetName)
* [ammLibLoadable](#ammLibLoadable)
* [ammLibLoad](#ammLibLoad)
* [ammLibUnload](#ammLibUnload)
* [ammLibRequire](#ammLibRequire)
* [ammLibListModules](#ammLibListModules)
* [ammLogColor](#ammLogColor)


## _ammClean

 (private) TRAP handler to clean
## ammLibLocate

 Locate the library file matching given name
### Arguments

* $1  (string) Name of the library to be loaded (eg, process)

### Output on stdout

*  (path) Path of the first matching file (in $__AMMLIB_SEARCHPATH)

## ammLibLocatePattern

 Locate all libraries that starts with the given pattern
### Arguments

* $1  The pattern to search against

### Output on stdout

*  (path) the list of libraries that matches the given pattern

## ammLibNameFromPath
* $1  (path) The file path to get the name from

### Output on stdout

*  (string) name of the library

## ammLibGetSymbols

 List all symbols and functions for packing
### Arguments

* $@  (path[]) List of files to extract symbols from

## ammLibIsSublib

 Check if the given libname is a sub-library
### Exit codes

*  **0**: on success

## ammLibMetaInitGetName

 Get the function name for the library' constructor
### Arguments

* $1  (string) library name

## ammLibLoadable

 Test if a library is loadable (it's requirements are met)
### Arguments

* $@  (string[]) Name of the library

### Exit codes

* **0**:  If all modules are loadable
* 1+ if one or more module cannot be loaded

## ammLibLoad

 Load a library
### Arguments

* $@  (string[]) Library name to be loaded

### Exit codes

* **0**: if all modules were loaded successfully
* 1+ if one or more module failed to load

## ammLibUnload

 Unload a module from the current session
### Arguments

* $@   (string[]) List of modules to unload

## ammLibRequire

 Similar to ammLibLoad but exit if a module cannot be loaded
### Arguments

* $@  (string[]) List of modules to be loaded

## ammLibListModules

List modules currently available
_Function has no arguments._

## ammLogColor

 Colorize the text with values in __AMMLOG_TERMCODES
