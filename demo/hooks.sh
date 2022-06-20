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


# Sample hook registration
ammLib::HookRegister mycb testcb mycb
ammLib::HookRegister libload testcb libload

ammLib::Require string

ammLib::HookTrigger mycb "Hello I've triggered mycb"



#
# Let's register a hook, when called will register another hook, and again.
# Usage: Load a generic library, do early parsing to know what sub-library to load
#        That sub-library may also want to load other elements (like optparse options)
#
function cbLink1 {
	typeset myevent="$1"
	ammLib::HookRegister "$myevent" cbLink2 "$myevent"
	echo "$FUNCNAME registered cbLink2"
}
function cbLink2 {
	typeset myevent="$1"
	ammLib::HookRegister "$myevent" cbLink3 "$myevent"
	echo "$FUNCNAME registered cbLink3"
}
function cbLink3 {
	echo "cbLink3 has been called !"
}

# Hooks that registers on the same hook
ammLib::HookRegister myEvent cbLink1 "myEvent"
ammLib::HookTrigger  myEvent "Generated myEvent"


