
* [function _ammOptparse::Expand {](#function-ammoptparseexpand-)
* [function ammOptparse::_GroupEnabled {](#function-ammoptparsegroupenabled-)
* [function ammOptparse::_GroupIsMod {](#function-ammoptparsegroupismod-)
* [function ammOptparse::AddOptGroup {](#function-ammoptparseaddoptgroup-)
* [function ammOptparse::AddOptGroupDesc {](#function-ammoptparseaddoptgroupdesc-)
* [function ammOptparse::AddOpt {](#function-ammoptparseaddopt-)
* [function ammOptparse::AddActionWord {](#function-ammoptparseaddactionword-)
* [function ammOptparse::Require {](#function-ammoptparserequire-)
* [function ammOptparse::Parse {](#function-ammoptparseparse-)
* [function ammOptparse::Get {](#function-ammoptparseget-)
* [function ammOptparse::GetUnparsedOpts {](#function-ammoptparsegetunparsedopts-)
* [function ammOptparse::Help {](#function-ammoptparsehelp-)


## function _ammOptparse::Expand {

Expand short options and var=val to independant elements

## function ammOptparse::_GroupEnabled {

  Checks if the group is enabled

### Arguments

* $1  (string) ID of the group

## function ammOptparse::_GroupIsMod {

 Checks if the group is named as a module

### Arguments

* $1  (stringà ID of the group

## function ammOptparse::AddOptGroup {

 Create a new group for options being added next

### Arguments

* $1  (string) ID of the group to be acted upon by later functions
* $2  (string) (optionnal) Description of the group
* $3  (string) (optionnal) Availability: default or condition for the group to be usable

## function ammOptparse::AddOptGroupDesc {

 Set the description group for the options added next

### Arguments

* $1  (string) Description of the group

## function ammOptparse::AddOpt {

 Add an option to the listing

### Arguments

* $1  (string) Options to handle, separated by '|'
* $2  (string) Description for the help
* $3  (string) Default value. Can be made from another option as "%{optname}"
* $4  (string) Validation function

## function ammOptparse::AddActionWord {

Add one or more words that will infer on the parsing

### Arguments

* $1  (string) action for the words. Can be 'skip', 'break', 'continue' or a function name
* $@  (string) words to handle

## function ammOptparse::Require {

 Require one or more options to have a value

### Arguments

* $@  (string) options to require

## function ammOptparse::Parse {

 Parse the options, optionnally only those matching the prefix $1

### Arguments

* $@  (string) Prefix

## function ammOptparse::Get {

Get value for a parameter that was parsed

### Arguments

* $1  (string) A short, long or id option value

## function ammOptparse::GetUnparsedOpts {

Get unparsed options. To be used as 'eval set -- $(ammOptparse::GetUnparsedOpts)'

## function ammOptparse::Help {

Generate the help from registered options

### Arguments

* $1  (string) (optionnal) Show only enabled options (default) or all

