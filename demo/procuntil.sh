#!/usr/bin/env bash

set -o nounset
set -o noclobber

export LC_ALL=C
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:$PATH"
export PS4=' (${BASH_SOURCE##*/}::${FUNCNAME[0]:-main}::$LINENO)  '

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"

. $MYPATH/../ammlib

ammLib::Require network process

ammLog::Inf "Will try to connect to 127.0.0.1:1112, every second, up to 30 times"
ammLog::Inf "You can exec: 'nc -l 1112' to make it listen"

ammProcess::Until "ammNetworkPortOpen 127.0.0.1 1112 1" 30 1
case $? in
	0)  ammLog::Inf "Connection successful" ;;
	*)  ammLog::Err "Unable to connect after timeout" ;;
esac

