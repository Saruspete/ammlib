#!/usr/bin/env bash

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"

source "$MYPATH/../ammlib"

ammLib::Require "optparse" "string"

# ActionWords with "continue" will add words to be ignored, even with option "--no-unknown"
# This allows to keep secure option parsing, while allowing deferred action processing
# If you provide
ammOptparse::AddActionWord "continue" "start" "stop" "status"
# If you 
ammOptparse::AddActionWord "break" "stophere"


# We're creating a new group, but just care about the description
ammOptparse::AddOptGroupDesc "Generic options"
ammOptparse::AddOpt "-v|--version"  "Show the version and exits"

ammOptparse::AddOptGroupDesc "Simple values"
ammOptparse::AddOpt "-d|--default=" "Default value"                "HelloThere"
ammOptparse::AddOpt "-a|--add="     "Option that must be set once" "%{default}" "ammString::IsYesNo"
ammOptparse::AddOpt "--marvelous="  "Are you fucking marvelous ?" "Dunno" "ammString::IsYesNo"
ammOptparse::AddOpt "-l|--long="    "This is an option with a long description to show the clipping of the text on multiple lines according to the screen width"

# Group
ammOptparse::AddOptGroupDesc "Complex values (array and boolean)"
# Arrays can be provided multiple times
ammOptparse::AddOpt "-A|--arr@"     "Push values into an array"     "arrVal1§§arrVal2§§val with spaces"
# Boolean options also creates their negated option, like "--no-debug" here"
ammOptparse::AddOpt "-D|--debug!"   "Set or unset the debug mode"

# Named Groups (Group vs GroupDesc) allow to do actions on all actions, like hide or disable them
ammOptparse::AddOptGroup "hidden-group1" "This group is hidden, unless 'woot' action is provided" "word:status"
ammOptparse::AddOpt "--hidden="     "This option is only visible in --help if 'status' is provided"

# Within a descriptive group, you can create 'secret' groups if you don't provide them a description
ammOptparse::AddOptGroupDesc "Visible group after hidden group"
ammOptparse::AddOpt "--foobar"      "A sample value always visible"
# By setting the 3rd option to "no", all options in this group are hidden
ammOptparse::AddOptGroup "disabledgroup" "" "no"
ammOptparse::AddOpt "--foodisabled" "This option is disabled by default" "no"
# But you can also stop propagation of the disabled property by creating another one
ammOptparse::AddOptGroup "anyothergroup"
ammOptparse::AddOpt "--fooenabled"  "This option is enabled"



# Can also be simplified as:
# ammOptparse::Parse --no-unknown || ammLog::Die "Parsing error. Please check previous errors. Use --help to for more details"
#if ! ammOptparse::Parse --no-unknown; then
if ! ammOptparse::Parse ; then
	ammLog::Error "Parsing error. Please check"
	ammOptparse::Help
	exit 1
fi

# Set the "$@" args with the unparsed elements
eval set -- $(ammOptparse::GetUnparsedOpts)



# Standard options
typeset    val="$(ammOptparse::Get "add")"
typeset    mrv="$(ammOptparse::Get "marvelous")"
# bool options are like standard
typeset    dbg="$(ammOptparse::Get "debug")"
# Arrays doesn't have quotes to keep the array values
typeset -a arr=$(ammOptparse::Get "A")

# Required options
echo "--add = '$val'"
echo "--debug = '$dbg'"
echo "--marvelous = '$mrv'"

# Show the array
echo -n "--arr = ("
for i in "${!arr[@]}"; do
	echo -n "$i='${arr[$i]}'  "
done
echo ")"

echo
echo "Show all configured options and their value"
for i in $(ammOptparse::GetAllOpts); do
	echo "  - $i = $(ammOptparse::Get "$i")"
done


echo
echo "Remaining unparsed elements, iterated with standard '\$@' or '\$*'"
for i in "$@"; do
	echo "- '$i'"
done
