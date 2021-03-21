
* [function ammTable::Create {](#function-ammtablecreate-)
* [function ammTable::AddColumn {](#function-ammtableaddcolumn-)
* [function ammTable::AddRow {](#function-ammtableaddrow-)
* [function ammTable::Display {](#function-ammtabledisplay-)
* [function ammTable::DisplayRow {](#function-ammtabledisplayrow-)


## function ammTable::Create {

 Create a new table, optionally with structure

### Arguments

* $1 
* $@  Columns to be added, format: "Name|option:size"

## function ammTable::AddColumn {

 Add a new column to the table

### Arguments

* $1  (string) Name of the column
* $@  (string) Configuration of the column

## function ammTable::AddRow {

 Add a new row to the table

### Arguments

* # @args $@  Each column in order

## function ammTable::Display {

 Display the table

## function ammTable::DisplayRow {

 Display only specific row

