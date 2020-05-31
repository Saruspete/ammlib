
* [ammPkg::ManagerDetect](#ammPkgManagerDetect)
* [_ammPkg::Proxy](#_ammPkgProxy)
* [ammPkg::Installed](#ammPkgInstalled)
* [ammPkg::InfoWhatProvides](#ammPkgInfoWhatProvides)
* [_ammPkg::DepsFindBin](#_ammPkgDepsFindBin)
* [ammPkg::FindDeps](#ammPkgFindDeps)
* [ammPkg::ExtractWithDeps](#ammPkgExtractWithDeps)


## ammPkg::ManagerDetect

Detect the package manager for a given path

### Arguments

* **$1** (the): path to search for related package manager

### Output on stdout

*  The package manager library name (without "pkg." prefix). ex: "yum"

## _ammPkg::Proxy

(private) dispatch generic pkg call to selected submodule

### Arguments

* $1  (string) function name to call
* $2  (path)(optionnal)
* $@  (any) argument to pass to the selected function

## ammPkg::Installed

@description: Check if a given package is installed
### Arguments

* $@  (string) Package or string to be checked against

### Output on stdout

*  List of given string and the matching packages

## ammPkg::InfoWhatProvides

 List packages that provides a specified
### Arguments

* $@  (string) Path or glob of a searched file

## _ammPkg::DepsFindBin

Private: lists all libraries needed by a file and all these libraries dependencies too

### Arguments

* $@  file path to scan for librariries

### Output on stdout

* List of libraries path with matching file (their full path)

## ammPkg::FindDeps

Smart extractor for a package, binary or feature and its dependencies

### Arguments

* **...** (string): List of packages, binaries or urls to extract, with their dependencies

## ammPkg::ExtractWithDeps

 Extract required dependencies for a package, binary or feature

### Arguments

* # @args $1 (path)  destination folder where to extract the data
* # @args $@ (string) packages or binaries

