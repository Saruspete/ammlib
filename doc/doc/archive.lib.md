
* [_ammArchive::Proxy](#_ammArchiveProxy)
* [ammArchive::FormatFromFile](#ammArchiveFormatFromFile)
* [ammArchive::Extract](#ammArchiveExtract)
* [ammArchive::Add](#ammArchiveAdd)


## _ammArchive::Proxy

 Call the real function from the library
### Arguments

* $1  (string) Operation to call on the sub-library
* $2  (path)   file o
* $3  (string) Format for the archive if not guessable from file
* $@  (string[])  Options to pass to the called function

## ammArchive::FormatFromFile

 Get the archive format usable for library loading
### Arguments

* $1  (path) Archive file to be checked for format
* $2  (path) Optional format hint or fallback

## ammArchive::Extract

 Unpack an archive
function ammArchive::Extract {
## ammArchive::Add

 Add a file or folder to an archive
### Arguments

* $1  (file) Archive on which to add the file
* $2  (path) optionnal prefix for the content to be added
* $@  (path[]) Files or folders to be added to the archive

