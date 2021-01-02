# shellcheck shell=bash

Describe "string.lib"
	Include "../ammlib"
	Before "ammLib::Require string"

	typeset -a _demoArrayWords=(hello world pouet coin lol rofl mao)


	Describe "ammString::Contains"
		It "returns success if a simple string is contained in another"
			When call ammString::Contains "wor" "hello world"
			The status should be success
		End
		It "returns success if a complex string is contained in another"
			When call ammString::Contains "w*l" "hello world"
			The status should be success
		End
		It "returns failure if the string is not contained in another"
			When call ammString::Contains "toto" "hello world"
			The status should be failure
		End
	End

	Describe "ammString::ContainsWord"
		It "returns success if first arg is also one of other args"
			When call ammString::ContainsWord "rofl" "${_demoArrayWords[@]}"
			The status should be success
		End
		It "returns failure if first arg is not in one of other args"
			When call ammString::ContainsWord "ohohoh" "${_demoArrayWords[@]}"
			The status should be failure
		End
	End

	Describe "ammString::StartsWith"
	End

	Describe "ammString::EndsWith"
	End

	Describe "ammString::IsNotEmpty"
	End

	Describe "ammString::IsEmpty"
	End

	Describe "ammString::IsFile"
	End

	Describe "ammString::IsDirectory"
	End

	Describe "ammString::IsInteger"
	End

	Describe "ammString::IsHex"
	End

	Describe "ammString::IsYes"
	End

	Describe "ammString::IsNo"
	End

	Describe "ammString::IsYesNo"
	End

	Describe "ammString::IsTrue"
	End

	Describe "ammString::IsIPv4"
		It "returns success if arg is an usual IPv4"
			When call ammString::IsIPv4 "10.20.30.40"
			The status should be success
		End
		It "returns success if arg is a short IPv4"
			When call ammString::IsIPv4 "1.1"
			The status should be success
		End
		It "returns failure if arg is a bad usual IPv4"
			When call ammString::IsIPv4 "1.2.4.555"
			The status should be failure
		End
		It "returns failure if arg is a bad short IPv4"
			When call ammString::IsIPv4 "1.256"
			The status should be failure
		End
	End

	Describe "ammString::IsIPv6"
		It "returns success if arg is a good full IPv6"
			When call ammString::IsIPv6 "9999:FFFF:ABCD:EFF:0000:8a2e:0370:7334"
			The status should be success
		End
		It "returns success if arg is a good short IPv6"
			When call ammString::IsIPv6 "::1"
			The status should be success
		End
		It "returns success if arg is a good short IPv6"
			When call ammString::IsIPv6 "1::1"
			The status should be success
		End
		It "returns failure if arg is a not a good full IPv6"
			When call ammString::IsIPv6 "9999:FFFF:ABCD:EFG:0000:8a2e:0370:7334"
			The status should be failure
		End
		It "returns failure if arg is a not a good short IPv6"
			When call ammString::IsIPv6 "1::G::1"
			The status should be failure
		End
	End

	Describe "ammString::IsIP"
	End

	Describe "ammString::IsUri"
	End

	Describe "ammString::IsDate"
	End

	Describe "ammString::IsTime"
	End

	Describe "ammString::Type"
	End


	Describe "ammString::Trim"
		It "removes trailing and ending spaces and tabs by default"
			When call ammString::Trim "		   toto	  "
			The stdout should eq "toto"
		End

		It "removes trailing and ending specified chars"
			When call ammString::Trim "-- toto --" "[- ]"
			The stdout should eq "toto"
		End
	End

	Describe "ammString::ToCapital"
	End

	Describe "ammString::ToLower"
	End

	Describe "ammString::ToUpper"
	End

	Describe "ammString::ExtractCmdLine"
	End

	Describe "ammString::InputToLines"
	End

	Describe "ammString::UnitToPow"
	End

	Describe "ammString::UnitConvert"
	End

	Describe "ammString::BaseConvert"
	End

	Describe "ammString::HexToDec"
	End

	Describe "ammString::DecToHex"
	End

	Describe "ammString::IPv4ToHex"
	End

	Describe "ammString::HexToIPv4"
	End

	Describe "ammString::IntegerMin"
	End

	Describe "ammString::IntegerMax"
	End

	Describe "ammString::IntegerAverage"
	End

	Describe "ammString::IntegerSum"
	End

	Describe "ammString::Filter"
	End

	Describe "ammString::FilterTuples"
	End

	Describe "ammString::CountWords"
	End

	Describe "ammString::CountLines"
	End

	Describe "ammString::SortWords"
	End


	Describe "ammString::ExpandStringBash"
		It "Expands a string like simple bash expansion"
			When call ammString::ExpandStringBash '{1..5}'
			The output should eq "1 2 3 4 5 "
		End
		It "Expands a string like simple bash expansion with prefix and suffix"
			When call ammString::ExpandStringBash 'hello-{1,2}_world' 'hi_{1..3}_jack' 'omg_{1,2-4,6}_wtfbbq'
			The output should eq "hello-1_world hello-2_world hi_1_jack hi_2_jack hi_3_jack omg_1_wtfbbq omg_2-4_wtfbbq omg_6_wtfbbq "
		End
		It "Expands a string like bash expansion with nested groups"
			When call ammString::ExpandStringBash 'hello_{world,master-{1..2}}'
			The output should eq "hello_world hello_master-1 hello_master-2 "
		End
		It "Expands a string like bash expansion with FQDN"
			When call ammString::ExpandStringBash 'host-{01..05}.dev.intra'
			The output should eq "host-01.dev.intra host-02.dev.intra host-03.dev.intra host-04.dev.intra host-05.dev.intra "
		End

		It "Expands a string like bash expansion with complex nested groups"
			When call ammString::ExpandStringBash 'hello_{world-{01..04},master,slave{1..3}}'
			The output should eq "hello_world-01 hello_world-02 hello_world-03 hello_world-04 hello_master hello_slave1 hello_slave2 hello_slave3 "
		End
	End

	Describe "ammString::ExpandIntegerList"
		It "Expands a grouped string as an ordered list"
			When call ammString::ExpandIntegerList "7-10,11,12,5,8,1,11-14"
			The stdout should eq "1 5 7 8 9 10 11 12 13 14 "
		End
		It "Emits a warning if an element is invalid"
			When call ammString::ExpandIntegerList "7-10,11,12,a-f,14-16"
			#The stderr should include "is not an integer"
			The stdout should eq "7 8 9 10 11 12 14 15 16 "
		End
	End


	Describe "ammString::UUIDVersionGet"
		Parameters
			"00000000-0000-0000-0000-000000000000" "0"
			"61dc1f09-4c9e-11eb134f-00d86113b7d2"  "1"
			"78e58f3a-aff6-377a-cc5b-da43e9a30794" "3"
			"fcaf1927-ab1f-4cc1-9f37-1e0d5da137aa" "4"
			"060470a1-4756-5543-3a00-c7ed9dfcb865" "5"
		End

		Example "Extracts version of UUIDv$2"
			When call ammString::UUIDVersionGet "$1"
			The output should eq "$2"
		End
	End

	Describe "ammString::UUIDGenerate"
		checkuuid() {
			[ $(ammString::UUIDVersionGet "${checkuuid:?}") -eq "$1" ]
		}

		Example "Generate UUID v1"
			When call ammString::UUIDGenerate 1
			The output should satisfy checkuuid 1
		End
		Example "Generate UUID v3"
			When call ammString::UUIDGenerate 3
			The output should satisfy checkuuid 3
		End
		Example "Generate UUID v4"
			When call ammString::UUIDGenerate 4
			The output should satisfy checkuuid 4
		End
	End


	Describe "ammString::HashMD5"
		Parameters
			"d41d8cd98f00b204e9800998ecf8427e" ""
			"7215ee9c7d9dc229d2921a40e899ec5f" " "
			"5eb63bbbe01eeed093cb22bb8f5acdc3" "hello world"
		End
		Example "Checks MD5 of '$2'"
			When call ammString::HashMD5 "$2"
			The output should eq "$1"
		End
	End

	Describe "ammString::HashSHA1"
		Parameters
			"da39a3ee5e6b4b0d3255bfef95601890afd80709" ""
			"b858cb282617fb0956d960215c8e84d1ccf909c6" " "
			"2aae6c35c94fcfb415dbe95f408b9ce91ee846ed" "hello world"
		End
		Example "Checks MD5 of '$2'"
			When call ammString::HashSHA1 "$2"
			The output should eq "$1"
		End
	End

	Describe "ammString::Repeat"
	End

End
