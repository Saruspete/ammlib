#!/usr/bin/env bash

set -o nounset
set -o noclobber

export LC_ALL=C
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:$PATH"

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"
readonly MYNAME="${MYSELF##*/}"


. $MYPATH/../ammlib

ammLib::Require test string

typeset file1="$__AMMLIB_DATATMP/$MYNAME.data1"
typeset file2="$__AMMLIB_DATATMP/$MYNAME.data2"
cat >| $file1 <<-EOT
	Hello there
	This a sample output with of letters, numbers and special-chars!
EOT
typeset data1="$(<$file1)"


cat >|$file2 <<-EOT
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s31f6: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state DOWN group default qlen 1000
    link/ether 54:ee:75:fb:3e:34 brd ff:ff:ff:ff:ff:ff
4: wlp4s0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether 72:dc:9c:51:23:9e brd ff:ff:ff:ff:ff:ff
5: virbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether f2:79:09:e4:d6:72 brd ff:ff:ff:ff:ff:ff
    inet 192.168.122.1/24 brd 192.168.122.255 scope global noprefixroute virbr0
       valid_lft forever preferred_lft forever
47: wwp0s20f0u6: <BROADCAST,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 1000
    link/ether 82:1c:18:b6:94:25 brd ff:ff:ff:ff:ff:ff
    inet 10.208.3.144/16 brd 10.208.255.255 scope global noprefixroute wwp0s20f0u6
       valid_lft forever preferred_lft forever
    inet6 fe80::f9e6:ee91:ca22:3ac4/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
EOT
typeset data2="$(<$file2)"


ammTest::Group "Modifier - trim"
ammTest::Function ammString::Trim "   toto   "
ammTest::Function ammString::Trim "-" < <(echo "		hehe  		 ")
ammTest::Function ammString::Trim "-" "[^a-zA-Z0-1]" < <(echo "!!!dang!!^&&à)ç_" )
ammTest::Function ammString::Trim "/toto/pouet/path////" "/"

ammTest::Group "Modifier - Upper/Lower/capitalize"
ammTest::Function ammString::ToLower '-' < "$file1"
ammTest::Function ammString::ToUpper '-' < "$file1"
ammTest::Function ammString::ToCapital '-' < "$file1"

ammTest::Group "Filter - data selection"
ammTest::Function ammString::Filter "inet" "inet" "+1" "$file2"
ammTest::Function ammString::Filter "[0-9]+:" ".+NO.CARRIER.+" "-1" "$file2"

ammTest::Group "Validation - Network"
ammTest::Function ammString::IsIPv4 "1.1.1.1"
ammTest::Function ammString::IsIPv4 "1.1.1"
ammTest::Function ammString::IsIPv4 "1.1"
ammTest::Function ammString::IsIPv4 "1.256"
ammTest::Function ammString::IsIPv4 "duckduckgo.com"
ammTest::Function ammString::IsIPv6 "::1"

ammTest::Group "Validation - User input"
ammTest::Function ammString::IsYes "y"
ammTest::Function ammString::IsYes "yEs"
ammTest::Function ammString::IsYes "Yaaaaaay"
ammTest::Function ammString::IsYes "nope"

ammTest::Group "Validation - URI"
ammTest::Function ammString::IsUri "hello"
ammTest::Function ammString::IsUri "hello world"
ammTest::Function ammString::IsUri "http://host/path"
ammTest::Function ammString::IsUri "http://fqdn.domain.tld:1234/path?var1=val1&var2=val2"
ammTest::Function ammString::IsUri "file:///tmp/toto"
ammTest::Function ammString::IsUri "git+ssh://hostname.domain.tld:123"

ammTest::Group "Parsing - List Expand"
ammTest::Function ammString::ListExpand "1,2,10-30,34,34,30-35,9-4"
