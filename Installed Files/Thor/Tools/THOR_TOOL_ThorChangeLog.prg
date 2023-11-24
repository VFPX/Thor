Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1
		.Prompt		 = "Whats new in Thor"
		.AppID 		 = 'Thor'
		.Description = "Open Change Log for Thor (What's new)"
		.Source		 = 'Thor'
		.Sort		 = 20
	Endwith

	Return lxParam1
Endif

Do ToolCode

Return

****************************************************************
****************************************************************
* Normal processing for this tool begins here.
Procedure ToolCode
	Local lcURL, loThorUtils

	lcURL		= 'https://github.com/VFPX/Thor/blob/master/Change%20Log.md'
	loThorUtils	= Execscript(_Screen.cThorDispatcher, 'thor_proc_utils')
	m.loThorUtils.GoURL(m.lcURL)
	
Endproc