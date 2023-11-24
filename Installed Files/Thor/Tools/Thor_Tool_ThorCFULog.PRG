Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1								;
		And 'O' = Vartype (m.lxParam1)		;
		And 'thorinfo' = Lower (m.lxParam1.Class)

	With m.lxParam1
		.Prompt		 = 'CFU Log folder'
		.AppID 		 = 'Thor'
		.Description = 'Open folder for most recent Check For Updates'
		.Source		 = 'Thor'
	Endwith

	Return m.lxParam1
Endif

Do ToolCode

Return

****************************************************************
****************************************************************
* Normal processing for this tool begins here.
Procedure ToolCode
	Local laFileName[1], lcTempFolder, loUtils

	loUtils		 = Execscript(_Screen.cThorDispatcher, 'thor_proc_utils')
	lcTempFolder = Addbs(Sys(2023))

	m.loUtils.ADirCursor (m.lcTempFolder + 'Thor.CheckForUpdates.*', 'CFULogs', 'D')
	If Reccount('CFULogs') > 0
		Select Trim(Max(FileName)) From cfulogs Into Array laFileName
		Execscript (_Screen.cThorDispatcher, 'Thor_Proc_Shell', m.lcTempFolder + m.laFileName)
	Else
		Messagebox('No CFU logs found Found!', 16)
	Endif

Endproc
