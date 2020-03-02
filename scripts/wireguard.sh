#!/usr/bin/env bash

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"
readonly MYCONF="/etc/wireguard"


. "$MYPATH/../ammlib"

ammLib::Require "table" "optparse" "syscfg" "syscfg.network"

# Common options
ammOptparse::AddOptGroupDesc "Global options"
ammOptparse::AddOpt "-f|--force!"   "Force requested operation" "false"
ammOptparse::Parse



# =============================================================================
#
# Status
#

function wgStatus {
	typeset iface="${1:-all}"

	typeset showpriv="$(ammOptparse::Get "private")"

	typeset -a cols=(
		"Iface|size:10"
		"Public Key|size:46"
	)
	
	$showpriv && cols+=("Private Key|size:46")
	cols+=(
		"Endpoint|size:32"
		"AllowedIPs|size:18"
		"Last Handshake"
		"KB Sent"
		"KB Received"
		"Keepalive"
	)


	ammTable::Create "WireGuard Details" "${cols[@]}"
	ammTable::SetDisplayMode "direct"

	# output tab separated
	# first contains: private-key,  public-key, listen-port, fwmark.
	# Subsequent for each peer: public-key, preshared-key, endpoint, allowed-ips, latest-handshake, transfer-rx, transfer-tx, persistent-keepalive.
	wg show $iface dump | awk -v show=$showpriv -F$'\t' '{
		if(show=="false"){
			# Peer line
			if ($3=="(none)")
				$3=""
			# Iface line
			else
				$2=$5=""
		}
		print;
	}' | ammTable::AddRow "-"

}


# =============================================================================
#
# Helpers
#

function wgAvailable {
	modinfo wireguard >/dev/null 2>&1 && type wg >/dev/null 2>&1
}

function wgPeerkeyFilename {
	typeset key="$1"
	key="${key//\//_}"
	echo "$key"
}

function wgGenKeys {
	typeset name="$1"
	typeset path="${2:-$MYCONF/$name}"

	typeset -i r=0
	typeset pkey="$path/wgkey.prv"
	[[ -d "$path" ]] || mkdir -p "$path"

	ammLog::Dbg "Generating private key to '$path/wgkey.prv'"

	# Generate privkey
	if [[ -e "$pkey" ]]; then
		ammLog::Err "Private key '$pkey' already exists. Delete it first"
		return 1
	fi

	# TODO: Add more security regarding isolation
	(
		umask 077
		wg genkey | tee "$pkey" | wg pubkey > "${pkey%.*}.pub"
	)
	r=$?

	if ! [[ -e "$pkey" ]]; then
		ammLog::Err "Cannot generate keys for '$name' in '$pkey' ($r)"
		return 1
	fi

	echo "$pkey"
	return 0
}

function wgNicRunning {
	typeset name="$1"

	ammSyscfgNetwork::NicExists "$name" && ammSyscfgNetwork::NicIsUp "$name"
}

function wgNicExists {
	typeset name="$1"
	ammSyscfgNetwork::NicExists "$name"
}

function wgNicInit {
	typeset name="$1"
	typeset addr="${2:-}"

	ammLog::Dbg "Initializating NIC '$name' with addr '$addr'"

	# Create NIC if not existing
	if wgNicExists "$name"; then
		ammLog::Err "Iface '$name' already exists"
		return 1
	fi

	if ! ammSyscfgNetwork::NicCreate "$name" "wireguard"; then
		ammLog::Err "Unable to create wireguard iface '$name'"
		return 1
	fi

	# try to add IPv4 if provided
	if [[ -n "$addr" ]] && ! ammSyscfgNetwork::IpAddrAdd "$name" "$addr"; then
		ammLog::Err "Unable to set wireguard local IP '$addr' to '$name'"
		return 1
	fi

	return 0
}

function wgCreateRouting {
	typeset name="$1"

}



