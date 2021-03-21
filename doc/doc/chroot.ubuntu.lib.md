
* [function ammChrootUbuntu::Init {](#function-ammchrootubuntuinit-)
* [function ammChrootUbuntu::InitFromPkg {](#function-ammchrootubuntuinitfrompkg-)
* [function ammChrootUbuntu::Clean {](#function-ammchrootubuntuclean-)


## function ammChrootUbuntu::Init {

Init a new ubuntu chroot, from host yum config or from template

## function ammChrootUbuntu::InitFromPkg {

 Create a new chroot 

### Arguments

* $1  (path) Location of the chroot to be created
* $2  (string) Version of the ubuntu release to be created
* $@  (string) (optional) Tuples "name=url" of repositories to be set, instead of defaults

## function ammChrootUbuntu::Clean {

@description: remove all non-necessary files

