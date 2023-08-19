Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1								;
		And 'O' = Vartype(lxParam1)			;
		And 'thorinfo' == Lower(lxParam1.Class)

	With lxParam1

		* Required
		.Prompt		   = 'Thor usage summary' && used in menus
		.AppID 		   = 'Thor'

		* Optional
		.Description = 'Summary of usage of Thor tools'

		* These are used to group and sort tools when they are displayed in menus or the Thor form
		.Category      = 'Thor' && creates categorization of tools; defaults to .Source if empty

		* For public tools, such as PEM Editor, etc.
		.Author        = 'Jim Nelson'

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

	Local loThor As Thor_Engine Of 'C:\VISUAL FOXPRO\PROGRAMS\9.0\COMMON\Thor\Source\Thor.vcx'
	Local lcKey, lcToolFolder, loTool, loTools

	* Main Thor Engine
	loThor        = Execscript(_Screen.cThorDispatcher, 'Thor Engine=')

	lcToolFolder  = Execscript(_Screen.cThorDispatcher, 'Tool Folder=')

	loTools = loThor.GetToolsCollection(Addbs(lcToolFolder))

	Select  *														;
			  From(lcToolFolder + '..\Tables\Thor_LogFile')			;
		Order By Count Desc											;
		Into Cursor Thor_Summary Readwrite
	Use In Thor_LogFile
	Scan
		lcKey = Upper(Forceext(Alltrim(prgname), 'prg'))
		If 0 # loTools.GetKey(lcKey)
			loTool = loTools.Item(lcKey)
			Replace prgname With loTool.Prompt
		Endif
	Endscan

	Goto Top
	Browse Normal Nowait

Endproc
