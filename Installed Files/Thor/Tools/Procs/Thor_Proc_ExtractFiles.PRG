	Lparameters tcSource, tcDestinationPath, tlExtractFromFirstFolder, tlShowCopyErrorDialog
	
	&& Parameter tcSource is a fully qualifed path or path+filename+ext (i.e. "C:\TEMP\downloads" or "C:\TEMP\downloads\SomeFile.zip")

	* --- Credit: Original code sample came from here: http://www.tek-tips.com/faqs.cfm?fid=5113

	#DEFINE ERROR_SOURCE_FILE_NOT_FOUND 	-1
	#DEFINE ERROR_CREATING_DESTINATION_PATH -2
	#DEFINE ERROR_OPENING_SOURCE 			-3
	#DEFINE ERROR_EXTRACTING_FILES 			-4

	Local loShellApp as "shell.application"
	Local lnError, loFiles
	Local lnAnswerYesToAllOverwriteFilePrompts, lnCreateDestinationFolderIfNotPresent, lnShowErrorDialog, lnOptions
	
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Copying files to install folder...')
	
	lnError = 0
	
	*-- Create the destination folder, in case it is not present [Universal Thread Message ID: 1450231]
	If Not Directory(tcDestinationPath)
		Try
			Declare Integer SHCreateDirectory In shell32		;
				Integer hWindow, String pszPath
			SHCreateDirectory(_vfp.HWnd, Strconv(tcDestinationPath + Chr(0), 5))
		Catch
			lnError =  ERROR_CREATING_DESTINATION_PATH
		Finally
		Endtry
	Endif && not Directory(tcDestinationPath)
		
	If lnError < 0
		lcErrorMessage = 'Error creating or accessing install folder [' + tcDestinationPath  + ']'
		MessageBox(lcErrorMessage, 16, 'Error!')
		Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', lcErrorMessage)
		Execscript (_Screen.cThorDispatcher, 'Result=', lnError)
		Return lnError
	EndIf
	
	*-- Open the zip file or path  -----------------------------------------------
	Try
		loShellApp = Createobject("shell.application")

		loFiles = loShellApp.NameSpace(tcSource).Items

		If tlExtractFromFirstFolder
			loFiles = loShellApp.NameSpace(loFiles.Item(0)).Items && Make entry point the first folder within zip file or source path
		EndIf
	Catch
		lnError = ERROR_OPENING_SOURCE
	Finally
	Endtry
	
	If lnError < 0
		MessageBox('Error opening ZIP file.', 16, 'Error!')
		Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Error opening ZIP file or path [' + tcSource + '] to copy from.')
		Execscript (_Screen.cThorDispatcher, 'Result=', lnError)
		Return lnError
	Endif	

	Local lcLibrary
	lcLibrary = Set("Library")
	Set Library to 

	*-- Extract the files to the destination folder
	Try
		For Each oItem In loFiles
			lnAnswerYesToAllOverwriteFilePrompts = 16
			lnCreateDestinationFolderIfNotPresent = 512
			lnShowErrorDialog = iif(tlShowCopyErrorDialog, 1024, 0)
			lnOptions = lnAnswerYesToAllOverwriteFilePrompts + lnCreateDestinationFolderIfNotPresent + lnShowErrorDialog
			loShellApp.NameSpace(tcDestinationPath).CopyHere(oItem, lnOptions) 
		Endfor		
	Catch
		lnError = ERROR_EXTRACTING_FILES
	Finally
	EndTry
	
	Set Library to &lcLibrary
		
	If lnError < 0
		Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Error extracting files from [' + tcSource + ']')
		MessageBox('Error extracting files.', 16, 'Error!')
		Execscript (_Screen.cThorDispatcher, 'Result=', lnError)
		Return lnError
	Endif

	lnReturn = 1
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Copied files from [' + tcSource + '] to [' + tcDestinationPath + ']')
	Execscript (_Screen.cThorDispatcher, 'Result=', lnReturn)
	Return lnReturn
