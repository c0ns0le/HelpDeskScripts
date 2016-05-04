@Title Clearing OneDrive Cache...
@echo ---------------------
@echo.
@echo !!!!!! WARNING !!!!! 
@echo THIS WILL ERASE ALL FILES IN THE LOCAL ONEDRIVE FOR BUSINESS FOLDER.
@echo BACKUP THE FOLDER IF THERE ARE ANY UNSYNCED CHANGES (RED X ON FOLDER).
@echo.
@echo ---------------------
@echo.
@echo IF YOU NEED TO BACKUP DO NOT PRESS ANY KEYS AND CLOSE THIS WINDOW. 
@echo.
@echo ---------------------
@echo.
@PAUSE
@echo.
@echo SEARCHING FOR AND CLOSING ALL MICROSOFT OFFICE PROCESSES...
@echo.

@taskkill /im "csisyncclinet.exe" /f
@taskkill /im "outlook.exe" /f
@taskkill /im "excel.exe" /f
@taskkill /im "groove.exe" /f
@taskkill /im "msosync.exe" /f
@taskkill /im "msouc.exe" /f
@taskkill /im "onenote.exe" /f
@taskkill /im "onenotem.exe" /f
@taskkill /im "powerpnt.exe" /f
@taskkill /im "sysdrive.exe" /f
@taskkill /im "winword.exe" /f
@taskkill /im "skydrive.exe" /f

@echo.
@echo FINISHED.
@echo.
@echo ---------------------
@echo.
@PAUSE
@echo.
@echo REMOVING ONEDRIVE FILES AND CLEARING CACHE...
@echo.

@cd %userprofile%
@rmdir "Onedrive for Business" /s /q
@rmdir "OneDrive - Forest Ridge School of the Sacred Heart" /s /q
@rmdir "SharePoint" /s /q
@cd %localappdata%\Microsoft\Office\15.0\
@rmdir "OfficeFileCache" /s /q
@cd %localappdata% \Microsoft\Office\
@rmdir "Spw" /s /q

@echo.
@echo THE ONEDRIVE FILES AND THE ONEDRIVE CACHE HAVE BEEN CLEARED. 
@echo TRY SYNCING ONEDRIVE AGAIN FROM PORTAL.OFFICE.COM TO VERIFY ISSUE RESOLVED. 
@echo.
@echo ---------------------
@echo.
@PAUSE
@echo.
@"C:\Program Files (x86)\Internet Explorer\iexplore.exe" portal.office.com
Exit