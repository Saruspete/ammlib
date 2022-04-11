#!/usr/bin/env bash

set -o nounset
set -o noclobber

export LC_ALL=C
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:$PATH"

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"

. $MYPATH/../ammlib

ammLib::Require "table"

ammTable::Create "Demo table" "ID|size:4,overflow:hidden"  "Name|size:16,overflow:wrap" "Column 25%|size:25%" "Description (fill remains)|size:fill,overflow:wrap"

ammTable::AddRow "0" "Title 1" "Useless" "This is a funny description"

ammTable::Display

typeset -i i=1
while [[ $i -lt 20 ]]; do
	ammTable::AddRow "$i" "Name $RANDOM" "Lorem ipsum" "This row will be shown when ammTable::Display is called"
	i+=1
done

sleep 1
ammTable::Display

# Now, rows will be printed immediately
ammTable::SetDisplayMode "direct"

while [[ $i -lt 40 ]]; do
	ammTable::AddRow "$i" "Name $RANDOM" "Dolor sit amet" "This row is shown immediately"
	sleep .1
	i+=1
done


