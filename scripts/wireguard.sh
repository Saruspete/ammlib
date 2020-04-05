#!/usr/bin/env bash

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"
readonly MYCONF="/etc/wireguard"


. "$MYPATH/../ammlib"

ammLib::Require "table" "optparse" "syscfg" "syscfg.network" "network"

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
		"K.A."
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
	typeset iface="$1"
	typeset path="${2:-$MYCONF/$iface}"

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
		ammLog::Err "Cannot generate keys for '$iface' in '$pkey' ($r)"
		return 1
	fi

	echo "$pkey"
	return 0
}

function wgNicRunning {
	typeset iface="$1"

	ammSyscfgNetwork::NicExists "$iface" && ammSyscfgNetwork::NicIsUp "$iface"
}

function wgNicExists {
	typeset iface="$1"
	ammSyscfgNetwork::NicExists "$iface"
}

function wgNicInit {
	typeset iface="$1"
	typeset addr="${2:-}"

	ammLog::Dbg "Initializating NIC '$iface' with addr '$addr'"

	# Create NIC if not existing
	if wgNicExists "$iface"; then
		ammLog::Err "Iface '$iface' already exists"
		return 1
	fi

	if ! ammSyscfgNetwork::NicCreate "$iface" "wireguard"; then
		ammLog::Err "Unable to create wireguard iface '$iface'"
		return 1
	fi

	# try to add IPv4 if provided
	if [[ -n "$addr" ]] && ! ammSyscfgNetwork::IpAddrAdd "$iface" "$addr"; then
		ammLog::Err "Unable to set wireguard local IP '$addr' to '$iface'"
		return 1
	fi

	return 0
}


function wgSetup {
	typeset iface="$1"
	typeset privkey="${2:-}"
	typeset port="${3:-}"

	typeset cfgpath="$MYCONF/$iface"

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
			privkey="$(wgGenKeys "$iface")"
			if ! [[ -s "$privkey" ]]; then
				ammLog::Err "Error during keys generation."
				return 1
			fi
		fi
	fi
	wgcfg+=(private-key "$privkey")

	# Configure wireguard
	ammLog::Dbg "Calling 'wg set $iface ${wgcfg[@]}'"
	if ! wg set "$iface" ${wgcfg[@]}; then
		ammLog::Err "An error occured when configuring wireguard."
		return 1
	fi

	if ! ammSyscfgNetwork::NicEnable "$iface"; then
		ammLog::Err "Unable to start the iface '$iface' (ip link set $iface up)"
		return 1
	fi

	return 0
}





# =============================================================================
#
# Configuration management
#

function wgCfgLoad {
	typeset iface="$1"

	typeset cfgfile="$MYCONF/$iface/wg.cfg"
	if ! [[ -s "$cfgfile" ]]; then
		ammLog::Err "No configuration found for '$iface' as '$cfgfile'"
		return 1
	fi

	# Load the main configuration
	ammLog::Dbg "Loading cfg '$cfgfile' to iface '$iface'"

	# If NIC is already up and running, sync conf instead of resetting it
	if wgNicRunning "$iface"; then
		wg syncconf "$iface" "$cfgfile"

	# First init or syncconf not needed, reset it
	else
		wg setconf "$iface" "$cfgfile"
	fi

}


function wgCfgSave {
	typeset iface="$1"

	# Create config folder if not existing
	typeset cfgpath="$MYCONF/$iface"
	[[ -d "$cfgpath" ]] || mkdir -p "$cfgpath"

	ammLog::Dbg "Save cfg of iface '$iface' to '$cfgpath/wg.cfg'"

	# Dump the config
	(
		umask 077
		wg showconf "$iface" > "$cfgpath/wg.cfg"
	)
}


# =============================================================================
#
# Peer management
#

# @description  Wrapper to add a client peer
# @arg $1  (string) Iface to add the peer to
# @arg $2  (string) Key of the peer
# @arg $3  (string) Address (or URL) of the peer
# @arg $4  (string) Name of the peer
function wgPeerAddClient {
	typeset iface="$1"
	typeset peerkey="$2"
	typeset peeraddr="$3"
	typeset peername="$4"

	wgPeerAdd "$iface" "$peerkey" "$peeraddr" "" "" "" "${peeraddr%%:*}/32" "$peername" "client" ""
}

# @description  Wrapper to add a server peer
# @arg $1  (string) Iface to add the peer to
# @arg $2  (string) Public key of the peer
# @arg $3  (string) Address (or URL) of the peer
# @arg $4  (string) Local address (ip/cidr)
# @arg $@  (string[]) Routes to add to the connection
function wgPeerAddServer {
	typeset iface="$1"
	typeset peerkey="$2"
	typeset peeraddr="$3"
	typeset localaddr="$4"
	shift 4

	# Add route to our local network, and optionnal routes if needed
	typeset lnet="$(ammNetwork::Calc "$localaddr" "network")" ; lnet="${lnet#*=}"
	typeset lcidr="${localaddr#*/}"
	# Allow our routes
	typeset allowedIps r
	for r in "$lnet/$lcidr" "$@"; do
		r="${r%% *}"
		allowedIps+="${allowedIps:+,}$r"
	done

	ammLog::Dbg "Adding server peer with '$iface' '$peerkey' '$peeraddr' '' '25' '$allowedIps' '' 'server' '$lnet' '$@'"
	wgPeerAdd "$iface" "$peerkey" "$peeraddr" "$localaddr" "" "25" "$allowedIps" "" "server"  "$lnet/$lcidr" "$@"
}

