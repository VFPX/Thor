#Define ccExecutable 'HACKCX4.EXE'

Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

Local lcExecutableFile, lcFile, lcFileName, lcRelativeName, loFindEXE, loMRUClasses, loMRUForms
Local loPEME_ContextMenu, loPEME_Tools

If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1

		* Required
		.Prompt		 = 'HackCX4 from MRU forms or classes' && used when tool appears in a menu
		.Summary	 = 'HackCX: Pop-up menu to select form or class to be opened with HackCX4'
		.Description = 'HackCX: Pop-up menu to select form or class to be opened with HackCX4' + Chr(13) + 'Requires PEM Editor 7.'

		* For public tools, such as PEM Editor, etc.
		.Source	  = 'Thor Repository'
		.Category = 'Misc.'
		.Author	  = 'Jim Nelson'
	Endwith

	Return lxParam1
Endif

****************************************************************
****************************************************************
* Normal processing for this tool begins here.    

* see	http://vfpx.codeplex.com/wikipage?title=PEM%20Editor%20Tools%20Object
loPEME_Tools = Execscript (_Screen.cThorDispatcher, 'class= tools from pemeditor')
If 'O' # Vartype (loPEME_Tools)
	Return
Endif
loPEME_ContextMenu = Execscript (_Screen.cThorDispatcher, 'class= contextmenu')

loMRUForms = loPEME_Tools.GetMRUList ('SCX')
If loPEME_ContextMenu.AddSubMenu ('Forms')
	For Each lcFile In loMRUForms FoxObject
		lcRelativeName = loPEME_Tools.GetRelativePath (lcFile)
		loPEME_ContextMenu.AddMenuItem (lcRelativeName, , , , lcFile)
	Endfor
	loPEME_ContextMenu.EndSubMenu ()
Endif

loMRUClasses = loPEME_Tools.GetMRUList ('MRU2')
If loPEME_ContextMenu.AddSubMenu ('Classes')
	For Each lcFile In loMRUClasses FoxObject
		If '|' $ lcFile
			lcFile = Left (lcFile, At ('|', lcFile) - 1)
		Endif
		lcRelativeName = loPEME_Tools.GetRelativePath (lcFile)
		loPEME_ContextMenu.AddMenuItem (lcRelativeName, , , , lcFile)
	Endfor
	loPEME_ContextMenu.EndSubMenu ()
Endif

If loPEME_ContextMenu.Activate()
	lcFileName = loPEME_ContextMenu.KeyWord

	lcExecutableFile = ccExecutable
	****************************************************************
	* This block of code checks for the existence of the main APP or EXE
	*    If it does not exist, it prompts for the location of the file
	*    and then modifies itself (this PRG) to point to that location
	If Not File (ccExecutable)
		loFindEXE		 = Execscript (_Screen.cThorDispatcher, 'Class= FindEXE')
		lcExecutableFile = loFindEXE.Find (Justfname (ccExecutable))
		If Empty (lcExecutableFile)
			Return
		Else
			loFindEXE.UpdateEXEName (Sys(16), lcExecutableFile)
		Endif
	Endif
	****************************************************************
	Do (lcExecutableFile) With (lcFileName)

Endif
