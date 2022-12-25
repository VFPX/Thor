LParameters lcPRGName, lxParam1, lxParam2, lxParam3, lxParam4, lxParam5

Local loGetThor As 'GetThorRun'
Local lcFile, lcSys16, lcThorApp, lcThorFolder, llFirst, llThorInkey, lnI, lnInkey, lnPopUpID
Local loLink, loPEME_Tools, loResult, loThorEngine, loThorInfo, loThorRun

lcThorApp	 = 'C:\VISUAL FOXPRO\PROGRAMS\9.0\COMMON\Thor.APP'
lcThorFolder = 'C:\VISUAL FOXPRO\PROGRAMS\9.0\COMMON\Thor\'

llThorInkey = .F.
If Empty (lcPRGName)
	llThorInkey	= .T.
	lcPRGName	= ''
	Do While Chrsaw()
		lnInkey		= Inkey()
		If lnInkey = 13
			Exit
		Endif
		lcPRGName = lcPRGName + Chr (lnInkey)
	Enddo
Endif

Do Case
	Case Atc('Thor_', lcPrgName) = 1 
		Return ExecuteThorProc(lcPRGName, lcThorFolder, llThorInkey, .F., Pcount(), lxParam1, lxParam2, lxParam3, lxParam4, lxParam5)

		* Return Full Path
	Case Atc([Full Path=], lcPrgName) = 1
		lcFile         = GetFullFileName (Alltrim (Substr (lcPRGName, At ('=', lcPRGName) + 1)), lcThorFolder)
		Return lcFile

	Case Atc([Class=], lcPrgName) = 1
		Return ExecScript(_Screen.cThorDispatcherClasses, lcPRGName, lcThorAPP, Pcount(), lxParam1, lxParam2, lxParam3, lxParam4, lxParam5)

	Case Atc([PopupID=], lcPrgName) = 1
		loGetThor = Createobject ('GetThorRun')
		loThorRun = loGetThor.GetThorRun (lcThorApp, lcThorFolder)
		lnPopUpID = Val (Substr (lcPRGName, 1 + At ('=', lcPRGName)))
		loThorRun.ExecutePopup (lnPopUpID, lcThorFolder, Set ('DataSession'))

	Case Atc([Result=], lcPrgName) = 1
		_Screen.xThorResult	= lxParam1
		Return lxParam1

	***************
	
	Case Empty (lcPRGName)
		Do (lcThorApp) With 'Edit'

	Case Atc([?], lcPrgName) = 1
		Return ExecScript(_Screen.cThorDispatcherHelp)

	Case Atc([Run], lcPrgName) = 1
		loGetThor = Createobject ('GetThorRun')
		loThorRun = loGetThor.GetThorRun (lcThorApp, lcThorFolder)
		loThorRun.Run()

	Case Atc([Tool Folder=], lcPrgName) = 1
		Return lcThorFolder + 'Tools\'

	Case Atc([Version=], lcPrgName) = 1
		Return [Thor - 1.22.06.01 - May 30, 2012]

	Case Atc([Thor Engine=], lcPrgName) = 1
		loGetThor	 = Createobject ('GetThorEngine')
		loThorEngine = loGetThor.GetThorEngine (lcThorApp, lcThorFolder)
		Return loThorEngine

	Case Atc([Thor Register=], lcPrgName) = 1
		loGetThor  = Createobject ('Getthorinfo')
		loThorInfo = loGetThor.Getthorinfo (lcThorApp)
		Return loThorInfo

	Case Atc([Thor Template Code=], lcPrgName) = 1
		loGetThor  = Createobject ('Getthorinfo')
		loThorInfo = loGetThor.Getthorinfo (lcThorApp)
		Return loThorInfo.GetSampleToolCode()

	Case Atc([Clear HotKeys], lcPrgName) = 1
		Do (lcThorApp) With 'Clear HotKeys'

	Case Atc([Toggle Debug Mode], lcPrgName) = 1
		_Screen.lThorDebugMode = not _Screen.lThorDebugMode		
		Set Mark of Bar 31424 of Thor_Internal to _Screen.lThorDebugMode
		If _Screen.lThorDebugMode
			Set Asserts on
		EndIf 

		* Modify Tool
	Case Atc([Edit=], lcPrgName) = 1
		lcFile         = GetFullFileName (Alltrim (Substr (lcPRGName, At ('=', lcPRGName) + 1)), lcThorFolder)
		If Empty (lcFile)
			Return .Null.
		Endif

		Return ExecuteThorProc('Thor_Proc_EditProc', lcThorFolder, llThorInkey, .F., 2, lcFile)

		* Show home page for tool
	Case Atc([Link=], lcPrgName) = 1
		lcFile         = GetFullFileName (Alltrim (Substr (lcPRGName, At ('=', lcPRGName) + 1)), lcThorFolder)
		If Empty (lcFile)
			Return .Null.
		Endif

		loThorInfo = Newobject ('ThorInfo', 'Thor_Utils.vcx', lcThorApp)
		Do (lcFile) With loThorInfo
		loThorInfo.PrgName		= Justfname (lcFile)
		loThorInfo.FullFileName	= lcFile
		If Empty (loThorInfo.Link)
			loGetThor	 = Createobject ('GetThorEngine')
			loThorEngine = loGetThor.GetThorEngine (lcThorApp, lcThorFolder)
			Messagebox (loThorEngine.GetToolDescription (loThorInfo))
		Else
			loLink = Newobject ('_ShellExecute', Home() + 'FFC\_Environ.vcx')
			loLink.ShellExecute (loThorInfo.Link)
		Endif

		* Get ToolInfo for tool
	Case Atc([ToolInfo=], lcPrgName) = 1
		loResult = .Null.
		If Empty (lxParam1) Or 'C' # Vartype (lxParam1)
			Return loResult
		Endif

		lcFile         = GetFullFileName (lxParam1, lcThorFolder)
		If Empty (lcFile)
			Return loResult
		Endif

		Try
			loThorInfo = Newobject ('ThorInfo', 'Thor_Utils.vcx', lcThorApp)
			Do (lcFile) With loThorInfo
			loThorInfo.PrgName		= Justfname (lcFile)
			loThorInfo.FullFileName	= lcFile
			loResult				= loThorInfo
		Catch

		Endtry
		Return loResult

		* DoDefault	
	Case Atc([DoDefault()], lcPrgName) = 1
		lcPRGName = ''
		llFirst	  = .F.
		For lnI = Program (-1) To 1 Step - 1
			lcSys16 = Sys(16, lnI)
			Do Case
				Case Upper (Getwordnum (lcSys16, 1)) = 'PROCEDURE'
				Case Not llFirst
					llFirst = .T.
				Otherwise
					lcPRGName = Justfname (lcSys16)
					Exit
			Endcase
		Endfor

		Return ExecuteThorProc (lcPRGName, lcThorFolder, llThorInkey, .T., Pcount(), lxParam1, lxParam2, lxParam3, lxParam4, lxParam5)

	Otherwise
		Return ExecuteThorProc(lcPRGName, lcThorFolder, llThorInkey, .F., Pcount(), lxParam1, lxParam2, lxParam3, lxParam4, lxParam5)

