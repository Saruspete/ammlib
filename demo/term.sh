#!/usr/bin/env bash

set -o nounset
set -o noclobber

export LC_ALL=C
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:$PATH"

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"

. $MYPATH/../ammlib

ammLib::Require "term"


ammLog::EchoSeparator "Standard colors"

for color in black red green yellow blue magenta cyan white; do
	for target in "" "light" "bg" "bglight"; do
		printf "%8.8s %8.8s" "$color" "$target"

		for mod in "" bold dim italic underline underlinedouble blink reverse strikethrough; do
			ammLog::Color "${target}${color}" "$mod"
			#printf "%-16.16s" "$mod"
			printf " %s " "$mod"
			ammLog::Color "reset${mod}"
		done

		ammLog::Color reset
		echo

	done
done


ammLog::EchoSeparator "True colors"

if ammLog::TrueColorAvailable; then
	typeset -i red=0
	while [[ $red -lt 255 ]]; do
		typeset -i green=0
		while [[ $green -lt 255 ]]; do
			typeset -i blue=0
			while [[ $blue -lt 255 ]]; do
				ammLog::Color "rgbbg:$red:$green:$blue"
				echo -n "  "
				blue+=10
			done
			green+=10
			ammLog::Color reset
			echo
		done
		red+=10
		echo
	done

else
	echo "Not supported by your terminal"
fi

