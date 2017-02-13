Option Explicit 
Dim InputFile 
Dim FSO, oFile 
Dim strData 
Dim objFile
Dim WshShell

Set WshShell = CreateObject("WScript.Shell")

' check if reboot_required isn't empty and quit if true
InputFile= "reboot_required"
Set FSO = CreateObject("Scripting.FileSystemObject") 
If FSO.FileExists(InputFile) then
    SET objFile = FSO.GetFile(InputFile)
    If objFile.Size > 0 then
      WshShell.Run "wscript.exe reboot_required.vbs"
      Wscript.Quit(0)
    End If
End If

' update list_upgrades and wait 120 seconds
WshShell.Run "wscript.exe launchquiet.vbs list_upgrades.bat"
WScript.Sleep 120000

' check if list_upgrade is empty with if statement
InputFile= "list_upgrades"
Set FSO = CreateObject("Scripting.FileSystemObject") 
If FSO.FileExists(InputFile) then
    SET objFile = FSO.GetFile(InputFile)
    If objFile.Size = 0 then
      Wscript.Quit(0)
    End If
End If

Set oFile = FSO.OpenTextFile(InputFile)
strData = oFile.ReadAll 
oFile.Close 

Dim x

x = MsgBox("The following updates are available, but in use.  Please close the these programs and click retry, or click cancel to try again tomorrow: " & vbCr & vbCr & strData, 4101+64,"Software Updates")

If x = vbCancel Then Wscript.Quit(0)

If x = VbRetry Then



WshShell.Run "wscript.exe launchquiet.vbs pkg.upgrade.bat"

' keep progress on top
Dim strHTAexe
Dim objWMIService 
Dim colProcessList 
Dim a
Dim objProcess
strHTAexe = "MSHTA.EXE"

    WshShell.Run "progress.hta"

    set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & "." & "\root\cimv2")

    do

      wscript.sleep 5000

      Set colProcessList = objWMIService.ExecQuery("SELECT * FROM Win32_Process WHERE Name = '" & strHTAexe & "'")

      If colProcessList.count = 0 Then
        wscript.quit
      Else

        a = 0

        For each objProcess in colProcessList
          If inStr(objProcess.commandLine, "progress") <> 0 Then
            a = 1
          End If
        Next

        If Not a = 1 Then
          wscript.quit
        End If

      End If

      wshShell.AppActivate "Software updating..."

    loop

End If