# @description  Add a peer to a wireguard interface
# @arg $1  (string) Iface to add the peer to
# @arg $2  (string) Public key of the peer
# @arg $3  (string) Address (or URL) of the peer
# @arg $4  (string) Pre-shared key
# @arg $5  (int)    Keep-alive interval
# @arg $6  (string) IP/prefix allowed from this peer
# @arg $7  (string) Name of the peer
# @arg $8  (string) Type of the peer (client or server)
# @arg $@  (string[]) Routes to be added
function wgPeerAdd {
	typeset iface="$1"
	typeset peerkey="$2"
	typeset peeraddr="${3:-}"
	typeset localaddr="${4:-}"
	typeset pskfile="${5:-}"
	typeset keepalive="${6:-}"
	typeset ipallowed="${7:-}"
	typeset peername="${8:-}"
	typeset peertype="${9:-server}"
	shift 9
	typeset -a routes=("$@")

	# Push peer to configuration folder
	typeset cfgpath="$MYCONF/$iface/peers"
	typeset cfgpeer="$cfgpath/$(wgPeerkeyFilename $peerkey)"
	[[ -d "$cfgpath" ]] || mkdir -p "$cfgpath"

	# Ensure correct formatting
	if [[ -n "$ipallowed" ]]; then
		:
	fi

	# Configure the iface
	wg set "$iface" \
		peer "$peerkey" \
		endpoint "$peeraddr" \
		${pskfile:+preshared-key $pskfile} \
		${keepalive:+persistent-keepalive $keepalive} \
		${ipallowed:+allowed-ips $ipallowed}

	if [[ "$?" -ne 0 ]]; then
		ammLog::Err "Error occured during add of peer '$peerkey'"
		return 1
	fi

	# Generate configuration to be tested by load function
	cat >"$cfgpeer" <<-EOT
		peername="$peername"
		peerkey="$peerkey"
		peeraddr="$peeraddr"
		peertype="$peertype"
		pskfile="$pskfile"
		keepalive="$keepalive"
		localaddr="$localaddr"
		ipallowed="$ipallowed"
		timeadd="$(date +%s)"
		enabled="true"
		$(ammEnv::VarExport "routes")
	EOT

	if ! wgPeerLoad "$iface" "$peerkey"; then
		ammLog::Err "Error during peer configuration load (check file '$cfgpeer')"
		return 1
	fi

	return 0
}

function wgPeerLoad {
	typeset iface="$1"
	typeset filterpeerkey="${2:-}"

	ammLog::Dbg "Will load peer cfg of '$iface' (filter: $filterpeerkey)"

	# Load the peer configuration
	typeset peercfg
	for peercfg in "$MYCONF/$iface/peers/"*; do
		[[ -e "$peercfg" ]] || continue
		# Spawn a subshell for loading
		(
			typeset peertype peername peerkey peeraddr pskfile keepalive
			typeset localaddr ipallowed timeadd enabled
			typeset dnsserver dnssearch
			typeset -a routes
			source "$peercfg"

			ammLog::Dbg "Checking file '$peercfg'"

			# Filters on the peer
			[[ -n "$filterpeerkey" ]] && [[ "$filterpeerkey" != "$peerkey" ]] && continue
			[[ "$enabled" != "true" ]] && continue

			ammLog::Dbg "Processing file '$peercfg'"

			# Add local IP configuration
			if [[ -n "${localaddr:-}" ]]; then
				if ! ammSyscfgNetwork::IpAddrExists "$iface" "$localaddr"; then
					ammLog::Inf "Add IP '$localaddr' to '$iface'"
					ammSyscfgNetwork::IpAddrAdd "$iface" "$localaddr"
				fi
			fi

			# If remote peer is a server, more network changes
			if [[ "$peertype" == "server" ]]; then
				# Routing
				if [[ -n "${routes:-}" ]]; then
					typeset route extra
					for route in "${routes[@]}"; do
						ammLog::Dbg "Checking for route '$route'"
						extra="${route#* }"
						route="${route%% *}"
						[[ "$extra" == "$route" ]] && extra=
						if ! ammSyscfgNetwork::RouteExists "$iface" "$route"; then
							ammLog::Inf "Adding route '$route' ($extra) to '$iface'"
							ammSyscfgNetwork::RouteAdd "$iface" "$route" "$extra"
						fi
					done
				fi

				# TODO: DNS
				if [[ -n "${dnsserver:-}" ]]; then
					:
				fi
			fi
		)
	done


}


function wgPeerDisable {
	typeset iface="$1"
	typeset peerkey="$2"

	wg set "$iface" peer "$peerkey" remove

	# TODO: Edit configuration
}

