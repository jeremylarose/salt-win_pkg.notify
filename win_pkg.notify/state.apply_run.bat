:: run state.apply
cd c:\salt
call salt-call state.apply

:: kill hta windows running, only if running and run done task, only if hta running
tasklist /FI "IMAGENAME eq mshta.exe" 2>NUL | find /I /N "mshta.exe">NUL && taskkill /F /IM mshta.exe && eventcreate /T Information /ID 127 /L Application /SO SaltMinion /D "salt task has completed"