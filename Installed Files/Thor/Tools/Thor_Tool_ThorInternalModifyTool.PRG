Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1
		.Prompt		 = 'Modify Tool'
		.AppID 		 = 'Thor'
		.Description = 'Menu to open Thor tools for modification with Modify Command'
		.Source		 = 'Thor'
		.Version     = 'Thor - 1.45.26 - June 21, 2023'
		.Sort		 = 30
	Endwith

	Return lxParam1
Endif

Do ToolCode

Return

****************************************************************
****************************************************************
* Normal processing for this tool begins here.
Procedure ToolCode
	Do _Screen.cThorFolder + '..\Thor.APP' with 'All Tools'
EndProc
