$g_var = Get-Variable -Scope global
$count=0
foreach ($item in $g_var)
{
    if ($count -gt 5)
    {
        break
    }
    $item | Out-File -FilePath $home\Desktop\output1.txt -Append
    $count+=1   
}



