Lparameters tcSource, tcDestinationPath, tlExtractFromFirstFolder

* Parameter tcSource is a fully qualifed path or path+filename+ext (i.e. "C:\TEMP\downloads" or "C:\TEMP\downloads\SomeFile.zip")

Local llReturn, lnResult

llReturn = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_SetLibrary', 'VFPCompression.fll')

Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Extracting from [' + tcSource + '] to [' + tcDestinationPath + ']')

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

Execscript (_Screen.cThorDispatcher, 'Result=', lnResult)
Return lnResult
