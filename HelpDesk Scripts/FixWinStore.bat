@net use F: "\\Frs\software\tech staff\matt\powershell\image config\scripts" 2>NUL >NUL
@powershell -command "Set-ExecutionPolicy -ExecutionPolicy Bypass"
@powershell "F:\Repair-WinStore.ps1"
@powershell -command "Set-ExecutionPolicy -ExecutionPolicy Restricted"
@net use F: /delete /yes 2>NUL >NUL