#!/usr/bin/env bash

set -o nounset
set -o noclobber

export LC_ALL=C
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:$PATH"
export PS4=' (${BASH_SOURCE##*/}::${FUNCNAME[0]:-main}::$LINENO)  '

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"

# Temporary folder
typeset DEST="$MYPATH/${0##*/}.data"
mkdir -p "$DEST"

. $MYPATH/../ammlib

ammLibRequire pkg chroot

if [[ -z "${1:-}" ]]; then
	ammLogInf "Usage: $0 <file or package to extract> [file or pkg...]"
	exit 1
fi

ammLogInf "Extracting to '$DEST'"
ammPkgExtractWithDeps "$DEST" "$@"
ammLogInf "Done."
