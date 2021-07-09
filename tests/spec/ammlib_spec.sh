# shellcheck shell=bash

typeset MYSELF="$(realpath $0)"
typeset MYPATH="${MYSELF%/*}"
typeset MYROOT="${MYPATH%/*/*}"

Describe "ammlib:"
	Include "../ammlib"


	Describe "ammLib:: (library management): "
		Describe "ammLib::Locate"
			It "locates the library from its name"
				When call ammLib::Locate "string"
				The output should end with "lib/string.lib"
			End
			It "fails explicitely to locate a non-existant library"
				When call ammLib::Locate "non-existing"
				The output should eq ""
				The status should be failure
			End
		End

		Describe "ammLib::LocatePattern"
		End

		Describe "ammLib::NameFromPath"
		End

		Describe "ammLib::IsSubLib"
		End
		Describe "ammLib::IsLoaded"
		End
		Describe "ammLib::MetaGetPrefix"
		End
		Describe "ammLib::Loadable"
		End
		Describe "ammLib::Load"
		End
		Describe "ammLib::Unload"
		End
		Describe "ammLib::Require"
		End
		Describe "ammLib::GetSymbols"
		End
		Describe "ammLib::Compact"
		End
		Describe "ammLib::ListModules"
		End
	End

	Describe "ammLog: (logging): "
		Describe "ammLog::_ColorJoin"
		End
		Describe "ammLog::Color"
		End
		Describe "ammLog::Time"
		End
		Describe "ammLog::Date"
		End
		Describe "ammLog::_Log"
		End
		Describe "ammLog::_Write"
		End
		Describe "ammLog::Die"
		End
		Describe "ammLog::Error"
		End
		Describe "ammLog::Warning"
		End
		Describe "ammLog::Info"
		End
		Describe "ammLog::Notice"
		End
		Describe "ammLog::Debug"
		End
		Describe "ammLog::Deprecated"
		End
		Describe "ammLog::UnavailableFunc"
		End
		Describe "ammLog::_StepPad"
		End
		Describe "ammLog::EchoSeparator"
		End
		Describe "ammLog::Step"
		End
		Describe "ammLog::StepBegin"
		End
		Describe "ammLog::StepEnd"
		End
		Describe "ammLog::StackDump"
		End
		Describe "ammLog::MissingBin"
		End
		Describe "ammLog::Silence"
		End
		Describe "ammLog::TracingLog"
		End
		Describe "ammLog::TracingEnable"
		End
		Describe "ammLog::WriteTerm"
		End
	End

	Describe "ammSys:: (system ID): "
		Describe "ammSys::OSIdGet"
		End
		Describe "ammSys::OSVersionGet"
		End
	End

	Describe "ammEnv:: (environment): "
		Describe "ammEnv::_Add"
		End
		Describe "ammEnv::PathAdd"
		End
		Describe "ammEnv::LibAdd"
		End
		Describe "ammEnv::ManAdd"
		End
		Describe "ammEnv::IsFunc"
		End
		Describe "ammEnv::IsAlias"
		End
		Describe "ammEnv::IsVar"
		End
		Describe "ammEnv::VarExport"
		End
		Describe "ammEnv::VarReturnArray"
		End
	End

	Describe "ammPath:: (Path management): "
		Describe "ammPath::Decompose"
		End
		Describe "ammPath::IsSecure"
		End
		Describe "ammPath::IsWritable"
		End
		Describe "ammPath::IsEmpty"
		End
		Describe "ammPath::IsValid"
		End
		Describe "ammPath::RecurseFolders"
		End
	End

	Describe "ammExec:: (process execution): "
		Describe "ammExec::Logged"
		End
		Describe "ammExec::SudoIsAble"
		End
		Describe "ammExec::AsUser"
		End
		Describe "ammExec::GetPath"
		End
		Describe "ammExec::Exists"
		End
		Describe "ammExec::RequestOne"
		End
		Describe "ammExec::Require"
		End
		Describe "ammExec::RequireOne"
		End
		Describe "ammExec::IsExecutable"
		End
	End
End
