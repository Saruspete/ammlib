
* [function _ammConfig::FileValidate {](#function-ammconfigfilevalidate-)
* [function ammConfig::FilePathAdd {](#function-ammconfigfilepathadd-)
* [function ammConfig::FileLoad {](#function-ammconfigfileload-)
* [function ammConfig::FileSave {](#function-ammconfigfilesave-)
* [function ammConfig::FileTemplate {](#function-ammconfigfiletemplate-)


## function _ammConfig::FileValidate {

check if a file is valid

## function ammConfig::FilePathAdd {

 Add a custom search path to the folder list

## function ammConfig::FileLoad {

 Load a file

### Arguments

*  $1 (string)  Filename to load

## function ammConfig::FileSave {

 Save the current state to a configuration file

### Arguments

* $1  (string) Name of the file
* $@  (string) variables names to store (previously declared)

## function ammConfig::FileTemplate {

 Generate a configuration file with all available vars

### Arguments

*  $@  (string) Files to export variables from (overrides __AMMCONFIG_FILTER_FILE)

