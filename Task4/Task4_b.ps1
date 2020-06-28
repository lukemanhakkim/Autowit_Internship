<#To update the details in the ticket
#>

#Defining the base URL
$base_url = "https://dev81611.service-now.com/"

#credentials
$username = "admin"
$password = "<password>"

#Defining headers
$base64auth = [convert]::TOBase64string([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username, $password)))


$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add('Authorization',('Basic {0}' -f $base64auth))
$headers.Add('Accept','application/json')
$headers.Add('Content-Type','application/json')


#set TLS version
[Net.ServicePointManager]::SecurityProtocol = [Net.securityprotocoltype]::Tls12


#To read the user input
$TicketNum = Read-Host "Enter the ticket number to fetch the details"

#End point uri
#using ticket id
$uri = $base_url + "api/now/v1/table/incident?number=$TicketNum"

#specify HTTP method:
$method = "patch"

#specify the body:
$body = @{ 
severity="1"
}

$data = $body | ConvertTo-Json

#send Http request:
$response2 = Invoke-WebRequest -Headers $headers -Method $method -Uri $uri -Body $data -ContentType "application/json"

$response2
