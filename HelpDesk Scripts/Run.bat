@echo off
@net use K: "\\frs\software\tech staff\matt\powershell\image config\drivers"

@echo Installing WACOM driver...
@"K:\Pen.exe" /s
@echo WACOM install finished
@echo.

@echo Installing Synaptics driver...
@"K:\Synaptics\setup.exe" /s /sh
@echo Synaptics install finished
@echo.

@echo Installing WiDi drivers...
@"K:\Widi_Install.exe" /s /v/qn
@echo Widi install finished
@echo.

@net use K: /delete /yes

@net use J: "\\frs\software\tech staff\matt\powershell\image config"

@echo Copying over PowerShell Windows Update module...
@md C:\Windows\System32\WindowsPowershell\v1.0\Modules\PSWindowsUpdate
@robocopy "J:\PSWindowsUpdate" "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\PSWindowsUpdate" /s /njh /njs /ndl /nc /ns
@echo Done copying files
@echo.

@echo Setting execution policy...
@powershell -command "Set-ExecutionPolicy -ExecutionPolicy Bypass"
@echo Policy set
@echo.

@echo Starting update script...
@powershell -noexit "J:\scripts\newimage-updates.ps1"
@echo Updates are finished
@echo.

@net use J: /delete /yes