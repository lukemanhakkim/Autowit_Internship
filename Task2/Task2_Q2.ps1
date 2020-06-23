#Filtering stopped services in descending order

$stopped_serv = Get-Service | Where-Object {$_.Status -eq "Stopped"} | where {($_.Name -like "a*") -or ($_.Name -like "*s") -or ($_.Name -like "*d") -or ($_.Name -like "*f")} | Sort-Object -Property Name -Descending
$stopped_serv
