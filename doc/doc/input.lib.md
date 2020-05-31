
* [ammInput::SetPrefix](#ammInputSetPrefix)
* [ammInput::Populate](#ammInputPopulate)
* [ammInput::Blueprint](#ammInputBlueprint)
* [ammInput::ValidateNotEmpty](#ammInputValidateNotEmpty)
* [ammInput::ValidateInteger](#ammInputValidateInteger)
* [ammInput::ValidateYN](#ammInputValidateYN)
* [ammInput::ValidateHost](#ammInputValidateHost)
* [ammInput::GetYN](#ammInputGetYN)
* [ammInput::GetPassword](#ammInputGetPassword)


## ammInput::SetPrefix

@description: 
function ammInput::SetPrefix {
## ammInput::Populate

	typeset pref="${1:-}"

#	if [[ -z "$pref" ]]; then
#		ammLog::Err "Prefix for input parsing cannot be empty"
#		return 1
#	fi

	__ammInputPrefix="$pref"
}

Populate the reply values from file, environment, options
function ammInput::Populate {
## ammInput::Blueprint

	typeset srcs="${1:-environment,options}"
	typeset prefix="${2-$__ammInputPrefix}"

Loop on all registered IDs
	typeset src
	for src in ${srcs//,/ }; do
		case $src in
Environment vars parsing
			environment)
parse and protect the prefix
				typeset pfx="${prefix^^}"
				pfx="${pfx//[.-]/_}"

I only want env var, not shell vars, as with ( set -o posix ; set )
				typeset var val
				while IFS='=' read var val; do
if current environment is matching our prefix
					if [[ "$var" = $pfx* ]]; then
						typeset id="${var#$pfx}"
						id="${id%%=*}"

Save parsed var
						__ammInputReplies[$id]="$val"
Map input with ID for replay, option style
						__ammInputIds[$id]="--$var"
					fi
				done < <(printenv)
				;;

Option parsing
			options)
				typeset -a args=()
				typeset pfx="$prefix"

Parse all options
				for optid in ${!__AMMLIB_CALLOPTS[@]}; do
					typeset var="${__AMMLIB_CALLOPTS[$optid]}"
					typeset orig="$var"

remove leading dash
					var="${var##--}"
if our option parsing can be done
					if [[ "$var" = $pfx* ]]; then
remove prefix and add reply
						typeset id="${var#$pfx}"
						id="${id%%=*}"
						typeset val="${var#*=}"
Save reply without prefix
						__ammInputReplies[$id]="$val"
Map input with ID for replay
						__ammInputIds[$id]="$orig"
					else
Push back elemenets as they are read
						args[${#args[@]}]="$var"
					fi
				done

Recreate the arguments, without our options
				#set - "${args[@]}"
				__AMMLIB_CALLOPTS=("${args[@]}")
				;;

From /proc/cmdline
			cmdline)
parse all options
				for arg in $(</proc/cmdline); do
					typeset var="${arg%%=*}"
					typeset val="${arg#*=}"

Prefix is required for filtering
					if [[ -n $prefix ]]; then
						if [[ "$var" = $prefix* ]]; then
							var="${var#$prefix}"
						else
No match with prefix, skip
							continue
						fi
					fi

					__ammInputReplies[$var]="$val"
					__ammInputIds[$var]="--kernel.$arg"
				done
				;;

			*)
				ammLog::Err "Unknown source type: '$src'"
				;;
		esac
	done

}

function ammInput::Blueprint {
## ammInput::ValidateNotEmpty


	typeset file="$__AMMLIB_DATATMP/input.blueprint"
	[[ -s "$file" ]] || return 0

	echo
	echo "Script Blueprint: You can replay this script with your filled values with:"
	echo "$__AMMLIB_CALLNAME ${__AMMLIB_CALLOPTS[@]} $(<$file)"
}

-----------------------------------------------------------------------------
Validation callbacks
-----------------------------------------------------------------------------

function ammInput::ValidateNotEmpty {
## ammInput::ValidateInteger

	typeset str="${1:-}"
	[[ -n "$str" ]]
}

function ammInput::ValidateInteger {
## ammInput::ValidateYN

	typeset str="${1:-}"
	[[ -z "$str" ]] && return 1
	[[ -z "${str//[0-9]/}" ]]
}

function ammInput::ValidateYN {
## ammInput::ValidateHost

	typeset str="${1:-}"
	ammString::IsYes "$str" || ammString::IsNo "$str"
}

function ammInput::ValidateHost {
## ammInput::GetYN

	typeset str="${1:-}"

	[[ -z "$str" ]] && return 1
	[[ ${#str} -gt 255 ]] && return 1
	[[ "${str:-1:1}" == "." ]] && return 1

Validation from RFC1123
	typeset IPv4Regex="^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"
	typeset HostRegex="^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$"

	[[ $str =~ $IPv4Regex ]] || [[ $str =~ $HostRegex ]]
}


-----------------------------------------------------------------------------
Getters with complex types
-----------------------------------------------------------------------------

function ammInput::GetYN {
## ammInput::GetPassword

	typeset id="$1"
	typeset prompt="$2"
	typeset default="${3:-no}"
	typeset readopts="${4:-}"

If a default value has been proposed, check it
	if [[ -n "$default" ]]; then
		if ammInput::ValidateYN "$default"; then
			ammLog::Dbg "Default input '$default' validated"
		else
			ammLog::Wrn "Invalid yes/no default input: '$default'"
			default=""
		fi
	fi

	typeset reply="$(ammInput::Get "$id" "$prompt [yes/no]" "$default" "$readopts" "ammInput::ValidateYN")"
check input
	ammString::IsYes "$reply"
	return $?
}

function ammInput::GetPassword {
