
* [function _ammPkgYum::Yum {](#function-ammpkgyumyum-)
* [function ammPkgYum::DownloadRecursive {](#function-ammpkgyumdownloadrecursive-)
* [function ammPkgYum::Download {](#function-ammpkgyumdownload-)
* [function ammPkgYum::Extract {](#function-ammpkgyumextract-)
* [function ammPkgYum::ReleaseSet {](#function-ammpkgyumreleaseset-)


## function _ammPkgYum::Yum {

 (private) proxy for rpm executable

### Arguments

* $1  (string) Action for RPM to exec

## function ammPkgYum::DownloadRecursive {

 Download an archive from configured yum repositories and all dependencies

### Arguments

* $1  (path)     Path where to download the packages (will be created if does not exists)
* $@  (string[]) Packages to download

### Output on stdout

*  (path[]) List of archives downloaded

## function ammPkgYum::Download {

 Download an archive from configured yum repositories

### Arguments

* $1  (path)     Path where to download the packages (will be created if does not exists)
* $@  (string[]) Packages to download

### Output on stdout

*  (path[]) List of archives downloaded

## function ammPkgYum::Extract {

 Extract one or more packages into provided path

### Arguments

* $1  (path)     Where to extract the archives
* $@  (string[]) Archives or package names to be extracted

## function ammPkgYum::ReleaseSet {

 Override a release version var

