
* [_ammPkgPortage::Emerge](#_ammPkgPortageEmerge)
* [ammPkgPortage::DownloadRecursive](#ammPkgPortageDownloadRecursive)
* [ammPkgPortage::Download](#ammPkgPortageDownload)
* [ammPkgPortage::Extract](#ammPkgPortageExtract)


## _ammPkgPortage::Emerge

 (private) proxy for rpm executable

### Arguments

* $1  (string) Action for RPM to exec

## ammPkgPortage::DownloadRecursive

 Download an archive from configured yum repositories and all dependencies

### Arguments

* $1  (path)     Path where to download the packages (will be created if does not exists)
* $@  (string[]) Packages to download

### Output on stdout

*  (path[]) List of archives downloaded

## ammPkgPortage::Download

 Download an archive from configured yum repositories

### Arguments

* $1  (path)     Path where to download the packages (will be created if does not exists)
* $@  (string[]) Packages to download

### Output on stdout

*  (path[]) List of archives downloaded

## ammPkgPortage::Extract

 Extract one or more packages into provided path

### Arguments

* $1  (path)     Where to extract the archives
* $@  (string[]) Archives or package names to be extracted

