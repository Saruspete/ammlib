#!/usr/bin/env bash

set -o nounset
set -o noclobber

export LC_ALL=C
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:$PATH"

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"

. $MYPATH/../ammlib


ammLog::Inf "This is an informationnal message"
ammLog::Wrn "This is a warning"
ammLog::Err "And this is an error..."

ammLog::Inf "You can also log output"
tail -n 3 /etc/passwd | ammLog::Wrn '-'

ammLog::Step "kewkew"
ammLog::Step "With color if you pipe it as stdout" | ammLog::Inf "-"

ammLog::StepBegin "This is a step separator"
ammLog::StepBegin "And a new step within"
ammLog::StepBegin "And again one within"
ammLog::StepEnd   0 "Which we end"
ammLog::StepBegin "to redo another one"
ammLog::Wrn         "With an embed warning within"
ammLog::Inf         "A message"
ammLog::Err         "And an error"
ammLog::StepEnd   1 "ending with error"
ammLog::StepEnd
ammLog::StepEnd   0 "Finally all done"
ammLog::StepEnd

ammLog::Die "And now we die..."
