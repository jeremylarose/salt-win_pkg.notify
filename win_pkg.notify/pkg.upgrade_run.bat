pushd "%~dp0"

c:\salt\salt-call pkg.list_upgrades | findstr /V /c:"local:" /c:"----------" > list_upgrades

type list_upgrades | findstr /V /c:"        " > pkgs_to_install


REM for /F "tokens=*" %%A in (list_upgrades) do echo %%A >> pkg.temp

if exist pkg.upgrade_results break > pkg.upgrade_results

FOR /f "tokens=1*delims=:" %%A IN (pkgs_to_install) DO call c:\salt\salt-call pkg.install %%A >> pkg.upgrade_results

del pkgs_to_install

popd


:: kill hta windows running, only if running and run done task, only if hta running
tasklist /FI "IMAGENAME eq mshta.exe" 2>NUL | find /I /N "mshta.exe">NUL && taskkill /F /IM mshta.exe && eventcreate /T Information /ID 127 /L Application /SO SaltMinion /D "salt task has completed"