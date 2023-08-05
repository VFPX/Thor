#Define ERROR_DOWNLOADING_FILE	-1
#Define ERROR_EXTRACTING_FILE	-2
#Define ERROR_INSTALLING_FILES	-3

Lparameters lcDownloadDestinationFile, lcTempName, tcAppName, tcInstallPath, tlShowCopyErrorDialog

*-- Extract to temp folder -------------------------------------------------------------------
Local loFSO As 'Scripting.FileSystemObject'
Local lcTempFolder, lnCopyFilesToInstallFolder, lnExtractFilesToTempFolder, lnReturn

lcTempFolder = _Screen.cThorCFUFolder + lcTempName
loFSO		 = Createobject ('Scripting.FileSystemObject')
loFSO.CreateFolder (lcTempFolder) && Create the temp folder

ExecScript(_Screen.cThorDispatcher, "Thor_Proc_UpdateWaitWindow", 'Extracting.... Please wait.')
lnExtractFilesToTempFolder = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_ExtractFilesFromZip', lcDownloadDestinationFile, lcTempFolder)

*--- Copy files from temp folder to target install folder ----------
If lnExtractFilesToTempFolder > 0
	ExecScript(_Screen.cThorDispatcher, "Thor_Proc_UpdateWaitWindow",  'Installing.... Please wait.')
	lnCopyFilesToInstallFolder = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_ExtractFiles', lcTempFolder, tcInstallPath, .F., tlShowCopyErrorDialog)
Else
	Execscript (_Screen.cThorDispatcher, 'Result=', ERROR_EXTRACTING_FILE)
Endif

If lnExtractFilesToTempFolder > 0 And lnCopyFilesToInstallFolder > 0
	lnReturn =  1
	ExecScript(_Screen.cThorDispatcher, "Thor_Proc_UpdateWaitWindow", 'Update complete!')
Else
	Messagebox ('Error updating ' + Evl (tcAppName, '') + '.', 0, 'Failure!')
	lnReturn = ERROR_INSTALLING_FILES
Endif

Execscript (_Screen.cThorDispatcher, 'Result=', lnReturn)
Return lnReturn
