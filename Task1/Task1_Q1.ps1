#integer array
$int_array = 1..10

#Json array
$dict_data =  @{
        FirstName='Luke '
        LastName='Hak'
    }

$json_data = ConvertTo-Json -InputObject $dict_data

$json_array = @($json_data)

#String array
$str = "sample_str"

$str_array = @($str)

#Array of arrays
$array_arrays = @($int_array) 

#Hash table array
$dict_array = @( @{
        FirstName='Luke '
        LastName='Hak'
    })

#Get data and time
$date_time = Get-Date -Format "dddd MM/dd/yyyy HH:mm K"
$date_time

#Windows Data Protection API (DPAPI)
$Secure_String_Pwd = ConvertTo-SecureString "P@ssW0rD!" -AsPlainText -Force 

