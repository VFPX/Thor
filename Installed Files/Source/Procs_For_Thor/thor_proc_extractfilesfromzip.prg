Lparameters tcSource, tcDestinationPath, tlExtractFromFirstFolder

* Parameter tcSource is a fully qualifed path or path+filename+ext (i.e. "C:\TEMP\downloads" or "C:\TEMP\downloads\SomeFile.zip")

Local llReturn, lnResult

*** DH 2022-03-05: changed to preferentially use Shell.Application instead of VFPCompression.fll because the latter has a bug that prevents some newly downloaded ZIPs from being completely unzipped

Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Extracting from [' + tcSource + '] to [' + tcDestinationPath + ']')

try
	loShell = createobject('Shell.Application')
	loFiles = loShell.NameSpace(tcSource).Items
	loShell.NameSpace(tcDestinationPath).CopyHere(loFiles)
	lnResult = 1
catch to loException
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Error extracting: ' + loException.Message)
	lnResult = -1
endtry

if lnResult < 0
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Attempting VFPCompression')
	llReturn = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_SetLibrary', 'VFPCompression.fll')
	If llReturn
		If UnzipOpen (tcSource)
			UnzipTo (tcDestinationPath)
			UnzipClose()
			lnResult = 1
		Else
			lnResult = -1
		Endif
	Else
		lnReturn = -2
		Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Error loading VFP Compression library [VFPCompression.fll]')
	EndIf
endif

Execscript (_Screen.cThorDispatcher, 'Result=', lnResult)
Return lnResult
