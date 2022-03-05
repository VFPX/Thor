Lparameters tcSource, tcDestinationPath, tlExtractFromFirstFolder

* Parameter tcSource is a fully qualifed path or path+filename+ext (i.e. "C:\TEMP\downloads" or "C:\TEMP\downloads\SomeFile.zip")

Local llReturn, lnResult

*** DH 2022-03-04: changed to the Shell.Application instead of VFPCompression.fll because the latter has a bug that prevents some newly downloaded ZIPs from being completely unzipped
***llReturn = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_SetLibrary', 'VFPCompression.fll')

Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Extracting from [' + tcSource + '] to [' + tcDestinationPath + ']')

***If llReturn
***	If UnzipOpen (tcSource)
***		UnzipTo (tcDestinationPath)
***		UnzipClose()
***	Else
***		lnResult = -1
***	Endif
***Else
***	lnReturn = -2
***	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Error loading VFP Compression library [VFPCompression.fll]')
***EndIf

try
	loShell = createobject('Shell.Application')
	loFiles = loShell.NameSpace(tcSource).Items
	loShell.NameSpace(tcDestinationPath).CopyHere(loFiles)
	lnResult = 1
catch to loException
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Error extracting: ' + loException.Message)
	lnResult = -1
endtry

Execscript (_Screen.cThorDispatcher, 'Result=', lnResult)
Return lnResult
