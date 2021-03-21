
* [function _ammPkgPortage::Portage {](#function-ammpkgportageportage-)
* [function _ammPkgPortage::Portageq {](#function-ammpkgportageportageq-)
* [function _ammPkgPortage::Equery {](#function-ammpkgportageequery-)
* [function ammPkgPortage::DownloadRecursive {](#function-ammpkgportagedownloadrecursive-)
* [function ammPkgPortage::Download {](#function-ammpkgportagedownload-)
* [function ammPkgPortage::Extract {](#function-ammpkgportageextract-)


## function _ammPkgPortage::Portage {

 (private) proxy for rpm executable

### Arguments

* $1  (string) Action for RPM to exec

## function _ammPkgPortage::Portageq {

 Query the portage database

## function _ammPkgPortage::Equery {

Wrapper for equery, provided by app-portage/gentoolkit. See portageq

## function ammPkgPortage::DownloadRecursive {

 Download an archive from configured yum repositories and all dependencies

### Arguments

* $1  (path)     Path where to download the packages (will be created if does not exists)
* $@  (string[]) Packages to download

### Output on stdout

*  (path[]) List of archives downloaded

## function ammPkgPortage::Download {

 Download an archive from configured yum repositories

### Arguments

* $1  (path)     Path where to download the packages (will be created if does not exists)
* $@  (string[]) Packages to download

### Output on stdout

*  (path[]) List of archives downloaded

## function ammPkgPortage::Extract {

 Extract one or more packages into provided path

### Arguments

* $1  (path)     Where to extract the archives
* $@  (string[]) Archives or package names to be extracted

