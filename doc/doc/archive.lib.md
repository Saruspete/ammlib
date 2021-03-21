
* [function ammArchive::_Proxy {](#function-ammarchiveproxy-)
* [function ammArchive::FormatFromFile {](#function-ammarchiveformatfromfile-)
* [function ammArchive::Unpack {](#function-ammarchiveunpack-)
* [function ammArchive::Pack {](#function-ammarchivepack-)
* [function ammArchive::Add {](#function-ammarchiveadd-)


## function ammArchive::_Proxy {

 Call the real function from the library

### Arguments

* $1  (string) Operation to call on the sub-library
* $2  (path)   file o
* $3  (string) Format for the archive if not guessable from file
* $@  (string[])  Options to pass to the called function

## function ammArchive::FormatFromFile {

 Get the archive format usable for library loading

### Arguments

* $1  (path) Archive file to be checked for format
* $2  (path) Optional format hint or fallback

## function ammArchive::Unpack {

 Extract an archive

### Arguments

* $1  (path) File to unpack
* $2  (path) Folder to extract files to
* $@  (path) Content to extract from the archive

## function ammArchive::Pack {

 Create an archive

### Arguments

* $1  (path) File to create
* $2  (path) Root folder to add in archive
* $@  (path) optional: select files relative to root folder to add

## function ammArchive::Add {

 Add a file or folder to an archive

### Arguments

* $1  (file) Archive on which to add the file
* $2  (path) optionnal prefix for the content to be added
* $@  (path[]) Files or folders to be added to the archive

