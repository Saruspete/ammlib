#!/usr/bin/env bash

set -o nounset
set -o noclobber

export LC_ALL=C
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:$PATH"

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"

. $MYPATH/../ammlib

ammLib::Require test date

#echo ${!__ammDate*}
#echo ${!__AMMLIB*}

ammTest::Group "Date Calculation: First day of.."
ammTest::Function ammDate::FirstDayOfMonth 
ammTest::Function ammDate::FirstDayOfMonth 01
ammTest::Function ammDate::FirstDayOfMonth 01 2018
ammTest::Function ammDate::FirstDayOfMonth +1

ammTest::Group "Date calculation: Free timediff"
ammTest::Function ammDate::Calculate "" +7 +1
ammTest::Function ammDate::Calculate "" -20 +1
ammTest::Function ammDate::Calculate "" -12
ammTest::Function ammDate::Calculate "" -24
ammTest::Function ammDate::Calculate "" -25

