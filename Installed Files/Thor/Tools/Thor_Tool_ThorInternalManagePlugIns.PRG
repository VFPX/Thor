Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' == Lower (lxParam1.Class)

	With lxParam1

		* Required
		.Prompt	 = 'Manage Plug-In PRGs'
		.AppID 	 = 'Thor'
		.Summary = 'Manage Plug-In PRGs'

		* Optional
		.Description = 'Manage Plug-In PRGs'

		* These are used to group and sort tools when they are displayed in menus or the Thor form
		.Category = 'Settings & Misc.' && allows categorization for tools with the same source
		.Sort	  = 999 && the sort order for all items from the same Source, Category and Sub-Category
		.PlugInClasses = 'clsBeforeComponentInstall, clsAfterComponentInstall, clsBeforeCFU, clsAfterCFU'

		* For public tools, such as PEM Editor, etc.
		.Author        = 'Jim Nelson'
		.CanRunAtStartup = .F.

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

	Local lcFileName
	If Type ('_Screen.cThorDispatcher') = 'C'
		Execscript (_Screen.cThorDispatcher, 'PEMEditor_StartIDETools')
		lcFileName    = Execscript (_Screen.cThorDispatcher, 'Full Path=Thor_Tool_ThorInternalManagePlugIns.SCX')
		Do Form  (lcFileName)
	Else
		Messagebox ('Thor is not active; this tool requires Thor', 16, 'Thor is not active', 0)
	Endif

Endproc


****************************************************************
****************************************************************

Define Class clsBeforeComponentInstall As Custom

	Source				= 'Thor'
	PlugIn				= 'BeforeComponentInstall'
	Description			= 'Called during "Check For Updates" before a component is installed (in a sub-folder of Thor\Tools\Components).'
	Tools				= 'Check For Updates'
	FileNames			= 'Thor_Proc_BeforeComponentInstall.PRG'
	DefaultFileName		= '*Thor_Proc_BeforeComponentInstall.PRG'
	DefaultFileContents	= ''

	Procedure Init
		Text To This.DefaultFileContents Noshow
Lparameters tcApplicationName, tcInstallationFolder

		Endtext
	Endproc

Enddefine


****************************************************************
****************************************************************

Define Class clsAfterComponentInstall As Custom

	Source				= 'Thor'
	PlugIn				= 'AfterComponentInstall'
	Description			= 'Called during "Check For Updates" after a component is installed (in a sub-folder of Thor\Tools\Components).'
	Tools				= 'Check For Updates'
	FileNames			= 'Thor_Proc_AfterComponentInstall.PRG'
	DefaultFileName		= '*Thor_Proc_AfterComponentInstall.PRG'
	DefaultFileContents	= ''

	Procedure Init
		Text To This.DefaultFileContents Noshow
Lparameters tcApplicationName, tcInstallationFolder

		Endtext
	Endproc

Enddefine


****************************************************************
****************************************************************

Define Class clsBeforeCFU As Custom

	Source				= 'Thor'
	PlugIn				= 'Before Check For Updates'
	Description			= 'Called before "Check For Updates" to capture any configuration info to be restored after.  See also "AfterCheckForUpdates".'
	Tools				= 'Check For Updates'
	FileNames			= 'Thor_Proc_Before_Check_For_Updates.PRG'
	DefaultFileName		= '*Thor_Proc_Before_Check_For_Updates.PRG'
	DefaultFileContents	= ''

	Procedure Init
		Text To This.DefaultFileContents Noshow
		Endtext
	Endproc

Enddefine


****************************************************************
****************************************************************

Define Class clsAfterCFU As Custom

	Source				= 'Thor'
	PlugIn				= 'After Check For Updates'
	Description			= 'Called after "Check For Updates" to restore any configuration that had been captured.  See also "BeforeCheckForUpdates".'
	Tools				= 'Check For Updates'
	FileNames			= 'Thor_Proc_After_Check_For_Updates.PRG'
	DefaultFileName		= '*Thor_Proc_After_Check_For_Updates.PRG'
	DefaultFileContents	= ''

	Procedure Init
		Text To This.DefaultFileContents Noshow
		Endtext
	Endproc

Enddefine

