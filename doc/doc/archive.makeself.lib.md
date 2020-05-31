
* [ammArchiveMakeself::Extract](#ammArchiveMakeselfExtract)
* [ammArchiveMakeself::Add](#ammArchiveMakeselfAdd)
* [ammArchiveMakeself::Finalize](#ammArchiveMakeselfFinalize)
* [ammArchiveMakeself::SetLicense](#ammArchiveMakeselfSetLicense)


## ammArchiveMakeself::Extract

 Extract a makeself archive to specified folder
function ammArchiveMakeself::Extract {
## ammArchiveMakeself::Add

	typeset file="$1"
	typeset dest="$2"

	typeset -a opts=("--accept")

TODO: check if archive is makeself
	typeset pass="$(ammArchive::GetPassword "$file")"
	if [[ -n "$pass" ]]; then
		opts+=("--ssl-pass-src" "pass:$pass")
	fi

	bash $file ${opts[@]}
}

function ammArchiveMakeself::Add {
## ammArchiveMakeself::Finalize

 Create the final archive

function ammArchiveMakeself::Finalize {
## ammArchiveMakeself::SetLicense

	typeset file="$1"
	typeset folder="${2:-}"
	typeset label="${3:-}"
	typeset script="${4:-}"

	typeset -i r=0

	typeset -a opts=("--sha256")
	typeset pass="$(ammArchive::GetPassword "$file")"
	if [[ -n "$pass" ]]; then
		opts+=("--ssl-encrypt" "--ssl-passwd" "$pass")
	fi

call makeself
	$AMMARCHIVEMAKESELF_BIN "${opts[@]}" "$folder" "$file" "$label" "$script"
	r+=$?

if the archive exists / was created, clean it up
	if [[ -s "$file" ]]; then
		ammArchiveMakeself::Cleanup "$file"
		r+=$?
	fi

	return $r
}


-----------------------------------------------------------------------------
Non-standard operations
-----------------------------------------------------------------------------
function ammArchiveMakeself::SetLicense {
