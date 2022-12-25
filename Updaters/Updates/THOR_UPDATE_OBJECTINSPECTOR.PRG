Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge

	loThorInfo = Execscript (_Screen.cThorDispatcher, 'Thor Register=')

	With loThorInfo
		* Required
		.FullAppName   = '##InstallFolder##Inspector.APP' 
		.PRGName	   = 'Thor_Tool_ObjectInspector'
		
		* Optional
		.Prompt		   = 'Object and Collection Inspector' && used when tool appears in a menu

* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		*##*Text to .Description NoShow
Browses objects and/or collections, showing all child objects and the values of all their properties.  You can edit a property by double-clicking.

Run this tool as follows:

In a code window or the command window, click on the name of an object of collection and then call the tool.

Or, place the mouse over an object in an executing form, or a form or class being edited in the IDE, and call the tool.

Or, if a form or class is being edited, call the tool to inspect the currently selected object (that is, the one shown in the Property Sheet).

Otherwise, call the tool to paste text into the command window so that you can supply the name of the object or collection of interest.

*##*NOTE: Unfortunately, because of the way this tool is invoked, it doesn't work from the Thor tool bar.
		*##*EndText
* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		.PRGName       = 'Thor_Tool_ObjectInspector' && a unique name for the tool; note the required prefix

		* These are used to group and sort tools when they are displayed in menus or the Thor form
		.Category      = 'Objects and PEMs'
		.Classes       = 'loInspector = Inspector of Inspector.vcx'

		* For public tools, such as PEM Editor, etc.
		.Version	   = '##Version##'
		.Author        = 'Tamar Granor'
		.OptionClasses	    = 'clsRowHeightProperties'
		.OptionTool		    = 'Object and Collection Inspector'
		.CanRunAtStartUp = .F.
		.Link          = ''

* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		*##*Text To .DefineStatements Noshow Textmerge
#Define ccAppFolder '##InstallFolder##'
		*##*Endtext
* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		*##*Text To .Code Noshow Textmerge
	Local lcCommand, lcText, lnWindowType, loxxxEditorWin

	lcText	 = Execscript(_Screen.cThorDispatcher, 'Thor_Proc_GetHighlightedText', 'Object Name')

	loxxxEditorWin = Execscript(_Screen.cThorDispatcher, 'Class= editorwin from pemeditor')
	lnWindowType   = loxxxEditorWin.GetEnvironment(25)

	Do Case
		Case m.lnWindowType > 0 And Not Empty(lcText)
			EditObjectFromCodeWindow(lcText)

		Case m.lnWindowType = 0 And 'O' = Type(lcText)
			Do (ccAppFolder + 'Inspector.App') With &lcText, lcText

		Case EditObjectUnderCursor()

		Case EditSelectedObject()

		Case m.lnWindowType = 0
			Keyboard('{Ctrl+End}Do ("' + Sys(2014, ccAppFolder) + 'Inspector.App") with ') Plain Clear

		Otherwise
			lcCommand = 'Do ("' + Sys(2014, ccAppFolder) + 'Inspector.App") with '
			Activate Window Command
			Keyboard '{Ctrl+End}' Plain Clear

			loxxxEditorWin = Execscript(_Screen.cThorDispatcher, 'Class= editorwin from pemeditor')
			loxxxEditorWin.Paste(lcCommand)
	Endcase

		*##*Endtext
* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        *##*Text To .ClassDefinitions Noshow Textmerge
Procedure EditObjectFromCodeWindow(lcText)
	Local lcCommand, loxxxEditorWin
	lcCommand = 'Do ("' + Sys(2014, ccAppFolder) + 'Inspector.App") with '

	Activate Window Command
	Keyboard '{Ctrl+End}' Plain Clear

	loxxxEditorWin = Execscript(_Screen.cThorDispatcher, 'Class= editorwin from pemeditor')
	loxxxEditorWin.Paste(lcCommand)
	loxxxEditorWin.Paste (lcText)
	loxxxEditorWin.Paste (', "' + Chrtran(lcText, ["], []) + '"')

	DoEvents

	Keyboard '{Enter}'

Endproc


Procedure EditObjectUnderCursor
	Local lcName, loxxxObject
	loxxxObject	  = Sys(1270)
	If 'O' = Vartype (loxxxObject)
		If Pemstatus(loxxxObject, 'HWnd', 5) And loxxxObject.HWnd = _Screen.HWnd
			Return .F.
		Else
			lcName = FullObjectName(loxxxObject)
			Do (ccAppFolder + 'Inspector.App') With loxxxObject, lcName
			Return .T.
		Endif
	Else
		Return .F.
	Endif
Endproc


Procedure EditSelectedObject
	Local lcName, loxxxObject, loxxxObjects[1]
	If 0 # Aselobj(loxxxObjects) Or 0 # Aselobj(loxxxObjects, 1)
		loxxxObject	= loxxxObjects[1]
		lcName		= FullObjectName(loxxxObject)
		Do (ccAppFolder  + 'Inspector.App') With loxxxObject, lcName
		Return .T.
	Else
		Return .F.
	Endif
Endproc


Procedure FullObjectName(toObject)
	Local lcName, loObject
	loObject = toObject
	lcName	 = ''
	Do While Pemstatus(loObject, 'Name', 5)
		lcName = loObject.Name + Iif(Empty(lcName), '', '.' + lcName)
		If 'O' = Type('loObject.Parent')
			loObject = loObject.Parent
		Else
			Exit
		Endif
	Enddo
	Return lcName
EndProc


****************************************************************
****************************************************************
*##*Define Class clsRowHeightProperties As Custom

	Tool		  = 'Object and Collection Inspector'
	Key			  = 'Grid Row Height'
	Value		  = 25
	EditClassName = 'clsRowHeight'

*##*Enddefine


****************************************************************
****************************************************************
*##*Define Class clsRowHeight As Container

	Procedure Init
		Local lcBodyMarkup, loRenderEngine
		loRenderEngine = Execscript(_Screen.cThorDispatcher, 'Class= OptionRenderEngine')

		lcBodyMarkup = ;
			[.Class = 'Label'] + Chr[13] + ;
			[.Caption = '.RowHeight for grids' ] + Chr[13] + ;
			[.AutoSize = .T.] + Chr[13] + ;
			[.Top = (.Top + 8)] + Chr[13] + ;
			[|] + Chr[13] + ;
			[.Class	= 'TextBox'] + Chr[13] + ;
			[.cTool	= 'Object and Collection Inspector'] + Chr[13] + ;
			[.cKey = 'Grid Row Height'] + Chr[13] + ;
			[.InputMask = '999'] + Chr[13] + ;
			[.Width = 60] + Chr[13] + ;
			[.Row-Increment = 0] + Chr[13] + ;
			[.Top = (.Top - 4)] 
						
		loRenderEngine.cBodyMarkup = lcBodyMarkup
		loRenderEngine.Render(This, 'Object and Collection Inspector')

	Endproc

*##*Enddefine

		*##*Endtext
* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		*##*llRegister = .Register()

	*##*Endwith
	
EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '*##*', '')


With loUpdateObject
    .AppName              = 'Inspector.App'
    .ApplicationName      = 'Object Inspector'
    .ToolName             = 'Thor_Tool_ObjectInspector'
    .VersionNumber        = '2'
    .VersionDate          = Date(2013, 12, 4)
    .VersionLocalFilename = 'InspectorVersionFile.txt' 
    .RegisterWithThor     = lcRegisterWithThor
	.Link                 = 'https://github.com/VFPX/ObjectInspector'
    .SourceFileURL        = 'https://github.com/VFPX/ObjectInspector/archive/refs/heads/master.zip'
Endwith

Return loUpdateObject
