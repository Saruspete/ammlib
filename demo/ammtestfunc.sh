#!/usr/bin/env bash

set -o nounset
set -o noclobber

export LC_ALL=C
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:$PATH"

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"

. $MYPATH/../ammlib


[[ $# -lt 1 ]] && {
	echo "Usage: $0 <function> [args]"
	exit 0
}

typeset func="$1"; shift
typeset libname=""

# Allow to test private functions
libname="${func#_}"
# Remove the prefix
libname="${libname#amm}"
libname="${libname,}"

# And remove all trailing element from the first uppercase
libname="${libname%%::*}"


# If it's a sublib, we have one or more uppercase chars
if [[ "$libname" != "${libname,,}" ]]; then
	# Translates uppercase "C" chars by ".c"
	libname="$(echo "$libname"|sed -Ee 's/([A-Z])/.\L\1/g')"

	typeset libpref=""
	for parent in ${libname//./ }; do
		libpref+="$parent"
		ammLib::Require $libpref
		libpref+="."
	done
fi

# If the function is not declared, try to require it
if [[ "$(type -t $func 2>/dev/null)" != "function" ]]; then
	ammLib::Require "$libname"
fi

$func "$@"
