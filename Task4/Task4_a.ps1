<#To get the details about the ticket given
#>

#Defining the base URL
$base_url = "https://dev81611.service-now.com/"

#credentials
$username = "<username>"
$password = "<password>"

#ticketnumber
$TicketNumber = "INC"
#Defining headers
$base64auth = [convert]::TOBase64string([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username, $password)))


$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add('Authorization',('Basic {0}' -f $base64auth))
$headers.Add('Accept','application/xml')
$headers.Add('Content-Type','application/xml')


#set TLS version
[Net.ServicePointManager]::SecurityProtocol = [Net.securityprotocoltype]::Tls12

#End point uri
#using ticket id
$uri = $base_url + "api/now/v1/table/incident?number=INC0009009"
#using sys id
#$uri = $base_url + "api/now/v1/table/incident/ 57af7aec73d423002728660c4cf6a71c"

#specify HTTP method:
$method = "get"

#send Http request:
[xml]$response1 = Invoke-webRequest -Headers $headers -Method $method -Uri $uri -UseBasicParsing
$response1.childnodes.result
