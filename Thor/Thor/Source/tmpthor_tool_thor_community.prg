#Define ThorCommunityURL 		'http://groups.google.com/group/FoxProThor'

Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1
		.Prompt		 = 'Community / Discussions'
		.Description = 'Link to home page for discussions about Thor'
		.Source		 = 'Thor'
		.Version	 = 'Thor 1.02 - Sept. 23, 2011'
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
	Local loLink
	loLink = Newobject ('_ShellExecute', Home() + 'FFC\_Environ.vcx')
	loLink.ShellExecute (ThorCommunityURL)
EndProc
