DIM strComputer,strProcess
strComputer = "."
strProcess = "iexplore.exe"

DO
IF isProcessRunning(strComputer,strProcess) THEN
ELSE
	SET objIE = CreateObject("InternetExplorer.Application")
	objIE.Toolbar = 0
	objIE.Statusbar = 0
	objIE.Addressbar = 0
	objIE.FullScreen = True
	objIE.Visible = 1
	objIE.GoHome
END IF
LOOP

FUNCTION isProcessRunning(BYVAL strComputer,BYVAL strProcessName)

	DIM objWMIService, strWMIQuery

	strWMIQuery = "Select * from Win32_Process where name like '" & strProcessName & "'"

	SET objWMIService = GETOBJECT("winmgmts:" _
		& "{impersonationLevel=impersonate}!\\" _
			& strComputer & "\root\cimv2")

	IF objWMIService.ExecQuery(strWMIQuery).Count > 0 THEN
		isProcessRunning = TRUE
	ELSE
		isProcessRunning = FALSE
	END IF

END FUNCTION