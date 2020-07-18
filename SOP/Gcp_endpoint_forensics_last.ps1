<# 
Author: Lukeman Hakkim Sheik Alavudeen

FIREWALL WHITELISTING CLOUD PLATFORM

Step 1 : Login to Google cloud platform API
	Success : Continue to next step.
	Failure : Set “Unable to Log in to your google account please try again.”

Step 2 : Check if target VPC exist.
	Success : Continue to next step.
	Failure : Set “Target VPC does not exist”

Step 3: Check if requested port already open for the target.
	Success: Continue to next step.
	Failure:  The requested port is already open. 

Step 4 : Initiate port opening command for requested destination address.
	Success : Send mail, configuration successful.
	Failure : Set “unable to open requested  firewall port ”
#>	
	


#ErrorHandling
$ErrorAction = 'silentlycontinue'

#step1

#Authenticate using the service account

$JsonPath = Read-host "Enter json key path to activate service account" 
$ServiceAccountName = read-host "Enter service account name"
$PortNum = read-host "Enter the port number"
$Protocol = read-host "Enter the protocol"
$VirtAddr = read-host "Enter the virtual address name"


gcloud auth activate-service-account --key-file=$JsonPath

$AccountsList = gcloud iam service-accounts list

$status = "Not active"
foreach ($Account in $AccountsList)
{
    $name = $Account.contains($ServiceAccountName)  
    $disable = $Account.contains("False")
    if ( ($name -like "True") -and ($disable -like "True"))
    {
      $status="Active"
      $ReturnCode = 0
      Write-Host "Step1: Gcloud service account is login and Active. Returncode: $ReturnCode"
      break
    }
}

if ($status -like "Not active")
{
   $ReturnCode = 2
   Write-Host "Gcloud service account is Not login or Activated. Returncode: $ReturnCode" 
   #exit
}


#step2

$rules = gcloud compute firewall-rules list

foreach ($rule in $rules)
{
    $RuleStatus = $rule.contains($VirtAddr)
    
    if ($RuleStatus -like "True")
    {    
        $ReturnCode = 2
        Write-Host "The Target VPC exists. Returncode: $ReturnCode"
        #exit
    }
}

if ($RuleStatus -like "False")
{
    $ReturnCode = 1
    Write-Host "Step2: The VPC rule does'nt exists. Returncode: $ReturnCode"
}


#step3


$rules = gcloud compute firewall-rules list

foreach ($rule in $rules)
{    
    $RuleStatus = $rule.contains($Protocol+ ":" +$PortNum)
    $disabled = $rule.contains("False")

    if (($RuleStatus -like "True") -and ($disabled -like "True"))
    {
        $ReturnCode = 2
        Write-Host "The requested port is already open. Returncode: $ReturnCode"
    }
}

if($RuleStatus -like "False")
{
$ReturnCode = 1
Write-Host "Step3: The requested port is not configured. Returncode: $ReturnCode"
}


#Step 4

function Send-Email { 
 
$From = read-host "Enter From(sender) Email"
$To = read-host "Enter To(receiver) Email"                                       
$Subject = "Firewall port whitelisting"
$Body =  "The firewall port have been whitelisted sucessfully"
$SMTPServer = "smtp.gmail.com"
$SMTPPort = "587"
                                   

Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer -Credential (Get-Credential) -Port $SMTPPort -UseSsl 

}


$port_cmd = $Protocol + ":" + $PortNum

$response = gcloud compute firewall-rules create $VirtAddr --allow $port_cmd

$RuleStatus = $response[1].contains("False")

if ($RuleStatus -like "True")
{
    $ReturnCode
    write-host "Step4: The firewall port have been configured successfully. Returncode: $ReturnCode"
    $MailStatus = Send-Email
}

else
{
    $ReturnCode = 2
    Write-Host “Unable to open requested  firewall port . Returncode: $ReturnCode"   
}
