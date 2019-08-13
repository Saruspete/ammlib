
* [ammPkgManagerDetect](#ammPkgManagerDetect)
* [_ammPkgProxy](#_ammPkgProxy)
* [_ammPkgDepsFindBin](#_ammPkgDepsFindBin)
* [ammPkgExtractWithDeps](#ammPkgExtractWithDeps)


## ammPkgManagerDetect

Detect the package manager for a given path

### Arguments

* **$1** (the): path to search for related package manager

### Output on stdout

*  The package manager library name (without "pkg." prefix). ex: "yum"

## _ammPkgProxy

(private) dispatch generic pkg call to selected submodule

### Arguments

* $1  (string) function name to call
* $2  (path)(optionnal)
* $@  (any) argument to pass to the selected function

## _ammPkgDepsFindBin

Private: lists all libraries needed by a file and all these libraries dependencies too

### Arguments

* $@  file path to scan for librariries

### Output on stdout

* List of libraries path with matching file (their full path)

## ammPkgExtractWithDeps

Smart extractor for a package, binary or feature and its dependencies

### Arguments

* **...** (string): List of packages, binaries or urls to extract, with their dependencies

