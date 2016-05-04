@echo off
@cd C:\

@cls
@echo Would you like to install or uninstall Software Center?
@echo.
@echo 1 - Install
@echo 2 - Uninstall
@echo 3 - Cancel

:VERLOOP
@set action=3
@set /p action=:

@if %action%==1 ( GOTO INSTALL
) else if %action%==2 ( GOTO UNINSTALL
) else if %action%==3 ( GOTO CANCEL
) else ( echo invalid choice
)

:INSTALL
@echo Installing Software Center...
@net use Y: "\\SCCM\SMS_FRS\bin\i386" 2>NUL >NUL
@echo. 
@pushd Y:
@Y:\ccmsetup.exe /mp:SCCM /logon SMSSITECODE:FRS
@net use Y: /delete 2>NUL >NUL
@Pause
@Exit

:UNINSTALL
@echo Uninstalling Software Center...
@echo. 
@C:\Windows\ccmsetup\ccmsetup.exe /uninstall 
@Pause
@Exit


:CANCEL
@echo Cancelled script
@Pause
Exit




