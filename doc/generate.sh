#!/usr/bin/env bash

set -o nounset
set -o noclobber

export LC_ALL=C
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:$PATH"
export PS4=' (${BASH_SOURCE##*/}::${FUNCNAME[0]:-main}::$LINENO)  '

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"
readonly ROOTPATH="$(readlink -f $MYPATH/..)"

typeset SHDOC="$MYPATH/shdoc/shdoc"


for file in $ROOTPATH/ammlib $ROOTPATH/lib/*.lib; do
	$SHDOC "$file" >| "$MYPATH/doc/${file##*/}.md"
done
