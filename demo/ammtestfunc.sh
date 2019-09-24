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
libname="${func##*_}"
# Remove the prefix
libname="${libname#amm}"
# Lowercase the first char (should be package name)
libname="${libname,}"
# And remove all trailing element from the first uppercase
libname="${libname%%::*}"

ammLib::Require "$libname"

$func "$@"
