#Include ..\..\Source\Thor.h
*SF 20231130 Change fixed URL to #DEFINE
*#Define ThorFrameworkURL 		'https://github.com/VFPX/Thor/blob/master/Docs/Thor_repository.md'
#Define ThorFrameworkURL 		'https://github.com/'+ccThor_URL+'/blob'+ccThor_Branch+'/Docs/Thor_repository.md'
*/SF 20231130 Change fixed URL to #DEFINE

Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1
		.Prompt		 = 'Link to Thor Repository'
		.AppID 		 = 'Thor'
		.Description = 'Link to Home Page for Thor Repository'
		.Source		 = 'Thor'
		.Version     = 'Thor - 1.45.26 - June 21, 2023'
		.Sort		 = 20
*SF 20231130 Change fixed URL to #DEFINE
*		.Link        = 'https://github.com/VFPX/Thor/blob/master/Docs/Thor_repository.md'
		.Link        = 'https://github.com/'+ccThor_URL+'/blob'+ccThor_Branch+'/Docs/Thor_repository.md'
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
	Local loLink
	loLink = Newobject ('_ShellExecute', Home() + 'FFC\_Environ.vcx')
*SF 20231130 Change fixed URL to #DEFINE
*	loLink.ShellExecute ('https://github.com/VFPX/Thor/blob/master/Docs/Thor_repository.md')
	loLink.ShellExecute ('https://github.com/'+ccThor_URL+'/blob'+ccThor_Branch+'/Docs/Thor_repository.md')
*/SF 20231130 Change fixed URL to #DEFINE
EndProc
