@net use Y: "\\frs\software\tech staff\matt\powershell\image config"

@md C:\Windows\System32\WindowsPowershell\v1.0\Modules\PSWindowsUpdate
@robocopy "Y:\PSWindowsUpdate" "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\PSWindowsUpdate" /s /njh /njs /ndl /nc /ns

@powershell -command "Set-ExecutionPolicy -ExecutionPolicy Bypass"

@powershell -command "Get-WUInstall -NotKBArticleID KB3012973,KB2876229 -AcceptAll"

@net use Y: /delete /yes