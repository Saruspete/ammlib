
* [ammTable::Create](#ammTableCreate)
* [ammTable::AddColumn](#ammTableAddColumn)
* [ammTable::AddRow](#ammTableAddRow)
* [ammTable::Display](#ammTableDisplay)
* [ammTable::DisplayHeader](#ammTableDisplayHeader)
* [ammTable::DisplayRow](#ammTableDisplayRow)


## ammTable::Create

 Create a new table, optionally with structure
### Arguments

* $1 
* $@  Columns to be added, format: "Name|option:size"

## ammTable::AddColumn

 Add a new column to the table
### Arguments

* $1  (string) Name of the column
* $@  (string) Configuration of the column

## ammTable::AddRow

 Add a new row to the table
### Arguments

* # @args $@  Each column in order

## ammTable::Display

 Display the table
function ammTable::Display {
## ammTable::DisplayHeader


Display the header on first invocation
	if [[ "$__AMMTABLE_DISPLAYPOS" == "0" ]]; then
		ammTable::DisplayHeader
	fi

Display rows
	while [[ $__AMMTABLE_DISPLAYPOS -lt ${#__AMMTABLE_ROWS[@]} ]]; do
		ammTable::DisplayRow $__AMMTABLE_DISPLAYPOS
		__AMMTABLE_DISPLAYPOS+=1
	done


	return 0
}


function ammTable::DisplayHeader {
## ammTable::DisplayRow

 Display only specific row

function ammTable::DisplayRow {
