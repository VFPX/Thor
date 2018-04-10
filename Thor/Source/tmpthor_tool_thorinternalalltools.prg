Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1
		.Prompt		 = 'All Thor Tools'
		.Description = 'Menu of all tools registered with Thor'
		.Source		 = 'Thor'
		.Version	 = 'Thor 1.065 - Oct. 14, 2011'
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
	Do '<<tcFolder>>Thor.APP' with 'All Tools'
EndProc
