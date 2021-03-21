
* [function ammChrootCentos::Init {](#function-ammchrootcentosinit-)
* [function ammChrootCentos::InitFromPackages {](#function-ammchrootcentosinitfrompackages-)
* [function ammChrootCentos::Clean {](#function-ammchrootcentosclean-)


## function ammChrootCentos::Init {

Init a new CentOS chroot, from host yum config or from template

## function ammChrootCentos::InitFromPackages {

 Create a new chroot 

### Arguments

* $1  (path) Location of the chroot to be created
* $2  (string) Version of the CentOS release to be created
* $@  (string) (optional) Tuples "name=url" of repositories to be set, instead of defaults

## function ammChrootCentos::Clean {

@description: remove all non-necessary files

