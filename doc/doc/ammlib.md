
* [function _ammLib::PathGetForCaller {](#function-ammlibpathgetforcaller-)
* [function ammLib::HookNameToVarname {](#function-ammlibhooknametovarname-)
* [function ammLib::HookRegister {](#function-ammlibhookregister-)
* [function ammLib::HookListCallbacks {](#function-ammlibhooklistcallbacks-)
* [function ammLib::HookTrigger {](#function-ammlibhooktrigger-)
* [function _ammLib::TrapInit {](#function-ammlibtrapinit-)
* [function ammLib::TrapRegister {](#function-ammlibtrapregister-)
* [function _ammLib::TrapHandler {](#function-ammlibtraphandler-)
* [function ammLib::Locate {](#function-ammliblocate-)
* [function ammLib::LocatePattern {](#function-ammliblocatepattern-)
* [function ammLib::NameFromPath {](#function-ammlibnamefrompath-)
* [function ammLib::GetSymbols {](#function-ammlibgetsymbols-)
* [function ammLib::IsSublib {](#function-ammlibissublib-)
* [function ammLib::IsLoaded {](#function-ammlibisloaded-)
* [function ammLib::MetaGetPrefix {](#function-ammlibmetagetprefix-)
* [function ammLib::Loadable {](#function-ammlibloadable-)
* [function ammLib::Load {](#function-ammlibload-)
* [function ammLib::Unload {](#function-ammlibunload-)
* [function ammLib::Require {](#function-ammlibrequire-)
* [function ammLib::ListModules {](#function-ammliblistmodules-)
* [function ammLog::Color {](#function-ammlogcolor-)
* [function ammLog::Time {](#function-ammlogtime-)
* [function ammLog::Date {](#function-ammlogdate-)
* [function ammLog::_DbgIsEnabled {](#function-ammlogdbgisenabled-)
* [function _ammLog::Log {](#function-ammloglog-)
* [function ammLog::Die {](#function-ammlogdie-)
* [function ammLog::Error {](#function-ammlogerror-)
* [function ammLog::Warning {](#function-ammlogwarning-)
* [function ammLog::Info {](#function-ammloginfo-)
* [function ammLog::Debug {](#function-ammlogdebug-)
* [function ammLog::Deprecated {](#function-ammlogdeprecated-)
* [function ammLog::UnavailableFunc {](#function-ammlogunavailablefunc-)
* [function ammLog::EchoSeparator {](#function-ammlogechoseparator-)
* [function ammLog::Step {](#function-ammlogstep-)
* [function ammLog::StepBegin {](#function-ammlogstepbegin-)
* [function ammLog::StepEnd {](#function-ammlogstepend-)
* [function ammLog::Stackdump {](#function-ammlogstackdump-)
* [function ammLog::MissingBin {](#function-ammlogmissingbin-)
* [function ammLog::Silence {](#function-ammlogsilence-)
* [function ammLog::TracingLog {](#function-ammlogtracinglog-)
* [function ammLog::TracingEnable {](#function-ammlogtracingenable-)
* [function ammLog::WriteTerm {](#function-ammlogwriteterm-)
* [function ammEnv::PathAdd {](#function-ammenvpathadd-)
* [function ammEnv::LibAdd {](#function-ammenvlibadd-)
* [function ammEnv::ManAdd {](#function-ammenvmanadd-)
* [function ammEnv::IsFunc {](#function-ammenvisfunc-)
* [function ammEnv::IsVar {](#function-ammenvisvar-)
* [function ammPath::Decompose {](#function-ammpathdecompose-)
* [function ammPath::IsSecure {](#function-ammpathissecure-)
* [function ammPath::IsWritable {](#function-ammpathiswritable-)
* [function ammPath::IsEmpty {](#function-ammpathisempty-)
* [function _ammPath::RecurseFolders {](#function-ammpathrecursefolders-)
* [function ammPath::CopyStructure {](#function-ammpathcopystructure-)
* [function ammExec::AsUser {](#function-ammexecasuser-)
* [function ammExec::Exists {](#function-ammexecexists-)
* [function ammExec::RequestOne {](#function-ammexecrequestone-)
* [function ammExec::Require {](#function-ammexecrequire-)
* [function ammExec::RequireOne {](#function-ammexecrequireone-)
* [function ammExec::IsExecutable {](#function-ammexecisexecutable-)


## function _ammLib::PathGetForCaller {

 Path of the file that loaded ammlib

## function ammLib::HookNameToVarname {

 Will generate a variable ID from a given name

## function ammLib::HookRegister {

 Register a callback to a hook

### Arguments

* $1  (string) Name of the hook to register
* $2  (function) Callback

## function ammLib::HookListCallbacks {

 List registered callbacks for an even

### Arguments

* $1  (string) name of the hook to list callbacks

## function ammLib::HookTrigger {

 Trigger a hook

### Arguments

* $1  (string) Name of the hook to trigger
* $@  (string) arguments to pass to the callbacks

## function _ammLib::TrapInit {

 Initialize and registers the signal handling trap

### Arguments

* $@  Signals to be traped

## function ammLib::TrapRegister {

 Registers a callback

### Arguments

* $1  The callback to call upon trap
* $@  The signals to register on. Can be alises: EXITALL or EXITERR

## function _ammLib::TrapHandler {

 (private) TRAP handler to clean

### Arguments

* $1  Name of the signal

## function ammLib::Locate {

 Locate the library file matching given name

### Arguments

* $1  (string) Name of the library to be loaded (eg, process)

### Output on stdout

*  (path) Path of the first matching file (in $__AMMLIB_SEARCHPATH)

## function ammLib::LocatePattern {

 Locate all libraries that starts with the given pattern

### Arguments

* $1  The pattern to search against

### Output on stdout

*  (path) the list of libraries that matches the given pattern

## function ammLib::NameFromPath {

### Arguments

* $1  (path) The file path to get the name from

### Output on stdout

*  (string) name of the library

## function ammLib::GetSymbols {

 List all symbols and functions for packing

### Arguments

* $@  (path[]) List of files to extract symbols from

## function ammLib::IsSublib {

 Check if the given libname is a sub-library

### Exit codes

*  **0**: on success

## function ammLib::IsLoaded {

 Check if a given libname is loaded

### Exit codes

*  **0**: if loaded

## function ammLib::MetaGetPrefix {

 Get the function name for the library' constructor

### Arguments

* $1  (string) library name

## function ammLib::Loadable {

 Test if a library is loadable (MetaCheck) and display its path

### Arguments

* $@  (string[]) Name of the library

### Exit codes

* **0**:  If all modules are loadable
* 1+ if one or more module cannot be loaded

## function ammLib::Load {

 Load a library

### Arguments

* $@  (string[]) Library name to be loaded

### Exit codes

* **0**: if all modules were loaded successfully
* 1+ if one or more module failed to load

## function ammLib::Unload {

 Unload a module from the current session

### Arguments

* $@   (string[]) List of modules to unload

## function ammLib::Require {

 Similar to ammLibLoad but exit if a module cannot be loaded

### Arguments

* $@  (string[]) List of modules to be loaded

## function ammLib::ListModules {

List modules currently available

_Function has no arguments._

## function ammLog::Color {

 Colorize the text with values in __AMMLOG_TERMCODES

## function ammLog::Time {

 Returns the Time for the logs

_Function has no arguments._

### Output on stdout

*  Date format HH:MM:SS

## function ammLog::Date {

 Returns the Date for the logs

_Function has no arguments._

### Output on stdout

*  Dat format yyyy-mm-dd

## function ammLog::_DbgIsEnabled {

 Checks if AMMLIB_DEBUG variable is set and needs to do some job

## function _ammLog::Log {

 (private) Generic log function for logging

### Arguments

* $1  (string) tag
* $2  (string) format, passed to ammLog::Color, thus keys of $__AMMLOG_TERMCODES
* $@  (string[]) Text to be logged. If only "-", read as stdin.

### Output on stdout

*  (string) Resulting log

## function ammLog::Die {

 Log a fatal error and terminate script

### Arguments

* $@  Log text for fatal error. If "-", text is read from stdin

## function ammLog::Error {

 Log an error

### Arguments

* $@  Error text to log. If "-", text is read from stdin

## function ammLog::Warning {

 Log a warning

### Arguments

* $@  warning text to log. If "-", text is read from stdin

## function ammLog::Info {

 Log an information

### Arguments

* $@  Info text to log. If "-", text is read from stdin

## function ammLog::Debug {

 Log a debug info

### Arguments

* $@  Debug text to log. If "-", text is read from stdin

## function ammLog::Deprecated {

 Log a warning about function deprecation

## function ammLog::UnavailableFunc {

 Set a function as unavailable

### Arguments

* $1  function
* $2  reason

## function ammLog::EchoSeparator {

 Displays a separator with optionnal text on the middle

### Arguments

* $1  (string) The message to be between the separators
* $2  (string) The char to be used as separator. default '='

## function ammLog::Step {

 Show a visible step separator

## function ammLog::StepBegin {

 Mark a new step in the actions

### Arguments

* # @args $1  (string) The name of the step to be displayed

## function ammLog::StepEnd {

 Mark the end of a started step

### Arguments

* $1  (int) return code
* $2  (string) Message to be displayed

## function ammLog::Stackdump {

 Display the stackdump of current script

### Arguments

* $1  (int) Stack levels to skip. Default 1 (= skip this function)
* $2  (int) Max levels to return. Default 255

## function ammLog::MissingBin {

 Log for a missing binary, and try to find the packages providing them

### Arguments

* $@  List of missing binaries to search for

## function ammLog::Silence {

 Disable or enable logging

### Arguments

* $1  (string) Wanted state: 0 to disable logging, "onlyerr" to only log errors, anything else to enable logging

## function ammLog::TracingLog {

 Log xtrace as ammlog

## function ammLog::TracingEnable {

 Enable tracing 'set -x' into dedicated file

## function ammLog::WriteTerm {

 Log a message to the terminal (not through stdout). Only if session is interactive

### Arguments

* $1  (string) message to be written

## function ammEnv::PathAdd {

 Add a path to PATH

### Arguments

* $1  (string)(optionnal). Can be "before" or "after" (default)
* $@  (path[]) List of paths to be added to the env var

## function ammEnv::LibAdd {

 Add a path to LD_LIBRARY_PATH

### Arguments

* $1  (string)(optionnal). Can be "before" or "after" (default)
* $@  (path[]) List of paths to be added to the env var

## function ammEnv::ManAdd {

 Add a path to MANPATH

### Arguments

* $1  (string)(optionnal). Can be "before" or "after" (default)
* $@  (path[]) List of paths to be added to the env var

## function ammEnv::IsFunc {

 Check if given name is a function

### Exit codes

* **0**:  is a function
* **1**:  is not a function

## function ammEnv::IsVar {

 Check if name if a variable

### Exit codes

* **0**:  is a defined variable
* **1**:  is not a variable

## function ammPath::Decompose {

 Decompose a path to a list of all its folders

### Arguments

* $1  (path) The path to decompose

## function ammPath::IsSecure {

 Check if the full path of a file is secure for the current user

### Arguments

* $1  (path) File or folder to check

### Exit codes

* **0**:   Path is secure
* >=**1**:  Path has a number of insecurities, shown as stdout

## function ammPath::IsWritable {

 Check if we can create the requested path

### Arguments

* $1  (path) File or folder to check

### Exit codes

* **0**:  Path is writable

## function ammPath::IsEmpty {

 Check if a folder contains something

### Arguments

* $1  (path) Path to the folder to check

## function _ammPath::RecurseFolders {

 Copy a selection of files with their relative structure

### Arguments

* $1  (path) Source path where to find the content
* $2  (path) Destination path where to copy content
* $@  (string) files or patterns to copy from source to destination

## function ammPath::CopyStructure {

 Copy a structure to another

### Arguments

* $1

## function ammExec::AsUser {

 Execute a command as a different user

### Arguments

* $1  (string) User to run the command as
* $@  (string) the command to run, and its arguments. if "-", command is read from stdin

## function ammExec::Exists {

 Check if one or more command are available in PATH

### Arguments

* $@  (string) the executables to search for

### Exit codes

* **0**: if all are found
* **1**: if at least one is not found

## function ammExec::RequestOne {

 Check if at least one given command is available in PATH

### Arguments

* $@  (string) the executables to search for

### Exit codes

* **0**: if at least one is found
* **1**: if none are found

## function ammExec::Require {

 Same as ammExecExists but calls ammLog::Die and terminate the script if any requested binary is not found

### Arguments

* $@  (string) Binaries to search for in PATH

## function ammExec::RequireOne {

 Same as ammExecRequestOne but calls ammLog::Die and terminates if none of requested binary is found

## function ammExec::IsExecutable {

 Check if provided path is executable

### Arguments

* $1  Path to the file to be tested

