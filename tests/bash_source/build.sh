#!/usr/bin/env bash

typeset MYSELF="$(readlink -e $0 || realpath $0)"
typeset MYPATH="${MYSELF%/*}"

# Load main library
typeset -a ammpaths=("$MYPATH/ammlib" "$HOME/.ammlib" "/etc/ammlib" "$MYPATH/../../ammlib")
for ammpath in "${ammpaths[@]}" fail; do
	[[ -e "$ammpath/ammlib" ]] && source "$ammpath/ammlib" && break
done
if [[ "$ammpath" == "fail" ]]; then
	echo >&2 "Unable to find ammlib in paths '${ammpaths[@]}'"
	echo >&2 "Download it with 'git clone https://github.com/Saruspete/ammlib.git $MYPATH'"
	exit 1
fi

typeset -a BASH_BUILD_VERS=(4.2 4.3 4.4 5.0 5.1)

# Load the required libraries
#ammLib::Require "optparse"
ammLib::Require "http" "optparse"

ammOptparse::AddOptGroupDesc "Build parameters"
ammOptparse::AddOpt "-b|--build-vers@"    "Versions to download and build"

ammOptparse::Parse --no-unknown || ammLog::Die "Error during option parsing"


typeset -a BASH_BUILD_VERS2="$(ammOptparse::Get "build-vers")"
[[ -n "${BASH_BUILD_VERS2}" ]] && BASH_BUILD_VERS=(${BASH_BUILD_VERS2[@]})


typeset srcroot="$MYPATH/src"
typeset bldroot="$MYPATH/build"
typeset dstroot="$MYPATH/release"

[[ -d "$srcroot" ]] || mkdir -p "$srcroot"


for bashv in ${BASH_BUILD_VERS[@]}; do

	if [[ -x "$dstroot/bash-$bashv/bin/bash" ]]; then
		ammLog::Inf "Bash $bashv already compiled"
		continue
	fi

	ammLog::StepBegin "Building bash $bashv"

	# Download
	typeset url="$(ammHttp::GithubArchiveGetUrl "bminor/bash" "bash-$bashv")"
	typeset tar="$srcroot/${url##*/}"
	if ! [[ -s "$tar" ]]; then
		ammLog::Inf "Downloading sources from '$url'"
		ammHttp::Fetch "$url" "$tar"
	fi

	# Extract
	typeset bld="$bldroot/bash-$bashv"
	mkdir -p "$bld"
	ammLog::Inf "Extracting sources to '$bld'"
	tar xf "$tar" -C "$bld" --strip-components=1

	# Build
	(
		cd "$bld"
		typeset dst="$dstroot/bash-$bashv"
		[[ -d "$dst" ]] || mkdir -p "$dst"

		ammLog::Inf "Configuring"
		./configure --prefix="$dst" 2>&1 | ammLog::Dbg "-"

		ammLog::Inf "Building"
		make -j 2>&1 | ammLog::Dbg "-"

		ammLog::Inf "Installing in '$dst'"
		make install | ammLog::Dbg "-"
	)

	ammLog::StepEnd $?
done
