Lparameters tcSource, tcDestinationPath, tlExtractFromFirstFolder

* Parameter tcSource is a fully qualifed path or path+filename+ext (i.e. "C:\TEMP\downloads" or "C:\TEMP\downloads\SomeFile.zip")

Local llReturn, lnResult

*** DH 2022-03-05: changed to preferentially use Shell.Application instead of VFPCompression.fll because the latter has a bug that prevents some newly downloaded ZIPs from being completely unzipped

Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Extracting from [' + tcSource + '] to [' + tcDestinationPath + ']')

Try
	loShell = createobject('Shell.Application')
	loFiles = loShell.NameSpace(tcSource).Items
	If loFiles.Count > 0
		loShell.NameSpace(tcDestinationPath).CopyHere(loFiles)
		lnResult = 1
	Else
		lnResult = -1
	endif
catch to loException
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Error extracting: ' + loException.Message)
	lnResult = -1
endtry

* SF 20230813
* Added support for PowerShell
if lnResult < 0
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Attempting extracting with PowerShell')
	lcCommand = 'cmd /c %SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe' +		;
		' Expand-Archive' +															;
		" -Path '" + m.tcSource + "'" +									;
		" -DestinationPath '" + m.tcDestinationPath + "'"
	Try 
		llReturn = Execscript(_Screen.cThorDispatcher, 'Thor_Proc_RunExtApp', m.lcCommand,.F.,.F.)
	Catch to loException
		llReturn = -1
	EndTry
	IF m.llReturn
		lnResult = 1
	else  &&m.llReturn
		lnResult = -1
		Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Error extracting from zip via PowerShell')
	Endif &&m.llReturn
endif &&lnResult < 0

if lnResult < 0
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Attempting VFPCompression 2')
	llReturn = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_SetLibrary', 'VFPCompression.fll')
	If llReturn
		If UnzipOpen (tcSource)
			llReturn = UnzipTo (tcDestinationPath)
			UnzipClose()
			IF m.llReturn
				lnResult = 1
			else  &&m.llReturn
				lnResult = -1
				Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Error extracting from zip via VFPCompression')
			Endif &&m.llReturn
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
