#!/usr/bin/env bash

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"

. $MYPATH/../ammlib

ammLib::Require "table" "optparse" "syscfg" "syscfg.network" "network" "string" "devices"

# Check for user root, else issue a warning


#
# System Overview
#
function showHardware {

	ammTable::Create "Hardware" "Type|size:16" "Vendor|size:10%" "Model|size:fill" "Node" "Speed" "Drivers|size:20"
	ammTable::SetDisplayMode "direct"
	
	typeset t line
	# DMI Elements
	for t in chassis system bios; do
		typeset vendor="" model="" version="" serial=""
		while IFS=: read key val; do
			key="$(ammString::Trim "$key")"
			val="$(ammString::Trim "$val")"
			case $key in
				Manufacturer|Vendor) vendor="$val" ;;
				Product\ Name) model="$val" ;;
				Version)       version="$val" ;;
				Serial\ Number) serial="$val" ;;
				Release\ Date)  model="$val" ;;
			esac
	
		done < <(dmidecode -t "$t" 2>/dev/null)
	
		[[ -n "$version" ]] && model+=" / Version: $version"
		[[ -n "$serial" ]] && model+="  / Serial: $serial"
		ammTable::AddRow "$t" "$vendor" "$model"
	done
	# PCI Devices
	while read line; do
		typeset pciid= devtype= vendor= version= device= driver=
		eval "$line"
	
		# Skip useless devices
		[[ "$devtype" =~ (PCI|Host|ISA)\ bridge ]] && continue
	
		# Get more details
		typeset driver= current_link_speed= max_link_speed= current_link_width= max_link_width=
		typeset irq= numa_node= enable=
		eval "$(ammDevices::GetDetail $pciid)"
	
		typeset speed=""
		[[ -n "$current_link_width" ]] && speed+="$current_link_width/$max_link_width"
	
		ammTable::AddRow "$devtype" "$vendor" "$device" "$numa_node" "$speed" "$driver"
	done < <(ammDevices::List)

}

#
# CPU and Memory overview
#
function showCPUMem {
	echo
	ammTable::Create "CPU and Memory"  "NUMA" "CPU Model" "RAM Size" "DIMMs"
	ammTable::SetDisplayMode "direct"

}


#
# Network details
#
function showNetwork {
	echo
	ammTable::Create "NIC Details"  "NIC|size:16" "Type|size:8" "VendorId" "ModelId" "MAC Address|size:18" "Speed" "Dplx" "Medium" "IPv4|size:18"
	ammTable::SetDisplayMode "direct"
	
	typeset nic
	for nic in $(ammSyscfgNetwork::NicGet); do
		typeset speed= duplex= medium= mac= ipv4= vendorid= deviceid=
		eval $(ammSyscfgNetwork::NicInfo $nic)
		eval $(ammSyscfgNetwork::CableInfo $nic)
	
		# 
		[[ "$carrier" == "0" ]] && duplex="N/A"
	
		
	
		ammTable::AddRow "$nic" "$type" "$vendorid" "$deviceid" "$mac" "$speed" "$duplex" "$medium" "$ipv4"
		
	done

}


#
# Storage detail
#
function showStorage {
	ammTable::Create "Storage"
	ammTable::SetDisplayMode "direct"

}


showHardware
showCPUMem
showNetwork
showStorage

