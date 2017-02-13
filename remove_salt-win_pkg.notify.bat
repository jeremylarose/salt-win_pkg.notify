@echo off

for /f "tokens=2 delims=\" %%x in ('schtasks /query /fo:list ^| findstr "win_pkg.notify"') do schtasks /Delete /TN %%x /F

RMDIR c:\salt\win_pkg.notify /S /Q

reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Application\SaltMinion" /f

reg.exe delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\salt-win_pkg.notify /f"
reg.exe delete HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\salt-win_pkg.notify /f

start /b "" cmd /c del "%~f0"&exit /b