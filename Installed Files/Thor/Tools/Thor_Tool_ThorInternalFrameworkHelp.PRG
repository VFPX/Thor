#Include ..\..\Source\Thor.h
Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1
		.Prompt		 = 'Help for Thor Framework'
		.AppID 		 = 'Thor'
		.Description = 'Follows link to Thor Home Page'
		.Source		 = 'Thor'
		.Version     = 'Thor - 1.45.26 - June 21, 2023'
		.Sort		 = 20
*SF 20231130 Change fixed URL to #DEFINE
*		.Link        = 'https://github.com/VFPX/Thor/blob/master/Docs/Thor_help.md'
		.Link        = 'https://github.com/'+ccThor_URL+'/blob'+ccThor_Branch+'/Docs/Thor_help.md'
*/SF 20231130 Change fixed URL to #DEFINE
	Endwith

	Return lxParam1
Endif

Do ToolCode

Return

****************************************************************
****************************************************************
* Normal processing for this tool begins here.
Procedure ToolCode
	Do _Screen.cThorFolder + '..\Thor.APP' with 'Help'
EndProc
