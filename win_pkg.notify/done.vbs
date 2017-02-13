' keep progress on top
Dim strHTAexe
Dim objWMIService 
Dim colProcessList 
Dim a
Dim objProcess
Dim WshShell
Dim InputFile
Dim FSO, oFile
Dim objFile

Set WshShell = CreateObject("WScript.Shell")

' check if reboot_required isn't empty and quit if true, reboot
InputFile= "c:\salt\win_pkg.notify\reboot_required"
Set FSO = CreateObject("Scripting.FileSystemObject") 
If FSO.FileExists(InputFile) then
    SET objFile = FSO.GetFile(InputFile)
    If objFile.Size > 0 then
      WshShell.Run "shutdown /r"
      Wscript.Quit(0)
    End If
End If

strHTAexe = "MSHTA.EXE"

    WshShell.Run "c:\salt\win_pkg.notify\done.hta"

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

      wshShell.AppActivate "Software Updates"

    loop