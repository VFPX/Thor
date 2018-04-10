Lparameters tlDebugInfo

Local laFiles[1], laStack[1], lcApp, lcAppName, lcDestSourceFolder, lcFile, lcFolder, lcFullAppName
Local lcJimsFile, lcNewVersion, lcProcFolder, lcProject, lcSourceFolder, lcSubFolder, llBeta, lnI
Local loException
lcNewVersion = UpdateThorVersionNumber()
llBeta		 = Occurs ('.', lcNewVersion) = 3

lcProject = 'Thor.PJX'
Select 0
Use (lcProject) Again
Locate For Type = 'H'
Replace Debug With .T. && tlDebugInfo Or llBeta
Use

Erase thor_main.prg
InsertPRGTextFromTemplateFiles ('Thor_Main_Template', 'Thor_Main')

Astackinfo (laStack)
lcApp	 = laStack[1, 2]
lcFolder = Addbs (Justpath (lcApp))

If Upper ('Beta') $ Upper (lcNewVersion)
	lcAppName = '..\Installation Folder - Beta\Thor'
Else
	lcAppName = '..\Installation Folder\Thor'
Endif

lcFullAppName = lcFolder + lcAppName + '.app'
Build App (lcFullAppName) From ('Thor.PJX') recompile

* ================================================================================
* ================================================================================
* erase files in the installation Procs folder
EraseFilesInFolder(lcAppName + '\Tools\Procs\')

lcSourceFolder = Addbs (Curdir()) + 'Procs\'
lcProcFolder   = lcAppName + '\Tools\Procs\'
Adir (laFiles, lcSourceFolder + '*.*', '', 1)
For lnI = 1 To Alen (laFiles, 1)
	lcFile = laFiles[lnI, 1]
	Copy File (lcSourceFolder + lcFile) To (lcProcFolder + 'Tmp' + lcFile)
	RenameFile (Lower (lcProcFolder + 'Tmp' + lcFile), lcProcFolder + lcFile)
Endfor

**************************************************************
* erase files in the installation Source folder
lcDestSourceFolder = lcAppName + '\Source\'
EraseFilesInFolder(lcDestSourceFolder)

lcSourceFolder = Addbs (Curdir())
Adir (laFiles, lcSourceFolder + '*.*', 'D', 1)
For lnI = 1 To Alen (laFiles, 1)
	lcFile = laFiles[lnI, 1]
	Do Case
		Case 'D' $ laFiles[lnI, 5] && folder

			m.lcSubFolder = lcDestSourceFolder + lcFile
			Try
				Mkdir (m.lcSubFolder)
			Catch To loException
			Endtry

			EraseFilesInFolder(m.lcSubFolder)
			Try
				Copy File (lcSourceFolder + lcFile + '\*.*') To (m.lcSubFolder)
			Catch
			Endtry

		Case Inlist(Upper (Justext (lcFile)), 'BAK', 'FXP', 'VCA')

		Otherwise
			Try
				Copy File (lcSourceFolder + lcFile) To (lcDestSourceFolder + 'Tmp' + lcFile)
				RenameFile (Lower (lcDestSourceFolder + 'Tmp' + lcFile), m.lcSubFolder)
			Catch To loException

			Endtry
	Endcase
EndFor

**************************************************************
lcThorFolder = GetThorFolder()
lcJimsFile	 = 'C:\Visual FoxPro\Programs\MyThor\THOR.APP'
If Directory (Justpath (lcJimsFile))
	If llBeta Or Messagebox ('Replace my copy? ', 4) = 6
		If File (lcJimsFile)
			Erase (lcJimsFile)
		Endif
		Copy File (lcFullAppName) To (lcJimsFile)
	Endif
Endif
Return




Procedure RenameFile (lcOldName, lcNewName)
	Local success

	Declare Integer MoveFile In win32api String @ src, String @ Dest

	success = Not Empty (MoveFile (lcOldName, lcNewName))

	Return success
Endproc


Procedure EraseFilesInFolder(tcFolder)
	Local laFiles[1], lcFolder, lnCount, lnI
	lcFolder = Addbs(tcFolder)
	lnCount	 = Adir (laFiles, lcFolder + '*.*', '', 1)
	For lnI = 1 To lnCount
		Erase (lcFolder + laFiles[lnI, 1])
	Endfor
EndProc



Procedure GetThorFolder()

	Local laFolders[1], lcFolder, lcFolders, lnCount, lnI

	Text To m.lcFolders Noshow Textmerge
C:\Users\Jim Nelson\DropBox\VFP Utilities\MyThor
C:\DropBox\VFP Utilities\MyThor
C:\Visual Foxpro\Programs\MyThor
	Endtext

	lnCount = Alines(laFolders, m.lcFolders)
	For lnI = 1 To m.lnCount
		lcFolder = Addbs(m.laFolders[m.lni])
		If File(m.lcFolder + 'Thor.APP')
			Return m.lcFolder
		Endif
	Endfor
Endproc
