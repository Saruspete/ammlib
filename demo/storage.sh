#!/usr/bin/env bash

set -o nounset
set -o noclobber

export LC_ALL=C
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:$PATH"

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"

. $MYPATH/../ammlib

ammLib::Require storage string


ammLog::Step "Available block-devices on system"
typeset blockdevs="$(ammStorage::ListAvail)"
echo $blockdevs

echo
ammLog::Step "Fetching more details on each of these block"
typeset fmt="%-15.15s %3.3s %3.3s %-10.10s %10.10s %-32.32s %-32.32s %-16.16s %s\n"
printf "$fmt" "block name" "maj" "min" "type" "size" "model" "serial" "firmware" "mountpoint"

typeset blockdev
for blockdev in $blockdevs; do
	typeset maj= min= typ= block= size= sizeReadable= model= serial= firmware= mnt=
	read maj min < <(ammStorage::GetMajorMinor $blockdev)
	size="$(ammStorage::GetSize $blockdev)"
	sizeReadable="$(ammString::UnitConvert "$size" "B" "MB") MB"
	typ="$(ammStorage::GetType $blockdev)"
	model="$(ammStorage::GetModel $blockdev)"
	serial="$(ammStorage::GetSerial $blockdev)"
	firmware="$(ammStorage::GetFirmware $blockdev)"
	mnt="$(ammStorage::GetMountpoint $blockdev)"

	printf "$fmt" "$blockdev" "$maj" "$min" "$typ" "$sizeReadable" "$model" "$serial" "$firmware" "$mnt"
done

ammLog::Step "Real block devices status"

