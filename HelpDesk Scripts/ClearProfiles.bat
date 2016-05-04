@Title Clearing Profile Cache...
@echo ---------------------
@echo.
@echo !!!!!! WARNING !!!!! 
@echo ! USE WITH CAUTION !
@echo.
@echo AFTER A PROFILE IS DELETED IT CANNOT BE RECOVERED
@echo.
@echo.
@echo ---------------------
@PAUSE
@echo.
@net use J: "\\frs\software\tech staff\matt\powershell\image config"

@powershell -command "Set-ExecutionPolicy -ExecutionPolicy Bypass"
@echo.
@echo ATTEMPTING TO CLEAN UP PROFILES...
@echo.

@echo Starting clean up script...
@powershell -command "J:\scripts\remove-userprofiles.ps1"
@echo Loaner is clean.
@echo.

@net use J: /delete /yes