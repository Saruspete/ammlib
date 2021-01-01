#!/usr/bin/env bash

typeset MYSELF="$(readlink -e $0 || realpath $0)"
typeset MYPATH="${MYSELF%/*}"

# Change dir for shellspec
cd "$MYPATH"

# Load main library
typeset -a ammpaths=("$MYPATH/ammlib" "$HOME/.ammlib" "/etc/ammlib" "$MYPATH/../")
for ammpath in "${ammpaths[@]}" fail; do
	[[ -e "$ammpath/ammlib" ]] && source "$ammpath/ammlib" && break
done
if [[ "$ammpath" == "fail" ]]; then
	echo >&2 "Unable to find ammlib in paths '${ammpaths[@]}'"
	echo >&2 "Download it with 'git clone https://github.com/Saruspete/ammlib.git $MYPATH'"
	exit 1
fi

# Load the required libraries
#ammLib::Require "optparse"

typeset AMMTEST_BASH_ROOT="$MYPATH/bash_source"
typeset AMMTEST_SS_ROOT="$MYPATH/shellspec"

ammLog::StepBegin "Checking test requirements"

ammLog::StepBegin "Fetching all bash versions"
$AMMTEST_BASH_ROOT/build.sh
ammLog::StepEnd $?

ammLog::StepBegin "Fetching latest ShellSpec version"
$AMMTEST_SS_ROOT/build.sh
ammLog::StepEnd $?

ammLog::StepEnd


ammLog::StepBegin "Starting tests"
for bashpath in "$AMMTEST_BASH_ROOT/release/"*"/bin/bash"; do
	typeset bashversion="${bashpath%%*/bin/bash}"
	bashversion="${bashversion##*/}"
	typeset -i rb=0

	ammLog::StepBegin "Testing bash $bashversion"
	$AMMTEST_SS_ROOT/current/shellspec --shell "$bashpath"
	rb+=$?

	ammLog::StepEnd $rb
done
ammLog::StepEnd