function wgSetup {
	typeset name="$1"
	typeset privkey="${2:-}"
	typeset port="${3:-}"

	typeset cfgpath="$MYCONF/$name"

	ammLog::Dbg "Configuring wireguard iface '$iface'"

	# Create initial configuration string
	typeset -a wgcfg

	# Listening port
	[[ -n "$port" ]] && wgcfg+=(listen-port $port)

	# Create keys if needed
	if [[ -z "$privkey" ]]; then
		if [[ -s "$cfgpath/wgkey.prv" ]]; then
			privkey="$cfgpath/wgkey.prv"
		else
			privkey="$(wgGenKeys "$name")"
			if ! [[ -s "$privkey" ]]; then
				ammLog::Err "Error during keys generation."
				return 1
			fi
		fi
	fi
	wgcfg+=(private-key "$privkey")

	# Configure wireguard
	if ! wg set "$name" ${wgcfg[@]}; then
		ammLog::Err "An error occured when configuring wireguard."
		return 1
	fi

	if ! ammSyscfgNetwork::NicEnable "$name"; then
		ammLog::Err "Unable to start the iface '$name' (ip link set $name up)"
		return 1
	fi

	return 0
}





# =============================================================================
#
# Configuration management
#

function wgCfgLoad {
	typeset name="$1"

	typeset cfgfile="$MYCONF/$name/wg.cfg"
	if ! [[ -s "$cfgfile" ]]; then
		ammLog::Err "No configuration found for '$name' as '$cfgfile'"
		return 1
	fi

	ammLog::Dbg "Loading cfg '$cfgfile' to iface '$name'"

	# If NIC is already up and running, sync conf instead of resetting it
	if wgNicRunning "$name"; then
		wg syncconf "$name" "$cfgfile"

	# First init or syncconf not needed, reset it
	else
		wg setconf "$name" "$cfgfile"
	fi
}


function wgCfgSave {
	typeset name="$1"

	# Create config folder if not existing
	typeset cfgpath="$MYCONF/$name"
	[[ -d "$cfgpath" ]] || mkdir -p "$cfgpath"

	ammLog::Dbg "Save cfg of iface '$name' to '$cfgpath/wg.cfg'"

	# Dump the config
	(
		umask 077
		wg showconf "$name" > "$cfgpath/wg.cfg"
	)

}


# =============================================================================
#
# Peer management
#

function wgPeerAddClient {
	typeset name="$1"
	typeset peerkey="$2"
	typeset peername="$3"
	typeset peeraddr="$4"

	wgPeerAdd "$name" "$peerkey" "$peeraddr" "" "" "$peeraddr" "" "$peername" "client"
}

function wgPeerAddServer {
	typeset name="$1"
	typeset peerkey="$2"
	typeset peeraddr="$3"
	typeset peerroute="${4:-}"

	wgPeerAdd "$name" "$peerkey" "$peeraddr" "" "25" "$peerroute" "$peerroute" "" "server"
}

function wgPeerAdd {
	typeset name="$1"
	typeset peerkey="$2"
	typeset peeraddr="${3:-}"
	typeset pskfile="${4:-}"
	typeset keepalive="${5:-}"
	typeset ipallowed="${6:-}"
	typeset routes="${7:-}"
	typeset peername="${8:-}"
	typeset peertype="${9:-server}"

	# Push peer to configuration folder
	typeset cfgpath="$MYCONF/$name/peers"
	typeset cfgpeer="$cfgpath/$(wgPeerkeyFilename $peerkey)"
	typeset -a err=""
	[[ -d "$cfgpath" ]] || mkdir -p "$cfgpath"

	# Ensure correct formatting
	if [[ -n "$ipallowed" ]]; then
		:
	fi

	wg set "$name" \
		peer "$peerkey" \
		endpoint "$peeraddr" \
		${pskfile:+preshared-key $pskfile} \
		${keepalive:+persistent-keepalive $keepalive} \
		${ipallowed:+allowed-ips $ipallowed}

	if [[ "$?" -ne 0 ]]; then
		ammLog::Err "Error occured during add of peer '$peerkey'"
		return 1
	fi

	# Do route management
	if [[ -n "$routes" ]]; then
		typeset net
		for net in $routes; do
			typeset route="$net via $peeraddr"
			if ! ip route add $route; then
				err+=("Route command failed: 'ip route add $route'")
			fi
		done
	fi


	# Save configuration
	cat >"$cfgpeer" <<-EOT
		peername="$peername"
		peerkey="$peerkey"
		peeraddr="$peeraddr"
		pskfile="$pskfile"
		keepalive="$keepalive"
		ipallowed="$ipallowed"
		timeadd="$(date +%s)"
		type="$peertype"
		routes="$routes"
		enabled="true"
	EOT

	if [[ -n "$err" ]]; then
		ammLog::Err "Some error occured: ${err[@]}"
		return 1
	fi

	return 0
}

