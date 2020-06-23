#To retreive the storage details of disk in current system

$disk_data = get-wmiobject -class win32_logicaldisk
$disk_count = $disk_data.Length

echo "The total number of disk in the system is : $disk_count `n"

foreach ($item in $disk_data)
{
    $dev_id = $item.DeviceID
    $used_space = ($item.size - $item.FreeSpace)/1000
    $free_space = $item.FreeSpace/(1024*1024*1024)
    echo "Storage details of Drive $dev_id"
    echo "Used Space (KB): $used_space"
    echo "Free Space (GB): $free_space `n"
}
