@Title Clearing Profile Cache...
@echo ---------------------
@echo.
@echo !!!!!! WARNING !!!!! 
@echo ! USE WITH CAUTION !
@echo.
@echo IT IS POSSILBE THAT THIS WILL OVERWRITE ANY FILES IN PROFILE.
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
@powershell -command "J:\scripts\copy-userprofiles.ps1"
@echo Loaner is clean.
@echo.

@net use J: /delete /yes