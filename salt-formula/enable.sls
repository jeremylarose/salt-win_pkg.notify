# ensure needed files exist
'c:\salt\win_pkg.notify':
  file.recurse:
    - source: 'salt://win/config/pkg_notify/files/win_pkg.notify'

# ensure correct permissions
'c:\salt\win_pkg.notify permissions':
  win_dacl.present:
    - name: 'c:\salt\win_pkg.notify'
    - objectType: Directory
    - user: 'Authenticated Users'
    - permission: READ&EXECUTE
    - acetype: ALLOW
    - propagation: FILES

# add scheduled tasks...
'c:\salt\win_pkg.notify\schtasks.bat':
  cmd.script

# add SaltMinion to Applications Logs in event viewer
'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Application\SaltMinion\CustomSource':
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Application\SaltMinion'
    - vname: CustomSource
    - vdata: 1
    - vtype: REG_DWORD
'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Application\SaltMinion\EventMessageFile':
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Application\SaltMinion'
    - vname: EventMessageFile
    - vdata: '%SystemRoot%\System32\EventCreate.exe'
    - vtype: REG_EXPAND_SZ
'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Application\SaltMinion\TypesSupported':
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog\Application\SaltMinion'
    - vname: TypesSupported
    - vdata: 7
    - vtype: REG_DWORD
