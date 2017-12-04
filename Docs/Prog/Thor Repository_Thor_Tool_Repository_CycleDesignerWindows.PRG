Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

Local laHandles[1], laObjectInfo[1], lcSourceFileName, lcThisFolder, lcWindowName, lcWonTop
Local llHasFocus, lnI, lnMatchIndex, lnWindowCount, loEditorWin, loThisForm, loTools, loWindow
Local loWindows

If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1

		* Required
		.Prompt		 = 'Cycle thru Designer windows' && used when tool appears in a menu
		.Description = 'Cycle thru Form Designer and Class Designer windows'  + Chr(13) + Chr(13) + 'Requires PEM Editor 7.'

		* Optional

		* For public tools, such as PEM Editor, etc.
		.Source	  = 'Thor Repository'
		.Category = 'Window Management'
		.Author	  = 'Jim Nelson'
	Endwith

	Return lxParam1
Endif

****************************************************************
****************************************************************
* Normal processing for this tool begins here.
lcThisFolder = Addbs (Justpath (Sys(16)))

* see	http://vfpx.codeplex.com/wikipage?title=PEM%20Editor%20EditorWindow%20Object
loEditorWin = Execscript (_Screen.cThorDispatcher, 'class= editorwin from pemeditor')

* see	http://vfpx.codeplex.com/wikipage?title=PEM%20Editor%20Tools%20Object
loTools = Execscript (_Screen.cThorDispatcher, 'class= tools from pemeditor')

loThisForm	= loTools.GetCurrentObject (.T.) && current form being edited
If 'O' # Vartype (loThisForm)
	Return
Endif

lcWonTop	  = Lower (Wontop())
lnWindowCount = 0
loWindows	  = loEditorWin.GetOpenWindows()
lnMatchIndex  = 0

Aselobj (laObjectInfo, 3)
lcSourceFileName = Lower (laObjectInfo(2)) && name of SCX or VCX

With loEditorWin
	* create array, 5 elements per window: handle, top, left, height, width
	For lnI = 1 To loWindows.Count
		loWindow	 = loWindows (lnI)
		lcWindowName = Lower (loWindow.WindowName)
		If loWindow.NWHandleType = 0 And 'designer -' $ lcWindowName
			lnWindowCount = lnWindowCount + 1
			Dimension laHandles (lnWindowCount)
			laHandles (lnWindowCount) = loWindows (lnI).nwhandle

			If Justfname (lcSourceFileName) $ lcWindowName		 ;
					And (										 ;
					  Lower (loThisForm.Name) $ lcWindowName	 ;
					  Or Not 'vcx' $ Justext (lcSourceFileName)	 ;
					  )
				lnMatchIndex = lnWindowCount
				llHasFocus	 = Justfname (lcSourceFileName) $ lcWonTop
			Endif
		Endif
	Endfor && lnI = 1 to loWindows.Count

	Do Case
		Case lnMatchIndex = 0

		Case Not llHasFocus
			loEditorWin.SelectWindow (laHandles (lnMatchIndex))
		Case lnMatchIndex = 1
			loEditorWin.SelectWindow (laHandles (lnWindowCount))
		Otherwise
			loEditorWin.SelectWindow (laHandles (1))
	Endcase
Endwith

