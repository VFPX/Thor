#Define ccCR  Chr[13]

Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1								;
		And 'O' = Vartype (lxParam1)		;
		And 'thorinfo' == Lower (lxParam1.Class)

	With lxParam1

		* Required
		.Prompt		   = 'Thor TWEeTs' && used in menus

		* Optional
		.Description   = 'Home page for Thor TWEeTs'
		.StatusBarText = ''

		* These are used to group and sort tools when they are displayed in menus or the Thor form
		.Category      = 'Thor' && creates categorization of tools; defaults to .Source if empty

		* For public tools, such as PEM Editor, etc.
		.Author		   = 'Jim Nelson'

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

	If Not Execscript (_Screen.cThorDispatcher, 'Thor_Proc_CheckInternetConnection')
		If 'L' = Vartype (lxParam1)
			Messagebox ('No Internet Connection Found!', 16, 'No Internet Connection', 0)
			Return .F.
		Endif
	Endif

	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_Shell', 'https://vfpx.codeplex.com/wikipage?title=TWEeTs')


Endproc


