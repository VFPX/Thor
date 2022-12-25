#Define ThorFrameworkURL 		'http://vfpx.codeplex.com/wikipage?title=Thor%20Repository'

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
		.Description = 'Link to Home Page for Thor Repository'
		.Source		 = 'Thor'
		.Version	 = 'Thor 1.065 - Oct. 14, 2011'
		.Sort		 = 20
		.Link        = ThorFrameworkURL
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
	loLink.ShellExecute (ThorFrameworkURL)
EndProc
