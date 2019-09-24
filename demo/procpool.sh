#!/usr/bin/env bash

set -o nounset
set -o noclobber

export LC_ALL=C
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:$PATH"
export PS4=' (${BASH_SOURCE##*/}::${FUNCNAME[0]:-main}::$LINENO)  '

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"

. $MYPATH/../ammlib

ammLib::Require "process"


ammProcess::PoolCreate "toto"

for i in {1..9}; do
	ammProcess::PoolTaskAdd "toto" "sleep $i"
done

ammProcess::PoolStart "toto" 2 7
