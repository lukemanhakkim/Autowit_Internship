<#To get the latency of given server, The folloqing input denotes the respective servers:
            1. North America
            2. South America
            3. Europe
            4. Africa
            5. Asia
            6. Australia
            7. Middle East       
#>

$server_dict = @{"1" = "69.162.81.155"; "2" = "131.255.7.26"; "3" = "95.142.107.181"; "4" = "Johannesburg"; "5" = "103.120.178.71"; "6" = "223.252.19.130"; "7" = "185.229.226.83"}


Write-Host "Enter the server you want to check the latency :
            1. North America
            2. South America
            3. Europe
            4. Africa
            5. Asia
            6. Australia
            7. Middle East       
            "
 
$server = Read-Host -Prompt 'Input your selection'


#To check the latency of given server
$latencyCheck = Test-Connection $server_dict[$server]

$tot_latency = 0

foreach ($item in $latencyCheck)
{
    $tot_latency  = $tot_latency + $item.ResponseTime
}


$avg_latency = $tot_latency/$latencyCheck.Length


Write-Host "The Average latency for the selected server is $avg_latency"