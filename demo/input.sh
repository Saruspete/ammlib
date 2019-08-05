#!/usr/bin/env bash

set -o nounset
set -o noclobber

export LC_ALL=C
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:$PATH"

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"

. $MYPATH/../ammlib

ammLibRequire input

ammInputRegister "toto"
ammInputRegister "hostname" "Hostname of target machine" "localhost" "ammInputValidateHost"
ammInputRegister "age" "Whats the age of the captain" "666" "ammInputValidateInt"

ammInputPopulate
ammInputPopulate cmdline ""

ammInputBatch AutoTry
#ammInputBatch +DieOnErr

echo toto = $(ammInputGet "toto")
echo titi = $(ammInputGet "titi" "Any non empty value" "" "" "ammInputValidateNotEmpty")
echo host = $(ammInputGet "hostname")
echo lvm  = $(ammInputGet "rd.lvm.lv" "LVM LV To activate" "" "" "ammInputValidateNotEmpty")

ammInputBlueprint
