
* [function ammString::IsInteger {](#function-ammstringisinteger-)
* [function ammString::ExtractCmdline {](#function-ammstringextractcmdline-)
* [function ammString::UnitConvert {](#function-ammstringunitconvert-)
* [function ammString::Filter {](#function-ammstringfilter-)
* [function ammString::ExpandStringBash {](#function-ammstringexpandstringbash-)
* [function ammString::UUIDGenerate {](#function-ammstringuuidgenerate-)


## function ammString::IsInteger {

Check if the string is an integer. Optionnaly, check its value

### Arguments

* $1  (string) The string to check if it's an int
* $2  (int) The minimal value of the integer
* $3  (int) The maximal value of the integer

## function ammString::ExtractCmdline {

 Clean a multi-line cmd (with \ at the end)

### Arguments

* $1  (string) The string to extract cmdline from

## function ammString::UnitConvert {

 Convert an unit

## function ammString::Filter {

 Filter a file to filter lines and columns

### Arguments

* $1  (file)  File to filter, or - for stdin
* $2  (regex) Keep lines matching this regex
* $3  (regex) Keep columns 
* $4  (int)   Column number, or offset to the matched column if starting by + or -

## function ammString::ExpandStringBash {

Expand a composite list to its full expression

## function ammString::UUIDGenerate {

 Generate a UUID depending on the version requested

