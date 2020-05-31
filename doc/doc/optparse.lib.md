
* [_ammOptparse::Expand](#_ammOptparseExpand)
* [ammOptparse::AddOptGroupDesc](#ammOptparseAddOptGroupDesc)
* [ammOptparse::AddOpt](#ammOptparseAddOpt)
* [ammOptparse::Parse](#ammOptparseParse)
* [ammOptparse::Get](#ammOptparseGet)
* [ammOptparse::Help](#ammOptparseHelp)


## _ammOptparse::Expand

@description: Expand short options and var=val to independant elements
function _ammOptparse::Expand {
## ammOptparse::AddOptGroupDesc

 Set the description group for the options added next
function ammOptparse::AddOptGroupDesc {
## ammOptparse::AddOpt

 Add an option to the listing
### Arguments

* $1  (string) Options to handle, separated by '|'
* $2  (string) Description for the help
* $3  (string) Default value. Can be made from another option as "%{optname}"
* $4  (string) Validation function

## ammOptparse::Parse

 Parse the options, optionnally only those matching the prefix $1
### Arguments

* $@  (string) Prefix

## ammOptparse::Get

@description: Get value for a parameter that was parsed
### Arguments

* $1  (string) A short, long or id option value

## ammOptparse::Help

@description: Generate the help from registered options
