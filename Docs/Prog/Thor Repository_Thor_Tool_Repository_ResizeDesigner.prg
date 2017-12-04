Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

Local laObjectInfo[1], lcSourceFileName, lcThisFolder, lcWindowName, lnI, lnNewHeight, lnNewWidth
Local loEditorWin, loThisForm, loTools, loWindow, loWindows

If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1

		* Required
		.Prompt		 = 'Resize Designer window' && used when tool appears in a menu
		.Summary	 = 'Resize current Form / Class Designer window'
		.Description = 'Resize current Form / Class Designer window to show the entire form or class being edited'  + Chr(13) + Chr(13) + 'Requires PEM Editor 7.'

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

#Define cnMinWidth 300
#Define cnMinHeight 100

loThisForm	= loTools.GetCurrentObject (.T.) && current form being edited
If 'O' # Vartype (loThisForm)
	Return
Endif

Aselobj (laObjectInfo, 3)
lcSourceFileName = Lower (laObjectInfo(2)) && name of SCX or VCX

loWindows	= loEditorWin.GetOpenWindows()

With loEditorWin
	* create array, 5 elements per window: handle, top, left, height, width
	For lnI = 1 To loWindows.Count
		loWindow	 = loWindows (lnI)
		lcWindowName = Lower (loWindow.WindowName)
		If loWindow.NWHandleType = 0 And 'designer -' $ lcWindowName
			If Justfname (lcSourceFileName) $ lcWindowName		 ;
					And (										 ;
					  Lower (loThisForm.Name) $ lcWindowName	 ;
					  Or Not 'vcx' $ Justext (lcSourceFileName)	 ;
					  )
				.SetHandle (loWindows (lnI).nwhandle)
				lnNewWidth	= Sysmetric(15) + loThisForm.Width + 15
				lnNewHeight	= (Sysmetric(9) * 2)  ;
					+ Sysmetric(14) + loThisForm.Height + 15
				.ResizeWindow (Max (cnMinWidth, lnNewWidth), Max (cnMinHeight, lnNewHeight))
			Endif
		Endif
	Endfor && lnI = 1 to loWindows.Count
Endwith

