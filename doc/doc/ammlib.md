
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
* [ammLogTime](#ammLogTime)
* [ammLogDate](#ammLogDate)
* [_ammLog](#_ammLog)
* [ammLogDie](#ammLogDie)
* [ammLogErr](#ammLogErr)
* [ammLogWrn](#ammLogWrn)
* [ammLogInf](#ammLogInf)
* [ammLogDbg](#ammLogDbg)
* [ammLogMissingBin](#ammLogMissingBin)
* [ammLogSilence](#ammLogSilence)
* [ammLogWriteTerm](#ammLogWriteTerm)
* [ammEnvPathAdd](#ammEnvPathAdd)
* [ammEnvLibAdd](#ammEnvLibAdd)
* [ammEnvManAdd](#ammEnvManAdd)
* [ammExecAsUser](#ammExecAsUser)
* [ammExecExists](#ammExecExists)
* [ammExecRequestOne](#ammExecRequestOne)
* [ammExecRequires](#ammExecRequires)
* [ammExecRequiresOne](#ammExecRequiresOne)
* [ammIsFunc](#ammIsFunc)
* [ammIsVar](#ammIsVar)


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
## ammLogTime

 Returns the Time for the logs
_Function has no arguments._

### Output on stdout

*  Date format HH:MM:SS

## ammLogDate

 Returns the Date for the logs
_Function has no arguments._

### Output on stdout

*  Dat format yyyy-mm-dd

## _ammLog

 (private) Generic log function for logging
### Arguments

* $1  (string) tag
* $2  (string) format, passed to ammLogColor, thus keys of $__AMMLOG_TERMCODES
* $@  (string[]) Text to be logged. If only "-", read as stdin.

### Output on stdout

*  (string) Resulting log

## ammLogDie

 Log a fatal error and terminate script
### Arguments

* $@  Log text for fatal error. If "-", text is read from stdin

## ammLogErr

 Log an error
### Arguments

* $@  Error text to log. If "-", text is read from stdin

## ammLogWrn

 Log a warning
### Arguments

* $@  warning text to log. If "-", text is read from stdin

## ammLogInf

 Log an information
### Arguments

* $@  Info text to log. If "-", text is read from stdin

## ammLogDbg

 Log a debug info
### Arguments

* $@  Debug text to log. If "-", text is read from stdin

## ammLogMissingBin

 Log for a missing binary, and try to find the packages providing them
### Arguments

* $@  List of missing binaries to search for

## ammLogSilence

 Disable or enable logging
### Arguments

* $1  (string) Wanted state: 0 to disable logging, "onlyerr" to only log errors, anything else to enable logging

## ammLogWriteTerm

 Log a message to the terminal (not through stdout). Only if session is interactive
### Arguments

* $1  (string) message to be written

## ammEnvPathAdd

 Add a path to PATH
### Arguments

* $1  (string)(optionnal). Can be "before" or "after" (default)
* $@  (path[]) List of paths to be added to the env var

## ammEnvLibAdd

 Add a path to LD_LIBRARY_PATH
### Arguments

* $1  (string)(optionnal). Can be "before" or "after" (default)
* $@  (path[]) List of paths to be added to the env var

## ammEnvManAdd

 Add a path to MANPATH
### Arguments

* $1  (string)(optionnal). Can be "before" or "after" (default)
* $@  (path[]) List of paths to be added to the env var

## ammExecAsUser

 Execute a command as a different user
### Arguments

* $1  (string) User to run the command as
* $@  (string) the command to run, and its arguments. if "-", command is read from stdin

## ammExecExists

 Check if one or more command are available in PATH
### Arguments

* $@  (string) the executables to search for

### Exit codes

* **0**: if all are found
* **1**: if at least one is not found

## ammExecRequestOne

 Check if at least one given command is available in PATH
### Arguments

* $@  (string) the executables to search for

### Exit codes

* **0**: if at least one is found
* **1**: if none are found

## ammExecRequires

 Same as ammExecExists but calls ammLogDie and terminate the script if any requested binary is not found
### Arguments

* $@  (string) Binaries to search for in PATH

## ammExecRequiresOne

 Same as ammExecRequestOne but calls ammLogDie and terminates if none of requested binary is found
function ammExecRequiresOne {
## ammIsFunc

 Check if given name is a function
### Exit codes

* **0**:  is a function
* **1**:  is not a function

## ammIsVar

 Check if name if a variable
### Exit codes

* **0**:  is a defined variable
* **1**:  is not a variable

