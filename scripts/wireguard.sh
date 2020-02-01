#!/usr/bin/env bash

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"

. "$MYPATH/../ammlib"

ammLib::Require "table" "optparse" "string"

ammOptparse::AddOpt "-p|--private!" "Show private key too" "false"
ammOptparse::Parse

typeset showpriv="$(ammOptparse::Get "private")"

function _wgSize {
	typeset size="$1"
	[[ -z "$size" ]] && return
	ammString::UnitConvert "$size" "K" "M"
}
function _wgTimestamp {
	typeset ts="$1"
	[[ -z "$ts" ]] && return

	echo $(( $(date +%s) - $ts))
}

function wgStatus {
	typeset iface="${1:-all}"

	typeset privkeyopts=""
	$showpriv || privkeyopts=",hidden"

	typeset -a cols=(
		"Iface|size:10"
		"Public Key|size:46"
		"Private Key|size:46$privkeyopts"
		"Endpoint|size:32"
		"Allowed IPs|size:18"
		"HS sec ago|callback:_wgTimestamp"
		"MB Sent|callback:_wgSize"
		"MB Recv|callback:_wgSize"
		"Keepalive"
	)


	ammTable::Create "WireGuard Details" "${cols[@]}"
	ammTable::SetDisplayMode "direct"

	wg show $iface dump | ammTable::AddRow "-"

}


wgStatus