function wgPeerDisable {
	typeset name="$1"
	typeset peerkey="$2"

	wg set "$name" peer "$peerkey" remove
}

function wgPeerDel {
	typeset name="$1"
	typeset peerkey="$2"

	typeset cfgpath="$MYCONF/$name/peers"
	rm -f "$cfgpath/$peerkey"

	wg set "$name" peer "$peerkey" remove
}


# =============================================================================
#
# Main actions
#
# =============================================================================

function mainInstall {

	# Try to handle the packages
	ammLib::Require "pkg" "http"
	typeset pkgmgr="$(ammPkg::ManagerDetect)"
	typeset distrib="$(cat /etc/*-release)"

	# Mapping of https://www.wireguard.com/install/
	case "$distrib" in

		#
		# Redhat variants
		#
		RedHat*release\ 7.*|CentOS*release\ 7.*)
			ammPkg::Install "epel-release" || ammPkg::Install "https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm"
			ammHttp::Fetch "https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo" "/etc/yum.repos.d/jdoss-wireguard-epel-7.repo"
			ammPkg::Install "wireguard-dkms" "wireguard-tools"
			;;
		Redhat*release\ 8.*)
			ammPkg::Install "epel-release" || ammPkg::Install "https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm"
			subscription-manager repos --enable codeready-builder-for-rhel-8-$(arch)-rpms
			yum copr enable "jdoss/wireguard"
			ammPkg::Install "wireguard-dkms" "wireguard-tools"
			;;
		CentOS*release\ 8.*)
			ammPkg::Install "epel-release" || ammPkg::Install "https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm"
			yum config-manager --set-enabled "PowerTools"
			yum copr enable "jdoss/wireguard"
			ammPkg::Install "wireguard-dkms" "wireguard-tools"
			;;

		#
		# Fedora
		#
		Fedora*2[0-9]*|Fedora*3[01]*)
			dnf copr enable jdoss/wireguard
			ammPkg::Install "wireguard-dkms" "wireguard-tools"
			;;
		Fedora*)
			ammPkg::Install "wireguard-tools"
			;;

		#
		# Ubuntu
		#
		Ubuntu*1[789].04)
			add-apt-repository ppa:wireguard/wireguard
			apt-get update
			ammPkg::Install "wireguard"
			;;
		Ubuntu*)
			ammPkg::Install "wireguard"
			;;

		#
		# Debian
		#
		Debian*)
			echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable.list
			printf 'Package: *\nPin: release a=unstable\nPin-Priority: 90\n' > /etc/apt/preferences.d/limit-unstable
			apt update
			ammPkg::Install "wireguard"
			;;

		#
		# Gentoo
		#
		Gentoo*)
			ammPkg::Install "wireguard-tools" "wireguard-modules"
			;;

		Exherbo*)
			ammPkg::Install "wireguard"
			;;

		*)
			ammLog::Err "Unmanaged distribution: '$distrib'. Please contact Adrien"
			return 1
			;;
	esac

	if ! modprobe wireguard; then
		ammLog::Err "Unable to load kernel module 'wireguard'. Please check logs"
		return 1
	fi

	return 0
}

