# vim: ft=sh ts=4


if ! [[ "${FUNCNAME[1]}" = ammLib::Load* ]]; then
	echo >&2 "You must not source this library ($BASH_SOURCE): Use function ammLib::Load"
	exit 1
fi

# -----------------------------------------------------------------------------
# AMM Lib meta stubs
# -----------------------------------------------------------------------------

function ammChrootCentos::MetaCheck {
	ammLib::Require pkg
}

function ammChrootCentos::MetaInit {
	ammLib::Load pkg
}

# -----------------------------------------------------------------------------
# Some description for your lib
# -----------------------------------------------------------------------------

function ammChrootCentos::Populate {
	typeset chrootdir="$1"

	# Base system
	typeset pkgs="basesystem bash busybox coreutils filesystem redhat-release-server"
	pkgs+="rpm yum rpm-build ca-certificates"
	# Services
	pkgs+="chkconfig initscripts"
	# Utils and tools
	pkgs+="elfutils findutils gcc make strace"
	pkgs+="bzip2 date gawk grep gzip info less"
	pkgs+="ncurses perl pcre sed tar tee which"
	# Hardware
	pkgs+="dmidecode mingetty"
	# Kernel
	pkgs+="e2fsprogs e2fsprogs-libs"

	yum --installroot="$chrootdir" $pkgs

}

