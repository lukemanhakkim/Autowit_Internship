#########################
#Import Modules
#########################
Import-Module $home\Desktop\powershell-modules\AddImagesToWordDocument.psm1

$Time = Read-Host "Enter the time(in Seconds) to monitor the system"

#Stopwatch
$stopWatch = [system.diagnostics.stopwatch]::StartNew()
$timeSpan = New-TimeSpan -Minutes 0 -Seconds $Time


##########################
# Capturing a screenshot
##########################

function take_screenshots ($File)
{
    #$File = "$home\Desktop\MyFancyScreenshot.bmp"
    Add-Type -AssemblyName System.Windows.Forms
    Add-type -AssemblyName System.Drawing
    # Gather Screen resolution information
    $Screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
    $Width = $Screen.Width
    $Height = $Screen.Height
    $Left = $Screen.Left
    $Top = $Screen.Top
    # Create bitmap using the top-left and bottom-right bounds
    $bitmap = New-Object System.Drawing.Bitmap $Width, $Height
    # Create Graphics object
    $graphic = [System.Drawing.Graphics]::FromImage($bitmap)
    # Capture screen
    $graphic.CopyFromScreen($Left, $Top, 0, 0, $bitmap.Size)
    # Save to file
    $bitmap.Save($File) 
    Write-Output "Screenshot saved to:"
    Write-Output $File
}

$pos_str = "`n"
$keystr=""

#step1
$count=0
do
{

     #To monitor the keystrokes
     # wait for a key to be available:
     if ([Console]::KeyAvailable)
     {
        # read the key, and consume it so it won't
        # be echoed to the console:
        $keyInfo = [Console]::ReadKey($true)
        $keychar = $keyInfo.KeyChar
        $keystr = $keystr + $keychar
     }

 $mouse_events = [System.Windows.Forms.UserControl]::MouseButtons
 if (($mouse_events -like "left") -or ($mouse_events -like "right"))
 {
     
     #To monitor the mouse coordinates
     $pos = [System.Windows.Forms.Cursor]::Position
     $pos_str = $pos_str + "The Mouse coordinates are $pos`n"

     #To capture the screenshots on click 
     echo "captured" 
     Start-Sleep -Seconds 1
     $count +=1
     $File = "$home\Desktop\screenshots\MyScreenshot" + $count + ".bmp"
     take_screenshots ($File)
     continue
     
 }

}until ($stopWatch.Elapsed -ge $timeSpan)


#To write the
Add-OSCPicture -WordDocumentPath "$home\Desktop\Images.docx" -ImageFolderPath "$home\Desktop\screenshots"


$Result_str = $pos_str + "`n Keystrokes Used during the session: `n " + $keystr
$Result_str

function append_data_to_word($savepath)
{
    $wdStory = 6 
    $wdMove = 0
    $objWord = New-object -comobject Word.Application  
    $objWord.Visible = $True 
    $objDoc = $objWord.Documents.Open($savepath) 
    $objSelection = $objWord.Selection 
    $a = $objSelection.EndKey($wdStory, $wdMove) 
    $objSelection.TypeParagraph() 
    $objSelection.TypeParagraph() 
    $text = "This text was appended to an existing Word document." 
    $objSelection.TypeText($result_str) 
    $objdoc.SaveAs([ref]$savepath) 
    $objdoc.Close() 
    $objword.quit() 
} 

$savepath = "$home/Desktop/Images.docx"
append_data_to_word($savepath)

