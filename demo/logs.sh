#!/usr/bin/env bash

set -o nounset
set -o noclobber

export LC_ALL=C
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:$PATH"

readonly MYSELF="$(readlink -f $0)"
readonly MYPATH="${MYSELF%/*}"

. $MYPATH/../ammlib


ammLog::Info "This is an informationnal message"
ammLog::Warning "This is a warning"
ammLog::Error "And this is an error..."

ammLog::Info "You can also log output"
tail -n 3 /etc/passwd | ammLog::Wrn '-'

ammLog::Step "kewkew"
ammLog::Step "With color if you pipe it as stdout" | ammLog::Inf "-"

ammLog::Info "Increasing the log-level to display tracing"
__AMMLOG_VERBOSITY=6

ammLog::StepBegin "This is a step separator"
ammLog::StepBegin "And a new step within"
ammLog::StepBegin "And again one within"
ammLog::StepEnd   0 "Which we end"
ammLog::StepBegin "to redo another one"

ammLog::Warning     "With an embed warning within"
ammLog::Info        "A message"
ammLog::Debug       "A debug message"
ammLog::Debug       "Another debug"
ammLog::Trace       "In case of algorithm issue you can use the tracing"
ammLog::Trace       "Called in loops or something hard to debug"
ammLog::Info        "Another info message"
ammLog::Error       "And an error, with a callstack:"
ammLog::StackLog    "Error"

ammLog::StepEnd   1 "ending with error"
ammLog::StepEnd
ammLog::StepEnd   0 "Finally all done"
ammLog::StepEnd

#ammLog::Die "And now we die..."
ammLog::Fatal "And now we die..."
