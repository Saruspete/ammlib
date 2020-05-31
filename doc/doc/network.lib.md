
* [_ammNetwork::CalcGetIpSegment](#_ammNetworkCalcGetIpSegment)
* [ammNetwork::Calc](#ammNetworkCalc)


## _ammNetwork::CalcGetIpSegment

 Returns the requested segment of the IP address
### Arguments

* $1  (string) IP Address (4 or 6)
* $2  (int)    Segment number of the IP address to return (starts at 0)

## ammNetwork::Calc

 Calculate
### Arguments

* $1  (string) IP Address to extract data from. "ip/cidr" or "ip netmask"
* $@  (string[]) Fields to show: ip prefix netmask network brdcast