Endcase

Return


Procedure ExecuteThorProc
	Lparameters lcPRGName, lcThorFolder, llThorInkey, llDoDefault, lnPCount, lxParam1, lxParam2, lxParam3, lxParam4, lxParam5, lcFileText

	Local lcFullPRGName
	lcFullPRGName = GetFullFileName (lcPRGName, lcThorFolder, llDoDefault)
	If Empty (lcFullPRGName)
		Return .Null.
	Endif

	_Screen.lThorInkey	= _Screen.lThorInkey Or llThorInkey
	_Screen.xThorResult	= .T.
	Assert Not _Screen.lThorDebugMode Message 'Debug:     ' + Juststem(lcFullPRGName)
	ExecScript(_Screen.cThorSavelog, lcPRGName, lcThorFolder)
	Do Case
		Case lnPCount < 2
			Do (lcFullPRGName)
		Case lnPCount = 2
			Do (lcFullPRGName) With lxParam1
		Case lnPCount = 3
			Do (lcFullPRGName) With lxParam1, lxParam2
		Case lnPCount = 4
			Do (lcFullPRGName) With lxParam1, lxParam2, lxParam3
		Case lnPCount = 5
			Do (lcFullPRGName) With lxParam1, lxParam2, lxParam3, lxParam4
		Case lnPCount = 6
			Do (lcFullPRGName) With lxParam1, lxParam2, lxParam3, lxParam4, lxParam5
		Otherwise
	EndCase

	_Screen.lThorInkey = _Screen.lThorInkey And Type('llThorInkey') = 'L' And Not llThorInkey
	Return _Screen.xThorResult
Endproc


Function GetFullFileName (lcPRGName, lcThorFolder, llDoDefault)
	Local lcFile, lcFullPRGName1, lcFullPRGName2

	If Empty(JustExt(lcPRGName)) 
		lcFile = Forceext (lcPRGName, 'prg')
	Else
		lcFile = lcPRGName
	EndIf 
	lcFullPRGName1 = Forcepath (lcFile, lcThorFolder + 'Tools\' + 'My Tools')
	lcFullPRGName2 = Forcepath (lcFile, lcThorFolder + 'Tools\' + 'Procs')
	lcFullPRGName3 = Forcepath (lcFile, lcThorFolder + 'Tools\')
	Do Case
		Case File (lcFile) and not llDoDefault
			lcFile = Fullpath (lcFile)
		Case File (lcFullPRGName1) and not llDoDefault
			lcFile = lcFullPRGName1
		Case File (lcFullPRGName2)
			lcFile = lcFullPRGName2
		Case File (lcFullPRGName3)
			lcFile = lcFullPRGName3
		Otherwise
			lcFile = ''
	Endcase
	Return lcFile
Endfunc

Define Class GetThorRun As Session

    Procedure GetThorRun (lcThorApp, lcThorFolder)
        Return Newobject ('Thor_Run', 'thor_run.vcx', lcThorApp, lcThorApp, lcThorFolder)
    Endproc

Enddefine

Define Class GetThorEngine As Session

    Procedure GetThorEngine (lcThorApp, lcThorFolder)
        Return Newobject ('Thor_Engine', 'Thor.vcx', lcThorApp, lcThorFolder)
    Endproc

Enddefine

Define Class GetThorInfo As Session

    Procedure GetThorInfo (lcThorApp)
        Return Newobject ('ThorInfo', 'Thor_Utils.vcx', lcThorApp)
    Endproc

Enddefine
