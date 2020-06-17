$str1 = "
################################################
The NIC information for the current laptop is -
################################################
"
$str2 = "
#####################################################
Global Variables of in the current PC are
#####################################################
"
$str1 | Out-File -FilePath $home\Desktop\output1.txt -Append
ipconfig | Out-File -FilePath $home\Desktop\output1.txt -Append
$str2 | Out-File -FilePath $home\Desktop\output1.txt -Append
Get-Variable -Scope global | Out-File -FilePath $home\Desktop\output1.txt -Append