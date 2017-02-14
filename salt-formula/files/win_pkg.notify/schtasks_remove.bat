for /f "tokens=2 delims=\" %%x in ('schtasks /query /fo:list ^| findstr "win_pkg.notify"') do schtasks /Delete /TN %%x /F
