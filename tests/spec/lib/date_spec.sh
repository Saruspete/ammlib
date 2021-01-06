# shellcheck shell=bash

Describe "date.lib:"
	Include "../ammlib"
	Before "ammLib::Require date"

	date_today() { date "+%d"; }

	Describe "date format translation:"

		Describe "ammDate::ToEpoch"
			Parameters
				"1970-01-01 UTC"          "0"
				"1970-01-01 GMT"          "0"
				"1970-01-01 UTC+1"        "-3600"
				"2000-01-01 UTC"          "946684800"
				"2038-01-19 03:14:08 UTC" "2147483648" # Epoch-alypse
			End

			Example "Translates the date '$1' to epoch '$2'"
				When call ammDate::ToEpoch "$1"
				The output should eq "$2"
			End
		End

		Describe "ammDate::Calculate"
			Parameters
				"1970" "01" "01"    "1970-01-01"
				"1970" "01" "366"   "1971-01-01"
				"1970" "01" "0-1"   "1969-12-30"
				"2016" "12" "781"   "2019-01-20"
			End

			Example "Calculates the fixed offset of '$1 $2 $3' to '$4'"
				When call ammDate::Calculate "$1" "$2" "$3"
				The output should eq "$4"
			End
		End
	End
End
