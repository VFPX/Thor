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
		.Description = 'Follows link to Thor Home Page'
		.Source		 = 'Thor'
		.Version	 = 'Thor 1.065 - Oct. 14, 2011'
		.Sort		 = 20
		.Link        = 'http://vfpx.codeplex.com/wikipage?title=Thor%20Help'
	Endwith

	Return lxParam1
Endif

Do ToolCode

Return

****************************************************************
****************************************************************
* Normal processing for this tool begins here.
Procedure ToolCode
	Do '<<tcFolder>>Thor.APP' with 'Help'
EndProc
