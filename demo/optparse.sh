#!/usr/bin/env bash

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"

source "$MYPATH/../ammlib"

ammLib::Require optparse string

ammOptparse::AddOptGroupDesc "Generic options"
ammOptparse::AddOpt "-v|--version"  "Show the version and exits"

ammOptparse::AddOptGroupDesc "Simple values"
ammOptparse::AddOpt "-d|--default=" "Default value"                "HelloThere"
ammOptparse::AddOpt "-a|--add="     "Option that must be set once" "%{default}" "ammString::IsYesNo"
ammOptparse::AddOpt "--marvelous="  "Are you fucking marvelous ?" "Dunno" "ammString::IsYesNo"
ammOptparse::AddOpt "-l|--long="    "This is an option with a long description to show the clipping of the text on multiple lines according to the screen width"

ammOptparse::AddOptGroupDesc "Complex values (array and boolean)"
ammOptparse::AddOpt "-A|--arr@"     "Push values into an array"
ammOptparse::AddOpt "-D|--debug!"   "Set or unset the debug mode"

ammOptparse::AddSpecialWord "woot"


if ! ammOptparse::Parse --no-unknown; then
	ammLog::Err "Parsing error. Please check"
	ammOptparse::Help
	exit 1
fi



typeset    val="$(ammOptparse::Get "add")"
typeset -a arr=$(ammOptparse::Get "A")
typeset    dbg="$(ammOptparse::Get "debug")"
typeset    mrv="$(ammOptparse::Get "marvelous")"

echo "--add = '$val'"
echo "--debug = '$dbg'"
echo "--marvelous = '$mrv'"

echo -n "--arr = ("
for i in "${!arr[@]}"; do echo -n "$i='${arr[$i]}'  "; done
echo ")"

echo "Remaining unparsed elements:"
eval set $(ammOptparse::GetUnparsedOpts)
for i in "$@"; do
	echo "- '$i'"
done
