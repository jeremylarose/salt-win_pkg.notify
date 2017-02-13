Option Explicit 
Dim InputFile 
Dim FSO, oFile 
Dim strData 
InputFile= "reboot_required"
Dim objFile
Dim WshShell

Set WshShell = CreateObject("WScript.Shell")

' check if list_upgrade is empty with if statement
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

x = MsgBox("The following updates require a reboot.  Would you like to reboot now?  Please close any programs and save any unsaved work, or click No to try again tomorrow: " & vbCr & vbCr & strData, 4100+64,"Software Updates")

If x = vbNo Then Wscript.Quit(0)

If x = VbYes Then


WshShell.Run "wscript.exe launchquiet.vbs state.apply.bat"

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