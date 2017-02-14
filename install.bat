@echo off

cls
echo --------------------------------------------------------
echo .
echo .
echo .      Installing Salt win_pkg.notify - Please Wait
echo .           Window will close once installed
echo .
echo .
echo --------------------------------------------------------


pushd "%~dp0"

:: Add SaltMinion to Applications Logs in event viewer
regedit.exe /s SaltMinion_eventviewer.reg

:: copy folder and give authenticated users read permissions
XCOPY win_pkg.notify c:\salt\win_pkg.notify /E /I /C /Y
icacls "c:\salt\win_pkg.notify" /grant "Authenticated Users":(OI)(CI)RX

:: copy uninstall file to c:\salt
XCOPY remove_salt-win_pkg.notify.bat c:\salt /C /Y

:: add scheduled tasks
schtasks /create /tn salt-win_pkg.notify /xml win_pkg.notify.xml /f
schtasks /Create /tn salt-win_pkg.notify-list_upgrades /ru "SYSTEM" /sc ONEVENT /MO "*[System[Provider[@Name='SaltMinion'] and EventID=125]]" /ec Application /rl HIGHEST /tr "c:\salt\salt-call pkg.list_upgrades | findstr /V /c:"local:" /c:"----------" /c:"latest" > c:\salt\win_pkg.notify\list_upgrades" /f
schtasks /Create /tn salt-win_pkg.notify-state.apply /ru "SYSTEM" /sc ONEVENT /MO "*[System[Provider[@Name='SaltMinion'] and EventID=126]]" /ec Application /rl HIGHEST /tr "c:\salt\win_pkg.notify\state.apply_run.bat" /f
schtasks /Create /tn salt-win_pkg.notify-pkg.upgrade /ru "SYSTEM" /sc ONEVENT /MO "*[System[Provider[@Name='SaltMinion'] and EventID=128]]" /ec Application /rl HIGHEST /tr "c:\salt\win_pkg.notify\pkg.upgrade_run.bat" /f
schtasks /Create /tn salt-win_pkg.notify-done /ru "Users" /sc ONEVENT /MO "*[System[Provider[@Name='SaltMinion'] and EventID=127]]" /ec Application /tr "c:\salt\win_pkg.notify\done.vbs" /f
schtasks /Create /tn salt-win_pkg.notify-rebooted /ru "SYSTEM" /sc ONSTART /rl HIGHEST /tr "cmd /c break > c:\salt\win_pkg.notify\reboot_required" /f
popd

:: add entry to windows programs
reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\salt-win_pkg.notify" /v "DisplayName" /t REG_SZ /d "Salt win_pkg.notify" /f
reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\salt-win_pkg.notify" /v "DisplayVersion" /t REG_SZ /d "1.0.1" /f
reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\salt-win_pkg.notify" /v "UninstallString" /t REG_SZ /d "C:\salt\remove_salt-win_pkg.notify.bat" /f
reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\salt-win_pkg.notify" /v "URLInfoAbout" /t REG_SZ /d "https://github.com/jeremylarose/salt-win_pkg.notify" /f
reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\salt-win_pkg.notify" /v "Publisher" /t REG_SZ /d "Jeremy Larose" /f
reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\salt-win_pkg.notify" /v "InstallLocation" /t REG_SZ /d "C:\salt\salt-win_pkg.notify" /f
