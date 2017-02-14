'c:\salt\win_pkg.notify\schtasks_remove.bat':
  cmd.run

'c:\salt\win_pkg.notify':
  file.absent

'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Application\SaltMinion':
  reg.absent
