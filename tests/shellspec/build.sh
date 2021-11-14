#!/usr/bin/env bash

typeset MYSELF="$(readlink -e $0 || realpath $0)"
typeset MYPATH="${MYSELF%/*}"

#set -o nounset -o noclobber
#export LC_ALL=C
#export PATH="/bin:/sbin:/usr/bin:/usr/sbin:$PATH"
#export PS4=' (${BASH_SOURCE##*/}::${FUNCNAME[0]:-main}::$LINENO)  '

# Load main library
typeset -a ammpaths=("$MYPATH/ammlib" "$HOME/.ammlib" "/etc/ammlib" "$MYPATH/../..")
for ammpath in "${ammpaths[@]}" fail; do
	[[ -e "$ammpath/ammlib" ]] && source "$ammpath/ammlib" && break
done
if [[ "$ammpath" == "fail" ]]; then
	echo >&2 "Unable to find ammlib in paths '${ammpaths[@]}'"
	echo >&2 "Download it with 'git clone https://github.com/Saruspete/ammlib.git $MYPATH'"
	exit 1
fi

# Load the required libraries
ammLib::Require "optparse" "http"

typeset SS_VERSION="latest"
typeset SS_DESTDIR="$MYPATH"
typeset -i rglobal=0

ammOptparse::AddOpt "--ss-version="  "ShellSpec version to download"  "latest"
ammOptparse::AddOpt "--ss-destdir="  "ShellSpec destination dir"      "$SS_DESTDIR"

ammOptparse::Parse --no-unknown || ammLog::Die "Error while parsing options"

SS_VERSION="$(ammOptparse::Get "ss-version")"
SS_DESTDIR="$(ammOptparse::Get "ss-destdir")"

# Try to get the latest version if needed
[[ "$SS_VERSION" == "latest" ]] && SS_VERSION="$(ammHttp::GithubReleaseGetLatest "shellspec/shellspec")"

# Check version
[[ -z "$SS_VERSION" ]] && ammLog::Die "Invalid ShellSpec version '$SS_VERSION'"

typeset ss_extract="$SS_DESTDIR/$SS_VERSION"

# Download version if not already available
if [[ -s "$ss_extract/shellspec" ]]; then
	ammLog::Info "Version '$SS_VERSION' is already extracted"
else

	if [[ "$SS_VERSION" == "devel" ]]; then
		(
			mkdir -p "$ss_extract"
			cd "$ss_extract"
			git clone "https://github.com/saruspete/shellspec.git" "."
		)
	else
		typeset ss_assets="$(ammHttp::GithubReleaseGetAssets "shellspec/shellspec" "$SS_VERSION")"
		if [[ -z "$ss_assets" ]]; then
			ammLog::Die "Unable to fetch assets for version '$SS_VERSION'"
		fi

		typeset ss_archive="$(ammHttp::FetchSmart "$ss_assets")"
		[[ -d "$ss_extract" ]] || mkdir -p "$ss_extract"

		if ! tar -xf "$ss_archive" -C "$ss_extract" --strip-components=1; then
			ammLog::Warning "tar extraction failed. You may expect some failure down the line"
		fi
	fi

	ammLog::Info "Extracted to '$ss_extract'. Creating symlink 'current' to it"
fi

typeset ss_symlink="$SS_DESTDIR/current"

# Create current symlink
[[ -e "$ss_symlink" ]] && rm "$ss_symlink"
if ! ln -s "$ss_extract" "$ss_symlink"; then
	rglobal+=$?
	ammLog::Warning "Cannot create symlink 'current' for version '$SS_VERSION'"
fi



exit $rglobal
