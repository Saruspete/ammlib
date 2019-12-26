#!/usr/bin/env bash

set -o nounset
set -o noclobber

export LC_ALL=C
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:$PATH"

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"

. $MYPATH/../ammlib

function testcb {
	typeset origin="$1"; shift
	echo "CB called for $origin: $@"
}


ammLib::HookRegister mycb testcb mycb
ammLib::HookRegister libload testcb libload


ammLib::Require string

ammLib::HookTrigger mycb "Hello I've triggered mycb"
