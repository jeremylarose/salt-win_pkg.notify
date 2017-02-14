pushd "%~dp0"

:: add scheduled tasks
schtasks /create /tn salt-win_pkg.notify /xml c:\salt\win_pkg.notify\win_pkg.notify.xml /f
schtasks /Create /tn salt-win_pkg.notify-list_upgrades /ru "SYSTEM" /sc ONEVENT /MO "*[System[Provider[@Name='SaltMinion'] and EventID=125]]" /ec Application /rl HIGHEST /tr "c:\salt\salt-call pkg.list_upgrades | findstr /V /c:"local:" /c:"----------" /c:"latest" > c:\salt\win_pkg.notify\list_upgrades" /f
schtasks /Create /tn salt-win_pkg.notify-state.apply /ru "SYSTEM" /sc ONEVENT /MO "*[System[Provider[@Name='SaltMinion'] and EventID=126]]" /ec Application /rl HIGHEST /tr "c:\salt\win_pkg.notify\state.apply_run.bat" /f
schtasks /Create /tn salt-win_pkg.notify-pkg.upgrade /ru "SYSTEM" /sc ONEVENT /MO "*[System[Provider[@Name='SaltMinion'] and EventID=128]]" /ec Application /rl HIGHEST /tr "c:\salt\win_pkg.notify\pkg.upgrade_run.bat" /f
schtasks /Create /tn salt-win_pkg.notify-done /ru "Users" /sc ONEVENT /MO "*[System[Provider[@Name='SaltMinion'] and EventID=127]]" /ec Application /tr "c:\salt\win_pkg.notify\done.vbs" /f
schtasks /Create /tn salt-win_pkg.notify-rebooted /ru "SYSTEM" /sc ONSTART /rl HIGHEST /tr "cmd /c break > c:\salt\win_pkg.notify\reboot_required" /f

popd
