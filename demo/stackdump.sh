#!/usr/bin/env bash

set -o nounset
set -o noclobber

export LC_ALL=C
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:$PATH"
export PS4=' (${BASH_SOURCE##*/}::${FUNCNAME[0]:-main}::$LINENO)  '

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"

. $MYPATH/../ammlib


function subfunc {
	ammLog::Stackdump "$@"
}

function mainfunc {
	subfunc "$@"
}


echo "== Full Stack"
mainfunc
echo "== Stack starting at 1"
mainfunc 1
echo "== Stack starting at 2 and only 1 back"
mainfunc 2 1

