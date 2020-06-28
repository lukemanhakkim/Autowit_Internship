<#To create a new incident ticket
#>

#Defining the base URL
$base_url = "https://dev81611.service-now.com/"

#credentials
$username = "<username>"
$password = "<password>"

#Defining headers
$base64auth = [convert]::TOBase64string([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username, $password)))


$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add('Authorization',('Basic {0}' -f $base64auth))
$headers.Add('Accept','application/json')
$headers.Add('Content-Type','application/json')


#set TLS version
[Net.ServicePointManager]::SecurityProtocol = [Net.securityprotocoltype]::Tls12

#End point uri
$uri = $base_url + "api/now/v1/table/incident"


#specify HTTP method:
$method = "post"

#specify the body:


$body = @{ 
    caller_id="abel.tuter"
    priority= "2"
    severity="3"
    contact_type= "test@gmail.com"
    short_description= "To create a new incident ticket"
    description= "Test script to create a new incident ticket"
    }

$data = $body | ConvertTo-Json

#send Http request:
$response4 = Invoke-WebRequest -Headers $headers -Method $method -Uri $uri -Body $data -ContentType "application/json"

$response4
