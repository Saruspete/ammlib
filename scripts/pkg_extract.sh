#!/usr/bin/env bash

set -o nounset
set -o noclobber

export LC_ALL=C
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:$PATH"
export PS4=' (${BASH_SOURCE##*/}::${FUNCNAME[0]:-main}::$LINENO)  '

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"

# Temporary folder
typeset DSTDIR="$MYPATH/${0##*/}.data"
typeset PKGDIR="$MYPATH/${0##*/}.pkgs"

. $MYPATH/../ammlib

ammLib::Require pkg chroot optparse

ammOptparse::AddOpt "-d|--dstdir=" "Destination folder to extract the packages" "$DSTDIR"
ammOptparse::AddOpt "-t|--pkgdir=" "Temporary folder where to place downloaded packages" "$PKGDIR"
#mmOptparse::AddOpt "--downloadonly!" "Only download packages to pkgdir"


if ! ammOptparse::Parse; then
	ammOptparse::Help
	ammLog::Die "Options parsing errors. Please check"
fi

DSTDIR="$(ammOptparse::Get 'dstdir')"
PKGDIR="$(ammOptparse::Get 'pkgdir')"

mkdir -p "$DSTDIR"

if [[ -z "${1:-}" ]]; then
	echo "Usage: $0 <file or package to extract> [file or pkg...]"
	echo
	ammOptparse::Help
	exit 1
fi

ammLog::Inf "Extracting to '$DSTDIR'"
ammPkg::ExtractWithDeps "$DSTDIR" "$@"
ammLog::Inf "Done."
