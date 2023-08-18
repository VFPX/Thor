Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1								;
		And 'O' = Vartype (lxParam1)		;
		And 'thorinfo' == Lower (lxParam1.Class)

	With lxParam1

		.Prompt		 = 'Project Home Pages'
		.AppID 		 = 'Thor'
		.Description = 'List of Project and links to their home pages'
		.Source		 = 'Thor'
		.Version     = 'Thor - 1.45.16.003 - April 2, 2023'
		.Sort		 = 20

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

	lcFormFileName = Execscript (_Screen.cThorDispatcher, 'Full Path=Thor_Proc_ProjectHomePages.SCX')
	Do Form (lcFormFileName)

Endproc
