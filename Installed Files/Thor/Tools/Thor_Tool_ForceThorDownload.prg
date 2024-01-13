Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1
		.Prompt		 = 'Force Thor Update'
		.AppID 		 = 'Thor'
		.Description = 'Force update to most current version of Thor'
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
	StrToFile(' Force CFU ', _screen.cThorFolder + 'Thorversion.txt', 1)
	MessageBox('Running "Check For Updates" now will force an update of Thor.')
EndProc 