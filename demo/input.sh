#!/usr/bin/env bash

set -o nounset
set -o noclobber

export LC_ALL=C
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:$PATH"

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"

. $MYPATH/../ammlib

ammLib::Require input optparse

ammInput::Register "toto"
ammInput::Register "hostname" "Hostname of target machine" "localhost" "ammInput::ValidateHost"
ammInput::Register "age" "Whats the age of the captain" "666" "ammInput::ValidateInt"

ammOptparse::Parse

echo "toto = $(ammInput::Get "toto")"
echo "host = $(ammInput::Get "hostname")"
echo "titi = $(ammInput::Get "titi" "Any non empty value" "" "" "ammInput::ValidateNotEmpty")"
echo "lvm  = $(ammInput::Get "rd.lvm.lv" "LVM LV To activate" "" "" "ammInput::ValidateNotEmpty")"

echo "Done. Try to call this script again with '--input-blueprint' to see its blueprint"
