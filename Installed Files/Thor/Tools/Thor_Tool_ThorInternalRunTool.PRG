Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1								;
		And 'O' = Vartype (lxParam1)		;
		And 'thorinfo' == Lower (lxParam1.Class)

	With lxParam1

		.Prompt		 = 'Tool Launcher'
		.AppID 		 = 'Thor'
		.Description = 'Find and run tools, browse descriptions, set options, ...'
		.Source		 = 'Thor'
		.Version     = 'Thor - 1.45.26 - June 21, 2023'
		.Sort		 = 20
		.CanRunAtStartUp = .T.
		.VideoLink   = 'http://youtu.be/2ttBR9vQqew'

	Endwith

	Return lxParam1
Endif

If Pcount() = 0
	Do ToolCode
Else
	Do ToolCode With lxParam1
Endif

Return

****************************************************************
****************************************************************
* Normal processing for this tool begins here.                  
Procedure ToolCode
	Lparameters lxParam1

	Execscript (_Screen.cThorDispatcher, 'FORMRUNTOOL')

Endproc
