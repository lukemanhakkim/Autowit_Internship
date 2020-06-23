<#To to a left shift operation in the given array, if [1,2,3,4,5] 
array is given with a left shift of 2 then the output would be [3,4,5,1,2]
#>

#Input array
$arr = 1..5

#Output array
$output_array = @()

#Number of left shift to be made
$no_of_shift = 2

#Array size
$arr_size = $arr.Length

#To find the start of the given left shift in array
$start = $no_of_shift % $arr_size

for ($i = 0; $i -lt $arr_size; $i++)
{ 
    $output_array+=$arr[($start + $i) % $arr_size]
}

$output_array
