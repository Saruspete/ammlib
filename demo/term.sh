#!/usr/bin/env bash

set -o nounset
set -o noclobber

export LC_ALL=C
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:$PATH"

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"

. $MYPATH/../ammlib

ammLib::Require "term"

# References
#   https://github.com/Textualize/rich/blob/master/rich/__main__.py
#   https://gist.github.com/eabase/4e0444f790c45b2732aba49d61199e3a
#   https://github.com/python/cpython/blob/2.7/Lib/colorsys.py
#   https://gist.github.com/ashleysommer/5276c1137b45f9208b059e5cfd544966


function colorgenRainbow {
	typeset deg="${1:-0}"
	let h=$deg/43
	let f=$deg-43*$h
	let t=$f*255/43
	let q=255-$t

	#echo -e "\n($h $f $t $q)\n" 2>&1
	
	if [ $h -eq 0 ]; then
		echo "255:$t:0"
	elif [ $h -eq 1 ]; then
		echo "$q:255:0"
	elif [ $h -eq 2 ]; then
		echo "0:255:$t"
	elif [ $h -eq 3 ]; then
		echo "0:$q:255"
	elif [ $h -eq 4 ]; then
		echo "$t:0:255"
	elif [ $h -eq 5 ]; then
		echo "255:0:$q"
	else
		echo "0:0:0"
	fi
}
function colorgenRed   { echo "$1:0:0"; }
function colorgenGreen { echo "0:$1:0"; }
function colorgenBlue  { echo "0:0:$1"; }
function colorgenGray  { typeset i=$1; echo "$i:$i:$i"; }

function hsl_to_rgb {
	typeset h="$1"
	typeset s="$2"  # Saturation. 
	typeset l="$3"  # Lightness. 0 = black, 100 = white, 50 = color

	echo "$h $s $l" | awk -F "[, ]+" '\
	# Returns minimum number
	function abs(num) {
		if (num < 0.0)
			return num*-1.0
		return num
	}
	# Main function
	function to_rgb(H, S, L){
		H = H % 360.0
		S = abs(S)
		if (S < 0.0) S = 0.0
		if (S > 1.0) S = 1.0
		L = abs(L)
		if (L < 0.0) L = 0.0
		if (L > 1.0) L = 1.0
		C = (1.0-abs((2.0*L)-1.0))*S
		X = C*(1.0-abs(((H/60.0)%2.0)-1.0))
		m = L-(C/2.0)
		if (H >= 300.0) {
			Rp = C; Gp = 0.0; Bp = X
		} else if (H >= 240.0) {
			Rp = X; Gp = 0.0; Bp = C
		} else if (H >= 180.0) {
			Rp = 0.0; Gp = X; Bp = C
		} else if (H >= 120.0) {
			Rp = 0.0; Gp = C; Bp = X
		} else if (H >= 60.0) {
			Rp = X; Gp = C; Bp = 0.0
		} else {
			Rp = C; Gp = X; Bp = 0.0
		}
		R = (Rp+m) * 255.0
		G = (Gp+m) * 255.0
		B = (Bp+m) * 255.0
		print int(R+0.5)":"int(G+0.5)":"int(B+0.5)
	}
	# Script execution starts here
	{
		to_rgb($1*1.0, $2*1.0/100, $3*1.0/100)
	}'

}



function rainbowLine {
	typeset generator="$1"

	for col in {0..127}; do
		ammLog::Color "rgbbg:$($generator $col)"
		echo -n " "
	done

	ammLog::Color "reset"
	echo

	for col in {255..128}; do
		ammLog::Color "rgbbg:$($generator $col)"
		echo -n " "
	done
	ammLog::Color "reset"
	echo

}


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

	echo "Colorbox"
	typeset colMax="$COLUMNS" lineMax=10
	for line in $(seq $lineMax); do
		for colId in $(seq $colMax); do
			# Compute HLS (Hue Lightness Saturation)
			lineStep=$((100/$lineMax))
			colStep=$((360/$colMax))
			h=$(( $colId * $colStep ))
			s=$(( $line * $lineStep ))
			rgbbg="$( hsl_to_rgb "$h" "$s" "50")"
			rgb="$(   hsl_to_rgb "$h" "$(($s+ $colStep/2))" "50")"
			#echo "$h $l = $rgbbg / $rgb"
			ammLog::Color "rgbbg:$rgbbg" "rgb:$rgb"
			echo -n "▄"
		done
		ammLog::Color reset
		echo
	done
	echo
	echo

	# Rainbow line
	echo "Rainbow Lines"
	rainbowLine colorgenRainbow
	echo
	echo "Red / Green / Blue"
	rainbowLine colorgenRed
	rainbowLine colorgenGreen
	rainbowLine colorgenBlue
	rainbowLine colorgenGray
	echo


else
	echo "Not supported by your terminal"
fi

