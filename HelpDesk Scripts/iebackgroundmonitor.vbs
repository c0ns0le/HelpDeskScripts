DIM strComputer,strProcess,objWshShell,objIE
strComputer = "."
strProcess = "iexplore.exe"

SET objWshShell = WScript.CreateObject("WScript.Shell")
SET objIE = CreateObject("InternetExplorer.Application")


DO
IF isProcessRunning(strComputer,strProcess) THEN
ELSE
	WITH objIE
		.Navigate "https://mix.office.com/Account?returnurl=%2Fen-us%2FHome"
		
		Do While .Busy Or .readyState <> 4
			WScript.Sleep 50
		Loop

		.Document.getElementById("orgid_lnk").Click
		
		Do While .Busy Or .readyState <> 4
			WScript.Sleep 50
		Loop
		
		.Toolbar = 0
		.Statusbar = 0
		.Addressbar = 0
		.FullScreen = TRUE
		.Visible = 1
		
	END With
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