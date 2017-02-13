# salt-win_pkg.notify

adds alerts to logged in users to allow for software updates to complete using windows Task Scheduler

How it works:

1. a task runs daily with a random 1 day delay to check the contents of 2 files... c:\salt\win_pkg.notify\reboot_required and c:\salt\win_pkg.notify\list_upgrades.
  - if anything is in reboot_required, the user will be notified and asked to reboot.  If they select Yes, high state will be run and machine rebooted.  Once rebooted, reboot_required is cleared
  - else, if anything is in list_upgrades, the user will be asked to quit the listed program and retry install.  If they select Retry, Salt will run a pkg.install for any item listed in that folder
  - or if both files are empty, nothing will happen.
