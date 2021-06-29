
* [function ammStorage::_GetFromUdev {](#function-ammstoragegetfromudev-)
* [function ammStorage::_GetSysBlockGeneric {](#function-ammstoragegetsysblockgeneric-)
* [function ammStorage::ListUnderlyingDevices {](#function-ammstoragelistunderlyingdevices-)
* [function ammStorage::GetKernelName {](#function-ammstoragegetkernelname-)
* [function ammStorage::GetMajorMinor {](#function-ammstoragegetmajorminor-)
* [function ammStorage::GetNameFromMajorMinor {](#function-ammstoragegetnamefrommajorminor-)
* [function ammStorage::GetBlockSizeAvail {](#function-ammstoragegetblocksizeavail-)


## function ammStorage::_GetFromUdev {

 Get an information from udev

### Arguments

*  $1 (string)   Blockdevice to query, identifiable by ammStorage::GetKernelName
*  $@ (string[]) List of environment fields provided by udev to be fetched

## function ammStorage::_GetSysBlockGeneric {

 Helper to keep DRY from check & fetch sysfs

### Arguments

* **$1** ((string)): Path from sysfs to fetch
* **$2** ((string)): Device name or path

## function ammStorage::ListUnderlyingDevices {

 Try to find the real underlying device of a given blockdev

## function ammStorage::GetKernelName {

 Returns the kernel (real) name of the device name or path

### Arguments

* $1  (string) Name or path to the device

## function ammStorage::GetMajorMinor {

 Returns the "Major Minor" format of the given device

### Arguments

* $1  (string) Name of path of the block device

## function ammStorage::GetNameFromMajorMinor {

 Returns the device name from the major:minor couple

### Arguments

* $1  (string) Major:Minor like 253:0

## function ammStorage::GetBlockSizeAvail {

#### See also

* [# @seealso:  https://www.seagate.com/fr/fr/tech-insights/advanced-format-4k-sector-hard-drives-master-ti/](## @seealso:  https://www.seagate.com/fr/fr/tech-insights/advanced-format-4k-sector-hard-drives-master-ti/)

