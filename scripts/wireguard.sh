#!/usr/bin/env bash

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"

. "$MYPATH/../ammlib"

ammLib::Require "table" "optparse"

ammOptparse::AddOpt "-p|--private!" "Show private key too" "false"
ammOptparse::Parse

typeset showpriv="$(ammOptparse::Get "private")"

function wgStatus {
	typeset iface="${1:-all}"

	typeset -a cols=(
		"Iface|size:10"
		"Public Key|size:46"
	)
	
	$showpriv && cols+=("Private Key|size:46")
	cols+=(
		"Endpoint|size:32"
		"Last Handshake"
		"KB Sent"
		"KB Received"
		"Keepalive"
	)


	ammTable::Create "WireGuard Details" "${cols[@]}"
	ammTable::SetDisplayMode "direct"

	# You can use the read per line assignment form for complex processing
	#typeset ifname pubkey privkey endpoint lasthandshake datasent datareceived keepalive _junk
	#while read ifname pubkey privkey endpoint lasthandshake datasent datareceived keepalive _junk; do
	#	$showpriv || privkey=""
	#	ammTable::AddRow "$ifname" "$pubkey" $privkey "$endpoint" "$lasthandshake" "$datasent" "$datareceived" "$keepalive"
	#done < <(wg show $iface dump);

	# Or this shortest form
	wg show $iface dump | awk -v show=$showpriv '{if(show=="false")$3=""; print}' | ammTable::AddRow "-"

}


wgStatus
