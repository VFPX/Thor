Lparameters toProcessorObject, lcScope, llRestrictions

Local loScopeProcessor As 'ScopeProcessor'
Local llProjectHomeDirectory, llSubDirectories, loForm

Do Case
	Case Pcount() > 1 And Not Empty(m.lcScope ) And Directory(m.lcScope)
		llSubDirectories = m.llRestrictions
	Case Pcount() > 1 And Not Empty(m.lcScope ) And File(m.lcScope)
		llProjectHomeDirectory = m.llRestrictions
	Otherwise
		loForm = Execscript(_Screen.cThorDispatcher, 'Class= FrmScopeFinder from Thor_Proc_ScopeProcessor.vcx')
		m.loForm.Show(1)
		If Vartype(m.loForm) # 'O'
			Return Execscript(_Screen.cThorDispatcher, 'Result=', .F.)
		Endif

		lcScope				   = m.loForm.cScope
		llSubDirectories	   = m.loForm.lSubDirectories
		llProjectHomeDirectory = m.loForm.lProjectHomeDirectory
		m.loForm.Release()
Endcase

* Create object that processes a folder / project
loScopeProcessor				  = Newobject('ScopeProcessor')
loScopeProcessor.oCustomProcessor = m.toProcessorObject

Do Case
	Case Directory(m.lcScope)
		m.loScopeProcessor.ProcessPath(m.lcScope, m.llSubDirectories)
		Return Execscript(_Screen.cThorDispatcher, 'Result=', .T.)
	Case File(m.lcScope)
		m.loScopeProcessor.ProcessProject(m.lcScope, m.llProjectHomeDirectory)
		Return Execscript(_Screen.cThorDispatcher, 'Result=', .T.)
	Otherwise
		Return Execscript(_Screen.cThorDispatcher, 'Result=', .F.)
Endcase


*=======================================================================================
* Scope Processor 
* Thiis class will loop through all files in the Current Project or a Path and will
* call a custom oProcessor.Process() method for each row in the file (scx, vcx, frx) 
* and for each recognized text file (prg, txt, ini, .h, etc)
* Ver 1.00  2014-01-21
*=======================================================================================
Define Class ScopeProcessor As Custom

	oCustomProcessor = .Null.
	oSearchEngine	 = .Null.

	*---------------------------------------------------------------------------------------
	Procedure Init

		Local loFormProgressBar
		This.oSearchEngine = Execscript(_Screen.cThorDispatcher, 'Class= GoFishSearchEngine_Thor from Thor_Proc_GoFishSearchEngine.VCX')

		loFormProgressBar = Execscript(_Screen.cThorDispatcher, 'Class= ProgressForm from Thor_Proc_ProgressBar.VCX')
		m.loFormProgressBar.Show()
		This.oSearchEngine.oProgressBar = m.loFormProgressBar.cntProgressBar

		This.oSearchEngine.oSearchOptions.lShowNoMatchesMessage	 = .F.
		This.oSearchEngine.oSearchOptions.lIncludeSubdirectories = .T.

	Endproc

	*---------------------------------------------------------------------------------------
	Procedure Destroy

		This.oSearchEngine.oProgressBar		= .Null.
		This.oSearchEngine.oCustomProcessor	= .Null.

		This.oCustomProcessor = .Null.
		This.oSearchEngine	  = .Null.

	Endproc


	*---------------------------------------------------------------------------------------
	Procedure oCustomProcessor_Assign(toObject)

		This.oCustomProcessor				= m.toObject
		This.oSearchEngine.oCustomProcessor	= m.toObject
		If Vartype(m.toObject) = 'O' and Pemstatus(m.toObject, 'lSearchOncePerVCX', 5)
			This.oSearchEngine.lSearchOncePerVCX = m.toObject.lSearchOncePerVCX
		Endif
		
	Endproc


	*---------------------------------------------------------------------------------------
	Procedure ProcessProject(tcProject, tlProjectHomeDirectory)

		Local lnReturn

		If Pcount() = 2
			This.oSearchEngine.oSearchOptions.lLimitToProjectFolder = m.tlProjectHomeDirectory
		Else
			This.oSearchEngine.oSearchOptions.lLimitToProjectFolder = .T.
		Endif

		lnReturn = This.oSearchEngine.SearchInProject(m.tcProject)

		Return m.lnReturn

	Endproc

	*---------------------------------------------------------------------------------------
	Procedure ProcessPath(tcPath, tlIncludeSubdirectories)

		Local lnReturn

		If Pcount() = 2
			This.oSearchEngine.oSearchOptions.lIncludeSubdirectories = m.tlIncludeSubdirectories
		Else
			This.oSearchEngine.oSearchOptions.lIncludeSubdirectories = .T.
		Endif

		lnReturn = This.oSearchEngine.SearchInPath(m.tcPath)

		Return m.lnReturn

	Endproc


Enddefine
