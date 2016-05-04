@net use J: "\\Frs\software\tech staff\matt\powershell\image config\scripts" 2>NUL >NUL
@powershell -command "Set-ExecutionPolicy -ExecutionPolicy Bypass"
@powershell "J:\Delete-WinOld.ps1"
@powershell -command "Set-ExecutionPolicy -ExecutionPolicy Restricted"
@net use J: /delete /yes 2>NUL >NUL