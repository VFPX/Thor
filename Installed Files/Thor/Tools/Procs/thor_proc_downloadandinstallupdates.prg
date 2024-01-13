Lparameters tlIsThor, llAutoRun

Local lnReturn

_Screen.AddProperty('cThorCFUErrors', Sys(2023) + '\' + Sys(2015) + '.txt')
lnReturn = CheckForUpdates_Main (tlIsThor, llAutoRun)
ReportAnyCFUErrors()

Execscript (_Screen.cThorDispatcher, 'Result=', lnReturn)

Return



***************************************************************
#Define ccUpdateDelimiter      Chr(0)
#Define ccPropertyDelimiter    Chr(1)
#Define ccFieldDelimiter       Chr(2)

#Define ccCR Chr(13)
#Define ccLF Chr(10)
#Define ccCRLF  ccCR + ccLF

#Define EmptyVerDate			Date(2001,1,1)
#Define DaysForRecentReleases	60
***************************************************************

Procedure CheckForUpdates_Main (tlIsThor, llAutoRun)

	Local lcCol, lcRow, lnCurrentUpdateCount, lnResult, loUpdateList

	WritetoCFULog('Getting list of Updaters')
	loUpdateList		 = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_GetUpdateList', tlIsThor)
	lnCurrentUpdateCount = loUpdateList.Count

	If lnCurrentUpdateCount = 0
		Return 0
	Endif

	loUpdateList = GetAvailableVersionInfo (loUpdateList)
	Wait Clear
	If 'O' # Vartype (loUpdateList) && failure to get update list?
		WritetoCFULog('Aborting ... no update list found')
		Return - 1
	Endif

	If tlIsThor
		loUpdateList = SelectFromUpdateList (loUpdateList)
		lnResult	 = CheckIfReadyToGo (loUpdateList)
	Else
		loUpdateList = SelectUpdates (loUpdateList, llAutoRun)
		Use In (Select ('crsr_ThorUpdates'))
		If Type ('loUpdateList') = 'O' And loUpdateList.Count > 0
			lnResult = 1
		Else
			lnResult = 0
		Endif
	Endif

	If lnResult = 1
		loUpdateList = ClearAll (loUpdateList)
		InstallUpdates (loUpdateList)

		Wait Clear
		? 'Updating complete'

		MessageBox('Updating completed', 0, 'Thor Updates...', 3000) 
		Return 1
	Else
		WritetoCFULog('Exiting ... no updates selected')
	Endif

	Return lnResult

Endproc


Procedure GetAvailableVersionInfo (toUpdateList)

	Local loUpdateList As 'Collection'
	Local laMembers[1], lcName, lnI, lnJ, loNewVersionInfo, loUpdateInfo

	loUpdateList = Createobject ('Collection')

	For lnI = 1 To toUpdateList.Count
		loUpdateInfo = toUpdateList[lnI]
		If loUpdateInfo.NeverUpdate # 'Y'
			loUpdateInfo = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_GetAvailableVersionInfo', loUpdateInfo)
		Endif
		If loUpdateInfo.ErrorCode = 0
			loUpdateList.Add (loUpdateInfo)
		Endif
	Endfor

	Wait Clear
	Return loUpdateList

Endproc


Procedure SelectFromUpdateList (toUpdateList)

	Local laMembers[1], lcName, lnI, lnJ, loNewVersionInfo, loUpdateInfo, loUpdateList

	loUpdateList = Createobject ('Collection')

	For lnI = 1 To toUpdateList.Count
		loUpdateInfo     = toUpdateList[lnI]
		If Not Empty (loUpdateInfo.SourceFileURL)		;
				And Not loUpdateInfo.AvailableVersion == loUpdateInfo.CurrentVersion
			loUpdateList.Add (loUpdateInfo)
		Endif
	EndFor
	Return loUpdateList

Endproc


Procedure CheckIfReadyToGo (toUpdateList)
	*   Returns:
	*       1 = Doit it!
	*       0 = Nothing to do
	*      -1 = Cancelled
	Local lcMessage, lcNames, lcResponse, lcThorMessageBox, lcTitle, lnI, lnResponse, loUpdateInfo

	lcNames = ''
	For lnI = 1 To m.toUpdateList.Count
		loUpdateInfo = m.toUpdateList[m.lnI]
		lcNames		 = m.lcNames + Chr(13) + Space(8) + m.loUpdateInfo.ApplicationName + ': ' + m.loUpdateInfo.AvailableVersion
	Endfor

	If m.toUpdateList.Count > 0
		lcMessage = 'Ready to install update:' + m.lcNames + Chr(13) + Chr(13) +				;
			'CLEAR ALL and CLOSE ALL statements must be run in order to update.' + Chr(13) + Chr(13) + ;
			'Do you wish to continue?'
		lcTitle = 'Allow CLEAR ALL, etc.?'

		*!* ******** JRN Removed 2024-01-08 ********
		*!* lcThorMessageBox = Execscript(_Screen.cThorDispatcher, 'Full Path=' + 'Thor_Proc_Messagebox')
		*!* If Empty(m.lcThorMessageBox)
			lnResponse = Messagebox (m.lcMessage, 4, m.lcTitle)
			Return Iif (m.lnResponse = 6, 1, -1)
		*!* ******** JRN Removed 2024-01-08 ********
		*!* Else
		*!* 	lcResponse = Execscript(_Screen.cThorDispatcher, 'Thor_Proc_Messagebox', m.lcMessage, 3, m.lcTitle)
		*!* 	Return Iif(m.lcResponse = 'Y', 1, -1)
		*!* Endif
	Else
		Return 0
	Endif

Endproc


Procedure SelectUpdates (loUpdateList, llAutoRun)
	Local loResultList As 'Collection'
	Local lcFormFileName, llAnyFound, llResult, lnResult

	llAnyFound = CreateUpdatesCursor (loUpdateList)
	If llAutoRun And Not llAnyFound
		Select crsr_ThorUpdates
		Copy To ( _Screen.cThorCFUFolder + 'ThorUpdates.csv') CSV 
		Return
	Endif

	Goto top in crsr_ThorUpdates
	lcFormFileName = Execscript (_Screen.cThorDispatcher, 'Full Path=CheckForUpdates.SCX')
	Do Form (lcFormFileName) To llResult

	Select crsr_ThorUpdates
	Copy To ( _Screen.cThorCFUFolder + 'ThorUpdates.csv') CSV 

	If llResult
		HandleDependencies()

		Select crsr_ThorUpdates
		loResultList = Createobject ('Collection')
		Scan For UpdateNow
			loResultList.Add (loUpdateList[RecNo])
		Endscan
		Return loResultList
	Endif

Endproc


Procedure HandleDependencies
	Local laDependencies[1], lcDependencies, lnI, lnJ

	HandleDependency('PEM Editor')
	HandleDependency('Thor Repository')
	HandleDependency('Dynamic Forms')

	Select  Dependencies										;
		From crsr_ThorUpdates									;
		Where (UpdateNow Or Not Empty(InstalledVersion))		;
			And Not Empty(Dependencies)							;
		Into Array laDependencies
	For lnJ = 1 To Alen(m.laDependencies)
		lcDependencies = Evl(m.laDependencies[m.lnJ], '')
		For lnI = 1 To Getwordcount(m.lcDependencies, ' ,')
			HandleDependency(Getwordnum(m.lcDependencies, m.lnI, ' ,'))
		Endfor
	Endfor
Endproc




Procedure HandleDependency(lcAPPName)
	Update  crsr_ThorUpdates							;
		Set UpdateNow = .T.								;
		From crsr_ThorUpdates							;
		Where Upper(AppName) = Upper(m.lcAPPName)		;
			And Empty(InstalledVersion)
Endproc



Procedure CreateUpdatesCursor (toUpdateList)

	Local laLines[1], lnI, loVersionInfo

	Create Cursor crsr_ThorUpdates (			;
		  Recno					N(4),			;
		  AppName  				C(40),			;
		  InstalledVersion		C(100),			;
		  InstalledVerNumber	C(100),			;
		  InstalledVerDate		C(20),			;
		  AvailableVersion		C(100),			;
		  AvailableVerNumber	C(100),			;
		  AvailableVerDate		C(20),			;
		  Status                C(40),			;
		  ProjectCreationDate   D,				;
		  UpdateNow           	L,				;
		  NeverUpdate			L,				;
		  NeverUpdateFile		C(250),			;
		  FromMyUpdates			L,				;
		  Notes					M,				;
		  Link                	M,				;
		  LinkPrompt			C(100),			;
		  IsNew		       		L,				;
		  IsCurrent        		L,				;
		  SortKey			    C(100),			;
		  VerDate               D,				;
		  VerNumber				C(100),			;
		  Dependencies			C(100),			;
		  ProjectType			C(10),			;
		  AppID					C(30)			;
		  )

	For lnI = 1 To m.toUpdateList.Count
		With m.toUpdateList[m.lnI]

			Insert Into crsr_ThorUpdates														;
				(Recno, AppName, InstalledVersion,	AvailableVersion, Notes, FromMyUpdates, ProjectCreationDate, Dependencies, ProjectType, AppID) ;
				Values																			;
				(m.lnI, .ApplicationName, .CurrentVersion, .AvailableVersion, .Tag, .FromMyUpdates = 'Y', .ProjectCreationDate, .Dependencies, Iif('Y' $ Upper(.Component), 'Component', 'App'), .AppID)

			loVersionInfo = GetVersionInfo (.CurrentVersion)
			Replace	InstalledVerNumber	With  Alltrim (m.loVersionInfo.VerNumber) + Iif (m.loVersionInfo.VerDate <= EmptyVerDate, '', ' (' + Dtoc (m.loVersionInfo.VerDate) + ')')
			*!* Replace	InstalledVerNumber	With  loVersionInfo.VerNumber		;
			*!* 		InstalledVerDate	With  loVersionInfo.VerDate

			*!* * Removed 10/3/2012 / JRN
			*!* If (Not .CurrentVersion == .AvailableVersion) And Not Empty (.AvailableVersion)
			If Not Empty (.AvailableVersion)
				loVersionInfo = GetVersionInfo (.AvailableVersion)
				Replace	AvailableVerNumber	With  Alltrim (m.loVersionInfo.VerNumber) + ' (' + Dtoc (m.loVersionInfo.VerDate) + ')'
				*!* Replace	AvailableVerNumber	With  loVersionInfo.VerNumber		;
				*!* 		AvailableVerDate	With  loVersionInfo.VerDate
			Endif

			Replace	NeverUpdate		 With  .NeverUpdate = 'Y'									;
					UpdateNow		 With  (Not NeverUpdate)									;
					  And (.AvailableVersion > Evl(.CurrentVersion, ' ')						;
						Or GetLastWord(.AvailableVersion) > GetLastWord('20999999 ' + .CurrentVersion)) ;
					  And (.UpdateNowIfNotInstalled = 'Yes' Or Not Empty (.CurrentVersion))		;
					IsNew			 With  .ProjectCreationDate >= Date() - DaysForRecentReleases ;
					IsCurrent		 With  .CurrentVersion == .AvailableVersion					;
					NeverUpdateFile	 With  .NeverUpdateFile										;
					Notes			 With  Transform(.Notes)									;
					Link			 With  Transform(.Link)										;
					LinkPrompt		 With  Transform(Evl (.LinkPrompt, .Link))					;
					VerDate			 With  m.loVersionInfo.VerDate								;
					VerNumber		 With  m.loVersionInfo.VerNumber

			Replace	UpdateNow  With	 UpdateNow		;
					  Or (Empty(.CurrentVersion) And Inlist(Trim(AppName), 'PEM Editor', 'Thor Repository', 'Dynamic Forms'))

			Replace	SortKey	 With																			;
					  Icase(																				;
						UpdateNow, 									'A',									;
						NeverUpdate And Empty(InstalledVerNumber), 	'Z',									;
						NeverUpdate and IsCurrent, 					'Y',									;
						NeverUpdate, 								'X',									;
						Empty(InstalledVerNumber) And IsNew, 		'B',									;
						Empty(InstalledVerNumber) And VerDate > Date() - DaysForRecentReleases, 'D',		;
						IsCurrent, 									'C',									;
						'M') +																				;
					  Upper(AppName)

			Replace	Status	With  Icase(														;
						Left(SortKey, 1) = 'A' And Empty(InstalledVerNumber), '*** REQUIRED ***', ;
						Left(SortKey, 1) = 'A', 'Update available',								;
						Left(SortKey, 1) = 'B', 'New / Not Installed',							;
						Left(SortKey, 1) = 'C', 'Current',										;
						Left(SortKey, 1) = 'D', 'Not Installed',								;
						Left(SortKey, 1) = 'Z', '---',											;
						Left(SortKey, 1) = 'Y', 'Current',										;
						Left(SortKey, 1) = 'X', '??? Current ???',								;
						'Not Installed')
			
		Endwith
	Endfor && lnI = 1 to toUpdateList.Count

	Replace All											;
			SortKey	 With  '0' + Upper(AppName)			;
		For FromMyUpdates && "My Updates" items go atop list

	Replace All									;
			VerNumber  With	 '-- N/A --'		;
			VerDate	   With	 {}					;
		For Empty(AvailableVersion)

	*** JRN 2023-12-05 : per Issue #203, remove 'Normal' updates it there is a "My Updates"
	*	file with the same AppID
	Select  AppID						;
		From crsr_ThorUpdates			;
		Where FromMyUpdates				;
			And Not Empty(AppID)		;
		Into Cursor crsr_SkipMyUpdates

	Select  *													;
		From crsr_ThorUpdates									;
		Where FromMyUpdates										;
			Or Not AppID In (Select  AppID						;
								 From crsr_SkipMyUpdates)		;
		Order By SortKey										;
		Into Cursor crsr_ThorUpdates Readwrite
		
	Use in crsr_SkipMyUpdates

	Locate For UpdateNow Or (IsNew And Empty(InstalledVersion) And Not NeverUpdate)
	Return Found()

Endproc


Procedure GetVersionInfo (lcVersion)
	Local loResult As 'Empty'
	Local laLines[1], lnLineCount
	loResult = Createobject ('Empty')
	AddProperty (loResult, 'VerNumber', '')
	AddProperty (loResult, 'VerDate', EmptyVerDate)

	If Empty (lcVersion)
		Return loResult
	Endif

	lnLineCount = Alines (laLines, lcVersion, 5, '-')
	Do Case
		Case lnLineCount = 1
			loResult.VerNumber = laLines[1]
		Case lnLineCount = 2
			loResult.VerNumber = laLines[1]
			*	loResult.VerDate   = laLines[2]
		Case lnLineCount = 3
			loResult.VerNumber = laLines[2]
			*	loResult.VerDate   = laLines[3]
		Otherwise
			loResult.VerNumber = laLines[2]
			loResult.VerDate   = laLines[3]
			Try
				loResult.VerDate = Date (Val (Substr (laLines[4], 1, 4)), Val (Substr (laLines[4], 5, 2)), Val (Substr (laLines[4], 7, 2)))
			Catch
			Endtry
	Endcase
	Return loResult
EndProc


Procedure GetLastWord(tcText)
	Return GetWordNum(tcText, GetWordCount(tcText))
EndProc 

**********************************************************************
**********************************************************************

Procedure ClearAll (toUpdateList)

	Local loUpdateList As 'Collection'
	Local laMembers[1], laProperties[1], laUpdates[1], lcName, lcProp, lcUpdateInfo, lnDelim, lnI, lnJ
	Local loUpdate, lxValue

*** DH 2021-12-28: added this line to preserve the folder Thor.app runs from
	loThor = execscript(_screen.cThorDispatcher, 'Thor Engine=')
	addproperty(_screen, 'cThorAppFolder', loThor.cAppFolder)

	* saving all custom properties into _Screen._ThorClearAllObject
	* so that they can be restored after the Clear All
	lcUpdateInfo = ''
	For lnI = 1 To toUpdateList.Count
		loUpdate = toUpdateList (lnI)
		Amembers (laMembers, loUpdate)
		For lnJ = 1 To Alen (laMembers)
			lcName  = laMembers[lnj]
			If Pemstatus (loUpdate, lcName, 4)
				lxValue = Getpem (loUpdate, lcName)
				If Type ('lxvalue') = 'C'
					lcUpdateInfo = lcUpdateInfo + lcName + ccFieldDelimiter + lxValue + ccPropertyDelimiter
				Endif
			Endif
		Endfor
		lcUpdateInfo = lcUpdateInfo + ccUpdateDelimiter
	Endfor && lnI = 1 to loUpdateList.Count

	_Screen.AddProperty ('_ThorClearAllObject', lcUpdateInfo)

	Release All

	Clear All
	Clear All
	Clear All
	Clear All
	Clear All
	Clear All

	Close All
	Clear Program

	Inkey (.25) && not sure if this is needed

	Alines (laUpdates, _Screen._ThorClearAllObject, 5, ccUpdateDelimiter)
	RemoveProperty(_Screen, '_ThorClearAllObject')
	
	loUpdateList = Createobject ('Collection')
	For lnI = 1 To Alen (laUpdates)
		loUpdate = Createobject ('Empty')
		Alines (laProperties, laUpdates[lnI], 5, ccPropertyDelimiter)
		For lnJ = 1 To Alen (laProperties)
			lcProp	= laProperties[lnJ]
			lnDelim	= At (ccFieldDelimiter, lcProp)
			AddProperty (loUpdate, Left (lcProp, lnDelim - 1), Substr (lcProp, lnDelim + 1))
		Endfor
		loUpdateList.Add (loUpdate)
	Endfor && lnI = 1 to Alen(laUpdates)

	*** DH 2021-12-28: delete Thor.App if it needs to be updated
	if lower(loUpdate.AppName) = 'thor.app'
		*** JRN 2023-09-29 : Remove property which might prevent removal of Thor.App 
		If PemStatus(_screen, 'oThorEngine', 5)
			RemoveProperty(_screen, 'oThorEngine')
		EndIf 
		*!* ******** JRN Removed 2023-10-22 ********
		*!* It should be sufficient to remove this property, which prevents Thor.App
		*!*		from begin replaced. Removing Thor.App as well leaves us in the state
		*!* 	where if the download fails, Thor.App would be gone (Tamar's reported issue)
		
		*!* erase (addbs(_screen.cThorAppFolder) + 'Thor.app')
	endif

	Return loUpdateList
Endproc


Procedure InstallUpdates (toUpdateList)
	Local lcAPPFolder, lcAPPName, lcApplicationName, lcDestFolder, lcDestZip, lcDownloadedZip
	Local lcDownloadsFolder, lcExecPhrase, lcInstallationFolder, lcToolFolder, lcUpdatePhrase
	Local lcVersionFile, lnI, lnReturn, loException, loUpdate, ltFileTimeStamp

	WritetoCFULog('Downloading and installing selected updates', .T.)
	lcToolFolder	  = Addbs (Execscript (_Screen.cThorDispatcher, 'Tool Folder='))
	lcDownloadsFolder = Addbs (SyS(2023)) + 'Thor Downloads\'
	CreateFolder (lcDownloadsFolder)

	For lnI = 1 To toUpdateList.Count
		loUpdate     = toUpdateList (lnI)

		If loUpdate.Component = 'Yes'
			lcAPPFolder		  = Addbs (lcToolFolder + 'Components')
		Else
			lcAPPFolder		  = Addbs (lcToolFolder + 'Apps')
		Endif

		lcApplicationName = Chrtran (loUpdate.ApplicationName, ' ' + GetInvalidFileNameChars(), '')
		lcDestFolder	  = Addbs (lcDownloadsFolder + lcApplicationName)
		lcDestZip		  = lcDestFolder + Chrtran (loUpdate.AvailableVersion, GetInvalidFileNameChars(), '') + '.Zip'
		CreateFolder (lcDestFolder)

		lcInstallationFolder = loUpdate.InstallationFolder
		If Empty (lcInstallationFolder)
			lcInstallationFolder = lcAPPFolder + lcApplicationName
		Endif
		CreateFolder (lcInstallationFolder)

		ltFileTimeStamp = .F.
		If (Not Empty (loUpdate.AppName))							;
				And (Not Empty (loUpdate.CurrentVersion))			;
				And Not loUpdate.CurrentVersion == loUpdate.AvailableVersion
			lcAPPName = Addbs (lcInstallationFolder) + loUpdate.AppName
			If File (lcAPPName)
				ltFileTimeStamp = Fdate (lcAPPName, 1)
			Endif
		Endif

		_Screen.AddProperty ('cThorLastZipFile', '')

		WritetoCFULog('Download ' + loUpdate.ApplicationName)
		If loUpdate.Component = 'Yes'
			Execscript (_Screen.cThorDispatcher, 'Thor_Proc_BeforeComponentInstall', loUpdate.ApplicationName, lcInstallationFolder)
		Endif

		If Not Empty (loUpdate.SourceFileURL)
			WritetoCFULog('Attempting download of ' + loUpdate.SourceFileURL)
			lnReturn = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_DownloadAndExtractToPath'		;
				  , loUpdate.SourceFileURL, lcInstallationFolder, 'Y' $ Upper (loUpdate.ShowErrorMessage), loUpdate.ApplicationName)
			If lnReturn < 0 And Pemstatus(loUpdate, 'AltSourceFileURL', 5) And Not Empty(loUpdate.AltSourceFileURL)
				WritetoCFULog('Download failed; attempting alternate download of ' + loUpdate.AltSourceFileURL)
				lnReturn = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_DownloadAndExtractToPath'	;
					  , loUpdate.AltSourceFileURL, lcInstallationFolder, 'Y' $ Upper (loUpdate.ShowErrorMessage), loUpdate.ApplicationName)
			Endif
		Else
			lnReturn = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_ExtractToPath'					;
				  , loUpdate.LocalSourceZip, 'Download_' + Evl (loUpdate.ApplicationName, 'X') + Sys(2015) ;
				  , loUpdate.ApplicationName, lcInstallationFolder, 'Y' $ Upper (loUpdate.ShowErrorMessage))
		Endif
		
		If lnReturn > 0
			WritetoCFULog('Copy Zip ' + loUpdate.ApplicationName)
			* copy zip to our new Downloads folder
			lcDownloadedZip = _Screen.cThorLastZipFile
			Try
				Delete File (lcDestZip)
				Copy File (lcDownloadedZip) To (lcDestZip)
			Catch
				WritetoCFULog('Unable to Copy Zip from ' + lcDownloadedZip + ' to ' + lcDestZip)
				lnReturn = -999 && failure
			Endtry

			*!* ******** JRN Removed 2023-09-27 ********
			*!* Pretty sure this no longer is needed, not clear why it ever was.
			*!* It appears to check if the installed APP has a changed timestamp
			*!*    but that is not the problem for this proc to resolve.
			*!* If Not Empty (ltFileTimeStamp)							;
			*!* 		And ltFileTimeStamp = Fdate (lcAPPName, 1)		;
			*!* 		And File (Addbs (lcInstallationFolder) + loUpdate.VersionLocalFilename)
			*!* 	lnReturn = -999 && failure
			*!* Endif

 		Else
			WritetoCFULog('Failure, lnReturn = ' + Transform(m.lnReturn)) 
		EndIf

		If lnReturn > 0
			WritetoCFULog('Install ' + loUpdate.ApplicationName)
			If loUpdate.Component = 'Yes'
				Execscript (_Screen.cThorDispatcher, 'Thor_Proc_AfterComponentInstall', loUpdate.ApplicationName, lcInstallationFolder, lcDownloadedZip)
			Endif

			Try
				Delete File (lcDownloadedZip)
			Catch
			Endtry

			lcUpdatePhrase = loUpdate.RegisterWithThor
			lcUpdatePhrase = Strtran (lcUpdatePhrase, '##InstallFolder##', Addbs (lcInstallationFolder))
			lcUpdatePhrase = Strtran (lcUpdatePhrase, '##LocalVersionFile##', loUpdate.LocalVersionFile)
			lcUpdatePhrase = Strtran (lcUpdatePhrase, '##Version##', Alltrim (Getwordnum (loUpdate.AvailableVersion, 2, '-')))
			lcUpdatePhrase = Strtran (lcUpdatePhrase, '##FullVersionText##', loUpdate.AvailableVersion)
			lcUpdatePhrase = Strtran (lcUpdatePhrase, '##Link##', loUpdate.Link)

			Try
				lcExecPhrase = CreateDefines (loUpdate) + lcUpdatePhrase
				Execscript (lcExecPhrase)
			Catch To loException
			    ShowErrorMsg (loException)
			Endtry

			lcVersionFile = loUpdate.LocalVersionFile
			Erase (lcVersionFile)
			Strtofile (loUpdate.AvailableVersion, lcVersionFile)

			? loUpdate.AvailableVersion + ' ... Updated'
		Else
			?
			? '********** Unable to install: ' + loUpdate.ApplicationName
			? '********** URL: ' + loUpdate.SourceFileURL
			? '********** See ' + lcDestZip
			If File(m.lcDestZip)
				? '********** Contents: ' + Left(FileToStr(m.lcDestZip), 100) 
			EndIf
			? '***** For more info, try  Modify File(_Screen.cThorLogForCFU)'
			? 

			WritetoCFULog('********** Unable to install: ' + loUpdate.ApplicationName,,.T.)
			WritetoCFULog('********** URL: ' + loUpdate.SourceFileURL,,.T.)
			WritetoCFULog('********** See ' + lcDestZip,,.T.)
			If File(m.lcDestZip)
				WritetoCFULog('********** Contents: ' + Left(FileToStr(m.lcDestZip), 100),,.T.)
			EndIf
			
		Endif
	Endfor && lnI = 1 to loUpdateList.Count
