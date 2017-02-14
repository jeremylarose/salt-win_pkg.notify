# salt-win_pkg.notify

adds alerts to logged in users to allow for software updates to complete using windows Task Scheduler

How it works:

a task runs daily with a random 1 day delay to check the contents of 2 files... c:\salt\win_pkg.notify\reboot_required and c:\salt\win_pkg.notify\list_upgrades.
  - if anything is in reboot_required, the user will be notified and asked to reboot.  If they select Yes, high state will be run and machine rebooted.  Once rebooted, reboot_required is cleared
  - else, if anything is in list_upgrades, the user will be asked to quit the listed program and retry install.  If they select Retry, Salt will run a pkg.install for any item listed in that folder
  - or if both files are empty, nothing will happen.
  
How to install:

download the files and run install.bat or just run the silent executable from releases... https://github.com/jeremylarose/salt-win_pkg.notify/releases

How to use:

should work out of the box, only differences you need to make is not use any "Latest" in your packages

for software that can't install if already open add something like this to the installers (also see autopkg recipes for auto generated packages... https://github.com/jeremylarose/autopkg-recipes)....

:: quit installer if application is running, else continue....
tasklist.exe /FI "IMAGENAME eq KeePass.exe" 2>NUL | find /I /N "KeePass.exe" || goto notrunning
EXIT
:notrunning

for software that requires a reboot, add something like this to the salt state, example...

'echo {{ model }} - DriverPack >> c:\salt\win_pkg.notify\reboot_required':
  cmd.run:
    - onchanges:
      - file: 'c:\salt\drivers\{{ model }}.exe'
    - onlyif:
      - 'if not exist "c:\salt\win_pkg.notify\reboot_required" MD; 2>NUL'
