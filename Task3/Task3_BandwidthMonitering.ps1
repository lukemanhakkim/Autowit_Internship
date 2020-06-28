<# 
The script does the following task:
1. Upload/download speed
2. Latency of any server
3. Bandwidth usage
4. List of VPN information
5. Destination VPN hostname, IP and Mac address
#> 

#Upload/Download speed
Start-SpeedTest

#To check the latency of given server
$latencyCheck = Test-Connection autowit.co
$latencyCheck

#Bandwidth usage
get-netadapterstatistics

#VPN info to get hostname and IP
Get-VpnConnection

#Using the hostname and IP from the above command to get the Mac adddress of VPN
(gwmi -ComputerName DNSNAMEORIPADDRESS -Class Win32_NetworkAdapterConfiguration | where {$_.IPAddress -like '<IP>'}).MACAddress