Endproc


Procedure ShowErrorMsg
	Lparameters loException

	Messagebox ('Error: ' + Transform (loException.ErrorNo)     + Chr(13) + Chr(13) +		;
		  'Message: ' + loException.Message                     + Chr(13) + Chr(10) +		;
		  'Procedure: ' + loException.Procedure                 + Chr(13) + Chr(10) +		;
		  'Line: ' + Transform (loException.Lineno)             + Chr(13) + Chr(10) +		;
		  'Code: ' + loException.LineContents												;
		  , 0        + 48, 'Error')
Endproc


Procedure CreateDefines (loUpdate)
	Local laMembers[1], lcDefines, lcName, lnJ, lxValue
	lcDefines = ''
	Amembers (laMembers, loUpdate)
	For lnJ = 1 To Alen (laMembers)
		lcName	= laMembers[lnj]
		lxValue	= Getpem (loUpdate, lcName)
		If Type ('lxvalue') = 'C' And Not Chr(13) $ lxValue
			lcDefines = lcDefines + '#Define cc' + lcName + ' [' + lxValue + ']' + Chr(13)
		Endif
	Endfor
	Return lcDefines
Endproc


Procedure CreateFolder (lcFolder)
	If Not Directory (lcFolder)
		Mkdir (lcFolder)
	Endif
