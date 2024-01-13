Local laFiles[1], lcCFUFolder, lcToolFolder, lcUpdateFolder, llAutoRun, lnFileCount, lnI, lnReturn

*** DH 2021-12-28: changed URL from VFPXRepository to GitHub
#Define UpdaterURL 'https://raw.githubusercontent.com/VFPX/Thor/master/ThorUpdater/Updates.zip'

*** DH 2022-01-06: added SET SAFETY OFF to eliminate overwrite prompts
Set Safety Off

lcCFUFolder = Sys(2023) + '\Thor.CheckForUpdates.' + Left(Ttoc(Datetime(), 1), 8) + '.' + Right(Ttoc(Datetime(), 1), 6) + '\'
Mkdir(m.lcCFUFolder)
_Screen.AddProperty('cThorCFUFolder', m.lcCFUFolder)

WritetoCFULog('Begin CFU - ' + Transform(Datetime()))

If File(_screen.cThorFolder + 'ThorVersion.txt')
	WritetoCFULog(FileToStr(_screen.cThorFolder + 'ThorVersion.txt'))
EndIf 

If Not Execscript (_Screen.cThorDispatcher, 'Thor_Proc_CheckInternetConnection')
	Messagebox ('No Internet Connection Found!', 16, 'No Internet Connection', 0)
	Return .F.
Endif

WritetoCFULog('Checking for updates to Thor', .T.)

If Execscript (_Screen.cThorDispatcher, 'Thor_Proc_DownloadAndInstallUpdates', .T.) >= 0

	lcToolFolder   = Execscript (_Screen.cThorDispatcher, 'Tool Folder=')
	WritetoCFULog('Erasing Thor FXP files...')
	EraseFXPFiles (m.lcToolFolder)
	WritetoCFULog('Erasing Thor FXP files from Thor Procs folder...')
	EraseFXPFiles (m.lcToolFolder + 'Procs')
	WritetoCFULog('Erasing Thor FXP files from Thor MyTools folder...')
	EraseFXPFiles (m.lcToolFolder + 'My Tools')

	lcUpdateFolder = Addbs (m.lcToolFolder) + 'Updates\'
	lnFileCount	   = Adir (laFiles, m.lcUpdateFolder + '*.PRG')
	WritetoCFULog('Processing (' + Transform(m.lnFileCount) + ') Thor updater programs...')

	For lnI = 1 To m.lnFileCount
		If Not Upper (m.laFiles[m.lnI, 1]) == Upper ('Thor_Update_Thor.PRG')
			Erase (m.lcUpdateFolder + m.laFiles[m.lnI, 1])
		Endif
	Endfor
	*** Download the zip of Updaters, and install them
	lnReturn = Execscript (_Screen.cThorDispatcher		;
		  , 'Thor_Proc_DownloadAndExtractToPath'		;
		  , UpdaterURL + '?=' + Sys(2015)				;
		  , m.lcToolFolder								;
		  , .T.											;
		  , 'Updates')

	*** Check if called from RunThor, meaning it is from AutoRun
	llAutoRun = .F.
	For lnI = 1 To Program (-1)
		llAutoRun = m.llAutoRun Or 'RUNTHOR' $ Upper (Sys(16, m.lnI))
	Endfor

	WritetoCFULog('Checking for updates to all other apps', .T.)

	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_DownloadAndInstallUpdates', .F., m.llAutoRun)

	Execscript (_Screen.cThorDispatcher, 'Run')

Endif

* record the date CFU was run
Execscript(_Screen.cThorDispatcher, 'Thor_Proc_SetLastCFUDate')

*!* ******** JRN Removed 2024-01-06 ********
*!* Execscript (_Screen.cThorDispatcher, 'Thor_Tool_ThorInternalThorNews', 'Check For Updates')

Wait Clear

Return


Procedure EraseFXPFiles (tcFolder)
	Local lcFolder, lnCount, lnI, loException
	lcFolder = Addbs (m.tcFolder)
	lnCount	 = Adir (laFiles, m.lcFolder + '*.FXP')
	For lnI = 1 To m.lnCount
		Try
			Erase (m.lcFolder + m.laFiles[m.lnI, 1])
		Catch To m.loException

		Endtry
	Endfor
Endproc


Procedure WritetoCFULog(tcText, tlDivider)
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WritetoCFULog', m.tcText, m.tlDivider)
Endproc
