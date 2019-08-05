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
typeset libname="${func#amm}"
libname="${libname,}"
libname="${libname%%[A-Z]*}"

ammLibRequire "$libname"

$func "$@"
