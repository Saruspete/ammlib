#!/usr/bin/env bash

set -o nounset
set -o noclobber

export LC_ALL=C
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:$PATH"

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"

. $MYPATH/../ammlib

ammLib::Require input

ammInput::Register "toto"
ammInput::Register "hostname" "Hostname of target machine" "localhost" "ammInputValidateHost"
ammInput::Register "age" "Whats the age of the captain" "666" "ammInputValidateInt"

ammInput::Populate
ammInput::Populate cmdline ""

ammInput::Batch AutoTry
#ammInput::Batch +DieOnErr

echo toto = $(ammInput::Get "toto")
echo titi = $(ammInput::Get "titi" "Any non empty value" "" "" "ammInputValidateNotEmpty")
echo host = $(ammInput::Get "hostname")
echo lvm  = $(ammInput::Get "rd.lvm.lv" "LVM LV To activate" "" "" "ammInputValidateNotEmpty")

ammInput::Blueprint