Endproc

* Following from Sergey
Function GetInvalidFileNameChars()
	Local lcInvalidFileNameChars, lnAsc
	lcInvalidFileNameChars = [*/:<>?|\] + Chr(34)
	For lnAsc = 0 To 31
		lcInvalidFileNameChars = lcInvalidFileNameChars + Chr (lnAsc)
	Endfor
	Return lcInvalidFileNameChars
Endfunc


Procedure WritetoCFULog (tcText, tlDivider, tlCaptureErrors)
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', tcText, tlDivider, 1)
	If m.tlCaptureErrors
		Strtofile(Alltrim(Strtran(m.tcText, '**', '', 1, 20, 1)) + chr(13) + chr(10) + chr(13) + chr(10), _Screen.cThorCFUErrors, 1)
	Endif
EndProc 


Procedure ReportAnyCFUErrors
	Local lcErrorFile, lcMsg

	lcErrorFile = _Screen.cThorCFUErrors
	If File(m.lcErrorFile)
		_Cliptext = Filetostr(m.lcErrorFile)

		lcMsg = 'Errors encountered during "Check For Updates"' + chr(13) + chr(10) + chr(13) + chr(10)
		lcMsg = m.lcMsg + _Cliptext + chr(13) + chr(10) + chr(13) + chr(10)
		lcMsg = m.lcMsg + 'Contents of this message copied to clipboard'
		MessageBox(m.lcMsg, 16)
	Endif
Endproc