function mainStart {
	typeset name="$1"

	typeset cfgpath="$MYCONF/$name"

	# if configuration exists, load it
	if [[ -s "$cfgpath/wg.cfg" ]]; then

		# Create NIC
		if ! ammSyscfgNetwork::NicExists "$name"; then
			if ! wgInit "$name"; then
				ammLog::Err "Error during NIC Initialization. try deleting it with --force"
			fi
		fi

		# 
	fi
}

function mainStop {
	:
}

function mainStatus {
	:
}

typeset op="${1:-}"; shift

case "$op" in
	start)
		;;

	stop)
		;;

	restart)
		;;

	status)
		ammOptparse::AddOptGroupDesc "Status options"
		ammOptparse::AddOpt "-P|--private!" "Show private key too" "false"
		ammOptparse::Parse

		wgStatus "$@"
		;;


	setup)
		if ! wgAvailable; then
			mainInstall || ammLog::Die "Unable to setup Wireguard."
		fi

		exit 0
		;;

	addclient)
		;;

	addserver)

		typeset iface="${1:-}"; shift
		ammOptparse::AddOptGroupDesc "addserver command parameters"
		ammOptparse::AddOpt "-s|--serveraddr=" "Remote server address (host[:port]) to connect to"
		ammOptparse::AddOpt "-k|--serverkey="  "Remote server public key"
		ammOptparse::AddOpt "-a|--localaddr="  "Local address to be assigned"
		ammOptparse::AddOpt    "--localport="  "Local port to listen to"
		ammOptparse::AddOpt "-p|--localkey="   "Local private key"
		ammOptparse::AddOpt "-r|--route@"      "Routes to forward to remote server"
		ammOptparse::AddOpt "-K|--keepalive="  "Keepalive (in seconds)" "25"

		ammOptparse::Parse --no-unknown --skip=2 || ammLog::Die "Error during options parsing"

		typeset    raddr="$(ammOptparse::Get "serveraddr")"
		typeset    rkey="$(ammOptparse::Get "serverkey")"
		typeset    laddr="$(ammOptparse::Get "localaddr")"
		typeset    lport="$(ammOptparse::Get "localport")"
		typeset    lkey="$(ammOptparse::Get "localkey")"
		typeset -a route=($(ammOptparse::Get "route"))

		if [[ -n "$iface" ]]; then
			ammLog::Err "Usage: $0 addserver <iface> [options...]"
			ammOptparse::Help
		fi

		# Create NIC if needed
		if ! wgNicExists "$iface"; then
			if ! wgNicInit "$iface" "$laddr"; then
				ammLog::Err "Cannot create iface '$iface' (eg 'ip link add $iface type wireguard')"
				exit 1
			fi
		fi

		# Initialize the tunnel
		if ! wgSetup "$iface" "$lkey" "$lport"; then
			ammLog::Err "Unable to configure the iface '$iface'"
			exit 1
		fi

		# Add the server peer
		if ! wgPeerAddServer "$iface" "$rkey" "$raddr" "${routes[@]}"; then
			ammLog::Err "Unable to add the server configuration to '$iface'"
			exit 1
		fi

		# Save the configuration
		if ! wgCfgSave "$iface"; then
			ammLog::Err "Unable to save the configuration of '$iface'"
			exit 1
		fi

		;;

	removepeer)

		;;

	disablepeer)
		
		;;
		


	call)
		typeset func="$1"; shift
		$func "$@"
		;;

	*)
		cat <<-EOT
			This script is a wrapper to start, configure and manage WireGuard connections

			Install: $0 setup
			Service: $0 <start|stop|status>   [iface]
			Add:     $0 <addclient|addserver> <iface> <params...>
			Debug:   $0 call <funcname> [params...]

			Usual sequence for first time configuration:
			$0 setup
			$0 addserver wg0 --server myvpn.example.com --key "1234567890+ABCDEF==" --address 10.254.254.123/24 --route 10.0.0./24 --keepalive 20"
			$0 start wg0

		EOT
		ammOptparse::Help
esac

