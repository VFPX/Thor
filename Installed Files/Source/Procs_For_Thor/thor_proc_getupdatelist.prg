*-- 2011-11-07 M. Slay - Added new properties to UpdateInfo object so it can be passed to all
*-- the various calls to have the properties set.

Lparameters tlIsThor

Local loUpdateList As 'Collection'
Local laFiles[1], lcCode, lcFile, lcFolder, lcLocalVersion, lcLocalVersionFile, lcNeverUpdateFolder
Local lcRemovedFolder, lcToolFolder, lcUpdateFolder, llSuccess, lnFileCount, lnI, loResult, loTool

lcToolFolder		= Execscript (_Screen.cThorDispatcher, 'Tool Folder=')
lcUpdateFolder		= Addbs (lcToolFolder) + 'Updates\'
lcNeverUpdateFolder	= lcUpdateFolder + 'Never Update\'
lcRemovedFolder		= lcUpdateFolder + 'Removed\'

loUpdateList   = Createobject ('Collection')

AddUpdateFolder (loUpdateList, tlIsThor, lcUpdateFolder, lcNeverUpdateFolder, lcRemovedFolder, lcToolFolder, 'No')

AddUpdateFolder (loUpdateList, tlIsThor, lcUpdateFolder + 'My Updates\', lcNeverUpdateFolder, lcRemovedFolder, lcToolFolder, 'Yes')

Execscript (_Screen.cThorDispatcher, 'Result=', loUpdateList)
Return loUpdateList


Procedure AddUpdateFolder (loUpdateList, tlIsThor, lcUpdateFolder, lcNeverUpdateFolder, lcRemovedFolder, lcToolFolder, tcFromMyUpdates)
	Local laFiles[1], laLocalVersionInfo[1], lcCode, lcFile, lcFolder, lcLocalVersion
	Local lcLocalVersionFile, lcVersionFileUrl, llSuccess, lnFileCount, lnI, loResult, loTool
	lnFileCount	 = Adir (laFiles, lcUpdateFolder + 'Thor_Update_*.PRG')

	For lnI = 1 To lnFileCount
		lcFile	 = lcUpdateFolder + laFiles[lnI, 1]

		If File (lcRemovedFolder + laFiles[lnI, 1])
			Loop
		Endif

*SF 20231201 Ignore file in Updates, if identical named file is found in My Updates; #203
		IF tcFromMyUpdates=='No' AND File (tcUpdateFolder + 'My Updates\' + laFiles[lnI, 1]) Then
			Loop
		ENDIF &&tcFromMyUpdates=='No' AND File (tcUpdateFolder + 'My Updates\' + laFiles[lnI, 1])
*SF 20231201 Ignore file in Updates, if identical named file is found in My Updates; #203

		loResult	  = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_GetUpdaterObject2')
		loResult.File = lcFile
		loResult.FromMyUpdates = tcFromMyUpdates

		lcCode	 = Filetostr (lcFile)
		Try
			loResult  = Execscript (lcCode, loResult)
			llSuccess = .T.
		Catch
			llSuccess = .F.
		Endtry

		If llSuccess
			If 'L' # Vartype(tlIsThor) Or tlIsThor = (Upper (loResult.ApplicationName) == 'THOR')
				loTool = Execscript (_Screen.cThorDispatcher, 'ToolInfo=', loResult.ToolName)

				If Isnull (loTool)
					If loResult.Component = 'Yes'
						lcFolder		  = Addbs(Addbs (lcToolFolder) + 'Components') + loResult.ApplicationName
					Else
						lcFolder		  = Addbs(Addbs (lcToolFolder) + 'Apps') + loResult.ApplicationName
					Endif
					lcLocalVersionFile = Addbs (lcFolder) + loResult.VersionLocalFilename
					If File (lcLocalVersionFile)
						lcLocalVersion	   = Filetostr (lcLocalVersionFile)
						loResult.AlreadyInstalled = 'Yes'
					Else
						lcLocalVersion	   = ''
						loResult.AlreadyInstalled = 'No'
					Endif
				Else
					lcFolder		   = loTool.FolderName
					lcLocalVersionFile = Addbs (lcFolder) + loResult.VersionLocalFilename
					If File (lcLocalVersionFile)
						lcLocalVersion	   = Filetostr (lcLocalVersionFile)
						loResult.AlreadyInstalled = 'Yes'
					Else
						loResult.AlreadyInstalled = 'No'
					Endif
				Endif

				loResult.InstallationFolder	= lcFolder
				loResult.LocalVersionFile	= lcLocalVersionFile
				loResult.NeverUpdateFile	= lcNeverUpdateFolder + laFiles[lnI, 1]

				lcVersionFileUrl   = loResult.VersionFileURL

				If Not Empty (loResult.InstallationFolder)

					If Empty(loResult.AvailableVersion);
							and Not Empty(loResult.ApplicationName);
							and Not Empty(loResult.VersionNumber);
							and Not Empty(loResult.VersionDate)
						loResult.AvailableVersion = loResult.ApplicationName + ' - ' +		;
							Transform(loResult.VersionNumber) + ' - ' +							;
							Transform(loResult.VersionNumber) + ' - ' +							;
							Dtoc(Evl(loResult.VersionDate, Date(2001,1,1)), 1)
					Endif


					If (Empty (lcVersionFileUrl) And Empty(loResult.AvailableVersion)) Or Empty (lcLocalVersionFile)
						loResult.ErrorMessage = 'One of the required version files properties is empty.'
						loResult.ErrorCode	  = -1
					Endif

					*-- Read the local version string
					If File (lcLocalVersionFile)
						Alines (laLocalVersionInfo, Filetostr (lcLocalVersionFile))
						If Alen (laLocalVersionInfo) >= 2
							loResult.CurrentVersion =  laLocalVersionInfo[2]
						Else
							loResult.CurrentVersion =  laLocalVersionInfo[1]
						Endif
					Endif
				Endif

				If File (loResult.NeverUpdateFile)
					loResult.NeverUpdate = 'Yes'
				Endif

				If loResult.ErrorCode >= 0
					loUpdateList.Add (loResult)
				Endif
			Endif
		Endif
	Endfor

Endproc
