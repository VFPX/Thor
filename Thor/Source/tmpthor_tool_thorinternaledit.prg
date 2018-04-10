Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1
		.Prompt		 = 'Edit Thor'
		.Summary     = 'Form for Thor'
		.Description = 'Opens main Thor form: assign hot keys to tools, create popup menus and assign hot keys to them,';
			+ ' modify VFP system menus, etc.'
		.FolderName	 = '<<tcFolder>>'
		.Source		 = 'Thor'
		.Version	 = 'Thor 1 - Oct. 14, 2011'
		.Sort		 = 10
	Endwith

	Return lxParam1
Endif

Do ToolCode

Return

****************************************************************
****************************************************************
* Normal processing for this tool begins here.
Procedure ToolCode
	Do '<<tcFolder>>Thor.APP' with 'Edit'
EndProc
