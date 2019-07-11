#!/usr/bin/env bash

set -o nounset
set -o noclobber

export LC_ALL=C
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:$PATH"

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"

. $MYPATH/../ammlib

ammLibLoad test date

#echo ${!__ammDate*}
#echo ${!__AMMLIB*}

ammTestGroup "Date Calculation: First day of.."
ammTestFunction ammDateFirstDayOfMonth 
ammTestFunction ammDateFirstDayOfMonth 01
ammTestFunction ammDateFirstDayOfMonth 01 2018
ammTestFunction ammDateFirstDayOfMonth +1

ammTestGroup "Date calculation: Free timediff"
ammTestFunction ammDateCalculate "" +7 +1
ammTestFunction ammDateCalculate "" -20 +1
ammTestFunction ammDateCalculate "" -12
ammTestFunction ammDateCalculate "" -24
ammTestFunction ammDateCalculate "" -25

