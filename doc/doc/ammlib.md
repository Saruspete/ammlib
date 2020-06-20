
* [ammLib::HookNameToVarname](#ammLibHookNameToVarname)
* [ammLib::HookExists](#ammLibHookExists)
* [ammLib::HookRegister](#ammLibHookRegister)
* [ammLib::HookListCallbacks](#ammLibHookListCallbacks)
* [ammLib::HookTrigger](#ammLibHookTrigger)
* [_ammLib::TrapInit](#_ammLibTrapInit)
* [ammLib::TrapRegister](#ammLibTrapRegister)
* [_ammLib::TrapHandler](#_ammLibTrapHandler)
* [ammLib::Locate](#ammLibLocate)
* [ammLib::LocatePattern](#ammLibLocatePattern)
* [ammLib::NameFromPath](#ammLibNameFromPath)
* [ammLib::GetSymbols](#ammLibGetSymbols)
* [ammLib::IsSublib](#ammLibIsSublib)
* [ammLib::MetaGetPrefix](#ammLibMetaGetPrefix)
* [ammLib::Loadable](#ammLibLoadable)
* [ammLib::Load](#ammLibLoad)
* [ammLib::Unload](#ammLibUnload)
* [ammLib::Require](#ammLibRequire)
* [ammLib::ListModules](#ammLibListModules)
* [ammLog::Color](#ammLogColor)
* [ammLog::Time](#ammLogTime)
* [ammLog::Date](#ammLogDate)
* [_ammLog::Log](#_ammLogLog)
* [ammLog::Die](#ammLogDie)
* [ammLog::Err](#ammLogErr)
* [ammLog::Wrn](#ammLogWrn)
* [ammLog::Inf](#ammLogInf)
* [ammLog::Dbg](#ammLogDbg)
* [ammLog::Deprecated](#ammLogDeprecated)
* [_ammLog::StepPad](#_ammLogStepPad)
* [ammLog::Step](#ammLogStep)
* [ammLog::StepBegin](#ammLogStepBegin)
* [ammLog::StepEnd](#ammLogStepEnd)
* [ammLog::Stackdump](#ammLogStackdump)
* [ammLog::MissingBin](#ammLogMissingBin)
* [ammLog::Silence](#ammLogSilence)
* [ammLog::WriteTerm](#ammLogWriteTerm)
* [ammEnv::PathAdd](#ammEnvPathAdd)
* [ammEnv::LibAdd](#ammEnvLibAdd)
* [ammEnv::ManAdd](#ammEnvManAdd)
* [ammEnv::IsFunc](#ammEnvIsFunc)
* [ammEnv::IsVar](#ammEnvIsVar)
* [ammPath::Decompose](#ammPathDecompose)
* [ammPath::IsSecure](#ammPathIsSecure)
* [ammPath::IsWritable](#ammPathIsWritable)
* [ammPath::CopyStructure](#ammPathCopyStructure)
* [ammExec::AsUser](#ammExecAsUser)
* [ammExec::Exists](#ammExecExists)
* [ammExec::RequestOne](#ammExecRequestOne)
* [ammExec::Require](#ammExecRequires)
* [ammExec::RequireOne](#ammExecRequiresOne)


## ammLib::HookNameToVarname

 Will generate a variable ID from a given name
function ammLib::HookNameToVarname {
## ammLib::HookExists

	typeset -u name="$1"

Remove any non-alphanum char
	name="${name//[^a-zA-Z0-9]/}"
	echo "__AMMLIB_HOOK_$name"
}

function ammLib::HookExists {
## ammLib::HookRegister

 Register a callback to a hook
### Arguments

* $1  (string) Name of the hook to register
* $2  (function) Callback

## ammLib::HookListCallbacks

 List registered callbacks for an even
### Arguments

* $1  (string) name of the hook to list callbacks

## ammLib::HookTrigger

 Trigger a hook
### Arguments

* $1  (string) Name of the hook to trigger
* $@  (string) arguments to pass to the callbacks

## _ammLib::TrapInit

@description:  Initialize and registers the signal handling trap
### Arguments

* $@  Signals to be traped

## ammLib::TrapRegister

@description:  Registers a callback
### Arguments

* $1  The callback to call upon trap
* $@  The signals to register on. Can be alises: EXITALL or EXITERR

## _ammLib::TrapHandler

 (private) TRAP handler to clean
### Arguments

* $1  Name of the signal

## ammLib::Locate

 Locate the library file matching given name
### Arguments

* $1  (string) Name of the library to be loaded (eg, process)

### Output on stdout

*  (path) Path of the first matching file (in $__AMMLIB_SEARCHPATH)

## ammLib::LocatePattern

 Locate all libraries that starts with the given pattern
### Arguments

* $1  The pattern to search against

### Output on stdout

*  (path) the list of libraries that matches the given pattern

## ammLib::NameFromPath
* $1  (path) The file path to get the name from

### Output on stdout

*  (string) name of the library

## ammLib::GetSymbols

 List all symbols and functions for packing
### Arguments

* $@  (path[]) List of files to extract symbols from

## ammLib::IsSublib

 Check if the given libname is a sub-library
### Exit codes

*  **0**: on success

## ammLib::MetaGetPrefix

 Get the function name for the library' constructor
### Arguments

* $1  (string) library name

## ammLib::Loadable

 Test if a library is loadable (it's requirements are met)
### Arguments

* $@  (string[]) Name of the library

### Exit codes

* **0**:  If all modules are loadable
* 1+ if one or more module cannot be loaded

## ammLib::Load

 Load a library
### Arguments

* $@  (string[]) Library name to be loaded

### Exit codes

* **0**: if all modules were loaded successfully
* 1+ if one or more module failed to load

## ammLib::Unload

 Unload a module from the current session
### Arguments

* $@   (string[]) List of modules to unload

## ammLib::Require

 Similar to ammLibLoad but exit if a module cannot be loaded
### Arguments

* $@  (string[]) List of modules to be loaded

## ammLib::ListModules

List modules currently available
_Function has no arguments._

## ammLog::Color

 Colorize the text with values in __AMMLOG_TERMCODES
## ammLog::Time

 Returns the Time for the logs
_Function has no arguments._

### Output on stdout

*  Date format HH:MM:SS

## ammLog::Date

 Returns the Date for the logs
_Function has no arguments._

### Output on stdout

*  Dat format yyyy-mm-dd

## _ammLog::Log

 (private) Generic log function for logging
### Arguments

* $1  (string) tag
* $2  (string) format, passed to ammLog::Color, thus keys of $__AMMLOG_TERMCODES
* $@  (string[]) Text to be logged. If only "-", read as stdin.

### Output on stdout

*  (string) Resulting log

## ammLog::Die

 Log a fatal error and terminate script
### Arguments

* $@  Log text for fatal error. If "-", text is read from stdin

## ammLog::Err

 Log an error
### Arguments

* $@  Error text to log. If "-", text is read from stdin

## ammLog::Wrn

 Log a warning
### Arguments

* $@  warning text to log. If "-", text is read from stdin

## ammLog::Inf

 Log an information
### Arguments

* $@  Info text to log. If "-", text is read from stdin

## ammLog::Dbg

 Log a debug info
### Arguments

* $@  Debug text to log. If "-", text is read from stdin

## ammLog::Deprecated

 Log a warning about function deprecation
function ammLog::Deprecated {
## _ammLog::StepPad

	typeset replacement="$1"
	typeset message="${2:-}"

	typeset callee="$(ammLog::Stackdump 2 1)"
	typeset callstack="$(ammLog::Stackdump 3 1)"

	ammLog::Wrn "Function '$callee' (called from $callstack) is deprectated. Update your code to use '$replacement' instead"
	[[ -n "$message" ]] && ammLog::Wrn "  $message"
}


function _ammLog::StepPad {
## ammLog::Step

 Show a visible step separator
function ammLog::Step {
## ammLog::StepBegin

 Mark a new step in the actions
### Arguments

* # @args $1  (string) The name of the step to be displayed

## ammLog::StepEnd

 Mark the end of a started step
### Arguments

* $1  (int) return code
* $2  (string) Message to be displayed

## ammLog::Stackdump

@description:  Display the stackdump of current script
### Arguments

* $1  (int) Stack levels to skip. Default 1 (= skip this function)
* $2  (int) Max levels to return. Default 255

## ammLog::MissingBin

 Log for a missing binary, and try to find the packages providing them
### Arguments

* $@  List of missing binaries to search for

## ammLog::Silence

 Disable or enable logging
### Arguments

* $1  (string) Wanted state: 0 to disable logging, "onlyerr" to only log errors, anything else to enable logging

## ammLog::WriteTerm

 Log a message to the terminal (not through stdout). Only if session is interactive
### Arguments

* $1  (string) message to be written

## ammEnv::PathAdd

 Add a path to PATH
### Arguments

* $1  (string)(optionnal). Can be "before" or "after" (default)
* $@  (path[]) List of paths to be added to the env var

## ammEnv::LibAdd

 Add a path to LD_LIBRARY_PATH
### Arguments

* $1  (string)(optionnal). Can be "before" or "after" (default)
* $@  (path[]) List of paths to be added to the env var

## ammEnv::ManAdd

 Add a path to MANPATH
### Arguments

* $1  (string)(optionnal). Can be "before" or "after" (default)
* $@  (path[]) List of paths to be added to the env var

## ammEnv::IsFunc

 Check if given name is a function
### Exit codes

* **0**:  is a function
* **1**:  is not a function

## ammEnv::IsVar

 Check if name if a variable
### Exit codes

* **0**:  is a defined variable
* **1**:  is not a variable

## ammPath::Decompose

 Decompose a path to a list of all its folders
### Arguments

* $1  (path) The path to decompose

## ammPath::IsSecure

 Check if the full path of a file is secure for the current user
### Arguments

* $1  (path) File or folder to check

### Exit codes

* **0**:   Path is secure
* >=**1**:  Path has a number of insecurities, shown as stdout

## ammPath::IsWritable

 Check if we can create the requested path
### Arguments

* $1  (path) File or folder to check

### Exit codes

* **0**:  Path is writable

## ammPath::CopyStructure

 Copy a selection of files with their relative structure
### Arguments

* $1  (path) Source path where to find the content
* $2  (path) Destination path where to copy content
* $@  (string) files or patterns to copy from source to destination

## ammExec::AsUser

 Execute a command as a different user
### Arguments

* $1  (string) User to run the command as
* $@  (string) the command to run, and its arguments. if "-", command is read from stdin

## ammExec::Exists

 Check if one or more command are available in PATH
### Arguments

* $@  (string) the executables to search for

### Exit codes

* **0**: if all are found
* **1**: if at least one is not found

## ammExec::RequestOne

 Check if at least one given command is available in PATH
### Arguments

* $@  (string) the executables to search for

### Exit codes

* **0**: if at least one is found
* **1**: if none are found

## ammExec::Require

 Same as ammExecExists but calls ammLog::Die and terminate the script if any requested binary is not found
### Arguments

* $@  (string) Binaries to search for in PATH

## ammExec::RequireOne

 Same as ammExecRequestOne but calls ammLog::Die and terminates if none of requested binary is found
function ammExec::RequireOne {
