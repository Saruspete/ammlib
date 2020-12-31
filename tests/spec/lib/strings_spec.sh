#shellcheck shell=bash

Describe "string.lib"
	Include "ammlib"
	Before "ammLib::Require string"

	Describe "ammString::Trim"
		When call ammString::Trim
	End
End