function wgPeerDelete {
	typeset iface="$1"
	typeset peerkey="$2"

	typeset cfgpath="$MYCONF/$iface/peers"
	# TODO: Delete configuration
	#rm -f "$cfgpath/$peerkey"

	wg set "$iface" peer "$peerkey" remove
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
	typeset iface="$1"

	typeset cfgpath="$MYCONF/$iface"
	typeset -i r=0

	ammLog::Inf "Starting interface '$iface'"

	# if configuration exists, load it
	if ! [[ -s "$cfgpath/wg.cfg" ]]; then
		ammLog::Err "Configuration '$cfgpath/wg.cfg' is empty or does not exists"
		return 1
	fi

	# Create NIC
	if ! ammSyscfgNetwork::NicExists "$iface"; then
		if ! wgNicInit "$iface"; then
			ammLog::Err "Error during NIC '$iface' Initialization. try deleting it with --force"
			return 1
		fi
	fi

	# Load WG configuration
	if ! wgCfgLoad "$iface"; then
		ammLog::Err "Error during NIC '$iface' configuration"
		return 1
	fi

	# Set link up
	if ! ammSyscfgNetwork::NicEnable "$iface"; then
		ammLog::Err "Error during up to iface '$iface'"
		return 1
	fi

	# Load peer configuration (ip & route)
	if ! wgPeerLoad "$iface"; then
		ammLog::Wrn "Some peer configuration failed"
		r+=1
	fi

	return $r
}

function mainStop {
	:
}

function mainStatus {
	:
}

typeset op="${1:-}"; shift
typeset -i r=0

case "$op" in
	start)
		typeset ifaces="$@"
		typeset iface=""

		if [[ -z "$ifaces" ]]; then
			for iface in $MYCONF/*/wg.cfg; do
				iface="${iface%/wg.cfg}"
				iface="${iface##*/}"
				ifaces+=" $iface"
			done
		fi

		for iface in $ifaces; do
			if [[ -d "$MYCONF/$iface" ]]; then
				mainStart $iface
				r+=$?
			fi
		done
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
		else
			ammLog::Inf "WireGuard installed and available"
		fi

		exit 0
		;;

	addclient)
		;;

	addserver)

		typeset iface="${1:-}"; shift
		ammOptparse::AddOptGroupDesc "addserver command parameters"
		ammOptparse::AddOpt "-a|--serveraddr=" "Remote server address (host[:port]) to connect to"
		ammOptparse::AddOpt "-k|--serverkey="  "Remote server public key"
		ammOptparse::AddOpt "-A|--localaddr="  "Local address to be assigned (format: 'ip/cidr')"
		ammOptparse::AddOpt    "--localport="  "Local port to listen to"
		ammOptparse::AddOpt "-K|--localkey="   "Local private key (will be generated if none exists)"
		ammOptparse::AddOpt "-r|--route@"      "Routes to forward to remote server"
		ammOptparse::AddOpt    "--keepalive="  "Keepalive (in seconds)" "25"

		ammOptparse::Parse --no-unknown --skip=2 || ammLog::Die "Error during options parsing"

		typeset    raddr="$(ammOptparse::Get "serveraddr")"
		typeset    rkey="$(ammOptparse::Get "serverkey")"
		typeset    laddr="$(ammOptparse::Get "localaddr")"
		typeset    lport="$(ammOptparse::Get "localport")"
		typeset    lkey="$(ammOptparse::Get "localkey")"
		typeset -a routes=$(ammOptparse::Get "route")

		if [[ -z "$iface" ]]; then
			ammLog::Err "Usage: $0 addserver <iface> [options...]"
			ammOptparse::Help
			exit 1
		fi

		# Create NIC if needed
		if ! wgNicExists "$iface"; then
			if ! wgNicInit "$iface" "$laddr"; then
				ammLog::Err "Cannot create iface '$iface' (eg 'ip link add $iface type wireguard')"
				exit 1
			fi
			ammLog::Inf "Interface '$iface' created as wireguard"
		fi

		# Initialize the tunnel
		if ! wgSetup "$iface" "$lkey" "$lport"; then
			ammLog::Err "Unable to configure the iface '$iface'"
			exit 1
		fi
		ammLog::Inf "Iface '$iface' configured"

		# Add the server peer
		if ! wgPeerAddServer "$iface" "$rkey" "$raddr" "$laddr" "${routes[@]}"; then
			ammLog::Err "Unable to add the server configuration to '$iface'"
			exit 1
		fi
		ammLog::Inf "Peer '$raddr' configured on '$iface'"

		# Save the configuration
		if ! wgCfgSave "$iface"; then
			ammLog::Err "Unable to save the configuration of '$iface'"
			exit 1
		fi
		ammLog::Inf "Configuration of '$iface' saved"
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
			$0 addserver wg0 --serveraddr myvpn.example.com --serverkey "1234567890+ABCDEF==" --localaddr 10.254.254.123/24 --route "10.0.0.0/8 mtu 1372" --keepalive 20"
			$0 start wg0

		EOT
		ammOptparse::Help
		r=1
esac

exit $r
