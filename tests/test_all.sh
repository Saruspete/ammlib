#!/usr/bin/env bash

typeset MYSELF="$(realpath $0)"
typeset MYPATH="${MYSELF%/*}"

# To ensure standard behavior between piped logs and standard runs
export AMMLIB_LOGTOSTDERR=1

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
typeset -i rglobal=0 rlocal=0

typeset AMMTEST_BASH_ROOT="$MYPATH/bash_source"
typeset AMMTEST_SS_ROOT="$MYPATH/shellspec"

ammLog::StepBegin "Checking test requirements"

ammLog::StepBegin "Fetching all bash versions"
$AMMTEST_BASH_ROOT/build.sh
rlocal=$?
rglobal+=$rlocal
ammLog::StepEnd $rlocal

ammLog::StepBegin "Fetching latest ShellSpec version"
# Use the devel version until a newer release than 0.28.1 is done, to have UseFD + my patch
$AMMTEST_SS_ROOT/build.sh --ss-version=devel
rlocal=$?
rglobal+=$rlocal
ammLog::StepEnd $rlocal

ammLog::StepEnd


ammLog::StepBegin "Starting tests"
for bashpath in "$(ammExec::GetPath "bash")" "$AMMTEST_BASH_ROOT/release/"*"/bin/bash"; do
	typeset bashversion="${bashpath%*/bin/bash}"
	bashversion="${bashversion##*/}"
	[[ -z "$bashversion" ]] && bashversion="system provided bash"

	ammLog::StepBegin "Testing $bashversion ($bashpath)"
	$AMMTEST_SS_ROOT/current/shellspec --shell "$bashpath"
	rlocal=$?
	rglobal+=$rlocal

	ammLog::StepEnd $rlocal
done
ammLog::StepEnd

exit $rglobal
