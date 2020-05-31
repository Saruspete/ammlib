
* [ammString::IsInteger](#ammStringIsInteger)
* [ammString::ExtractCmdline](#ammStringExtractCmdline)
* [ammString::UnitConvert](#ammStringUnitConvert)
* [ammString::BaseConvert](#ammStringBaseConvert)
* [ammString::HexToDec](#ammStringHexToDec)
* [ammString::DecToHex](#ammStringDecToHex)
* [ammString::IPv4ToHex](#ammStringIPv4ToHex)
* [ammString::HexToIPv4](#ammStringHexToIPv4)
* [ammString::Filter](#ammStringFilter)
* [ammString::CountWords](#ammStringCountWords)
* [ammString::CountLines](#ammStringCountLines)
* [ammString::SortWords](#ammStringSortWords)
* [ammString::ListExpand](#ammStringListExpand)
* [ammString::Repeat](#ammStringRepeat)


## ammString::IsInteger

@description: Check if the string is an integer. Optionnaly, check its value
### Arguments

* $1  (string) The string to check if it's an int
* $2  (int) The minimal value of the integer
* $3  (int) The maximal value of the integer

## ammString::ExtractCmdline

 Clean a multi-line cmd (with \ at the end)

### Arguments

* $1  (string) The string to extract cmdline from

## ammString::UnitConvert

 Convert an unit
function ammString::UnitConvert {
## ammString::BaseConvert

	typeset value="$1"
	typeset unitsrc="${2:-}"
	typeset unitdst="${3:-}"


	typeset -i base=1024 coef=1 mult=1 div=1
	typeset useBc=false powOp="*"
	typeset out=""

Compound unit
	typeset basesrc="${unitsrc:(-1)}"
	typeset basedst="${unitdst:(-1)}"

If we have a different base...
	if [[ "$basesrc" != "$basedst" ]]; then
bit to byte: /8
		if [[ "$basesrc" == "b" ]]; then
			div=8
byte to bit: *8
		else
			mult=8
		fi
	fi

	typeset -i pow=$(ammString::UnitToPow "${unitsrc:0:1}" "${unitdst:0:1}" )

For very high values, bash will overflow
	if [[ $pow -gt 6 ]]; then
		useBc=true
		ammLog::Dbg "Exponant '$pow' is > 6, using bc for calculation"
	fi

Negative power, division
	if [[ $pow -lt 0 ]]; then
		powOp="/"
		pow="$(( $pow * -1 ))"
	fi

	ammLog::Dbg "Converting $unitsrc to $unitdst: $base**$pow * $mult / $div"

Using bc for high values
	if $useBc; then
		out="$(echo "$value $powOp $base^$pow * $mult / $div" | bc)"
or just plain bash
	else
		out="$(( $value $powOp $base**$pow * $mult / $div))"
	fi

	echo "$out"

	if [[ -z "$out" ]] || [[ "$out" == "0" ]]; then
		return 1
	fi
	return 0
}

function ammString::BaseConvert {
## ammString::HexToDec

	typeset -i basesrc=$1
	typeset -i basedst=$2
	typeset number=$3

Stupid but quick
	if [[ "$basesrc" == "$basedst" ]]; then
		echo $number

#	# (<=64) => 10 # commented as fuck up the vim parsing
#	elif [[ $basedst == 10 ]] && [[ $basesrc -le 64 ]]; then
#		echo $(( $basesrc#$number ))
16 => 10: pure bash
	elif [[ $basesrc -le 16 ]]; then
Beware to order of obase/ibase !
		echo "obase=$basedst; ibase=$basesrc; $number" | bc
		return $?
	else
		ammLog::Err "Cannot convert from $basesrc to $basedst"
		return 1
	fi
}



function ammString::HexToDec {
## ammString::DecToHex

	ammString::BaseConvert 16 10 $1
}
function ammString::DecToHex {
## ammString::IPv4ToHex

	ammString::BaseConvert 10 16 $1
}

function ammString::IPv4ToHex {
## ammString::HexToIPv4

	typeset ipv4str="$1"

	typeset ipset strhex
	for ipset in ${ipv4str//./ }; do
		strhex+="$(ammString::DecToHex $ipset)"
	done

	echo $strhex
}
function ammString::HexToIPv4 {
## ammString::Filter

	typeset strhex="$1"
	if [[ "${#strhex}" != 8 ]]; then
		ammLog::Wrn "Calling $FUNCNAME with arg length != 8"
		return 1
	fi

	typeset i ip4str=""
	for ((i=0; i<8; i+=2)); do
		ip4str+="${ip4str:+.}$(ammString::HexToDec ${strhex:$i:2})"
	done

	echo $ip4str
}

-----------------------------------------------------------------------------
Search and filter
-----------------------------------------------------------------------------
function ammString::Filter {
## ammString::CountWords

	typeset filterline="${1:-.+}"
	typeset filtercolumn="${2:-}"
	typeset displaycolumn="${3:-0}"
	typeset file="${4:-}"

	ammLog::Dbg "fl=$filterline fc=$filtercolumn dc=$displaycolumn file=$file"
	awk -v fl="$filterline" -v fc="$filtercolumn" -v dc="$displaycolumn" '
Line matching
		match($0, fl) {
Seek the column matching
			for (i=1; i<=NF; i++) {
				if (length(fc) && ! match($i, fc))
					continue

Display column relative to the finding
				if (substr(dc,0,1) ~ /[+-]/)
					print $( i + dc )
Absolute column. Default to the whole line ($0)
				else
					print $dc
				break
			}
		}' "$file" | tr -cd '\t\n [:print:]'
}

-----------------------------------------------------------------------------
Counting
-----------------------------------------------------------------------------
function ammString::CountWords {
## ammString::CountLines

	typeset -a arr=($@)
	echo ${#arr[@]}
}

function ammString::CountLines {
## ammString::SortWords

	typeset input="$1"

	typeset wcout=""

	if [[ -e "$input" ]]; then
		wcout="$(wc -l $input)"

	else
		wcout="$(echo "$input" | wc -l)"
	fi

	echo ${wcout%% *}
}

-----------------------------------------------------------------------------
Sorting
-----------------------------------------------------------------------------
function ammString::SortWords {
## ammString::ListExpand

	for w in "$@"; do
		echo "$w"
	done | sort | tr '\n' ' '
}

-----------------------------------------------------------------------------
Advanced format parsers
-----------------------------------------------------------------------------

function ammString::ListExpand {
## ammString::Repeat

	typeset    listFull=""
	typeset -i err=0

Using a simple indexed array allows final ordering
	typeset -a values

	typeset elem group
	for elem in "$@"; do
Split the g1,g2,g3 parts
		for group in ${elem//,/ }; do
Split the groups (if any)
			typeset bgn="${group%-*}"
			typeset end="${group#*-}"

Some checks
			[[ -z "$bgn" ]] && {
				ammLog::Wrn "List begin element '$bgn' (in group '$group') cannot be empty. Skipping"
				continue
			}
			[[ -z "$end" ]] && {
				ammLog::Wrn "List end element '$end' (in group '$group') cannot be empty. Skipping"
				continue
			}

			! ammString::IsInteger "$bgn" && {
				ammLog::Wrn "List element '$bgn' (in group '$group' in element '$elem') is not an integer. Skipping"
				continue
			}
			! ammString::IsInteger "$end" && {
				ammLog::Wrn "List element '$end' (in group '$group' in element '$elem') is not an integer. Skipping"
				continue
			}

Different int values means a group like "start-end"
			if [[ "$bgn" != "$end" ]]; then
				typeset -i i=$bgn

We may want begin/end to be in ascending order.. or just swap them
				[[ $bgn -gt $end ]] && {
					i=$end
					end=$bgn
				}

				while [[ $i -lt $end ]]; do
					values[$i]=$i
					i+=1
				done

Same, so no group, just the same value
			else
				values[$bgn]=$bgn
			fi
			:
		done
	done

Show the final unique listing in a single echo
	echo ${!values[@]}
}

-----------------------------------------------------------------------------
Pretty print and display helpers
-----------------------------------------------------------------------------
function ammString::Repeat {
