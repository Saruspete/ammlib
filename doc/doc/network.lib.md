
* [function _ammNetwork::CalcGetIpSegment {](#function-ammnetworkcalcgetipsegment-)
* [function ammNetwork::Calc {](#function-ammnetworkcalc-)
* [function ammNetwork::SocketList {](#function-ammnetworksocketlist-)


## function _ammNetwork::CalcGetIpSegment {

 Returns the requested segment of the IP address

### Arguments

* $1  (string) IP Address (4 or 6)
* $2  (int)    Segment number of the IP address to return (starts at 0)

## function ammNetwork::Calc {

 Calculate

### Arguments

* $1  (string) IP Address to extract data from. "ip/cidr" or "ip netmask"
* $@  (string[]) Fields to show: ip prefix netmask network brdcast

## function ammNetwork::SocketList {

 List all active sockets

### Output on stdout

*  processInode remoteInode socketPath pid [pid..]

