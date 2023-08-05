#Define CR 			Chr[13]
#Define STARS 		Replicate('=', 40)
#Define MaxTries 	4

Lparameters toUpdateInfo

*-- 2011-07 M. Slay - Revised to set properties on passed toUpdateInfo
Local lcLocalVersionFile, lcVersionFileCode, lcVersionFileUrl, llReturn, lnAttempt, laLines[1]

lcLocalVersionFile = _Screen.cThorCFUFolder + Justfname (toUpdateInfo.VersionLocalFilename) && Temp folder
lcVersionFileUrl   = toUpdateInfo.VersionFileUrl

If Not Empty (lcVersionFileUrl)

	WritetoCFULog('Getting available version info for ' + toUpdateInfo.ApplicationName, .T.)

	For lnAttempt = 1 To MaxTries
		toUpdateInfo.ErrorCode = 0
		llReturn			   = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_DownloadFileFromURL', lcVersionFileUrl, lcLocalVersionFile)

		If llReturn = .T.
			lcVersionFileCode = Filetostr (lcLocalVersionFile)

			*-- The downloaded file above contains VFP code which will set properties on the passed object:
			Try
				WritetoCFULog('Executing code from downloaded version file...')
				toUpdateInfo = Execscript (lcVersionFileCode, toUpdateInfo)
			Catch
				WritetoCFULog('ERROR while executing code from downloaded version file!')
				toUpdateInfo.ErrorCode = -1
			Endtry

			Do Case
				Case toUpdateInfo.ErrorCode = 0
					Exit
				Case lnAttempt = MaxTries
					If Alines (laLines, lcVersionFileCode) > 4 && ignore messages about earlier versions which did not pass objects
						ErrorMessage ('Invalid format in version file for ' + toUpdateInfo.AppName + CR	+ ;
							  STARS + CR + 'URL: ' + lcVersionFileUrl + CR +					;
							  STARS + CR + lcVersionFileCode + CR +								;
							  STARS, toUpdateInfo.AppName)
					Endif
				Otherwise
			Endcase

		Else
			toUpdateInfo.ErrorCode = -5
			WritetoCFULog('Error getting available version information from server.')
			If lnAttempt = MaxTries
				ErrorMessage ('Error getting available version information from server.' + toUpdateInfo.AppName + CR	+ ;
					  STARS + CR + 'URL: ' + lcVersionFileUrl + CR +							;
					  STARS, toUpdateInfo.AppName)
			Endif
		EndIf
		
	Endfor

Endif

If Empty(toUpdateInfo.AvailableVersion)
	toUpdateInfo.AvailableVersion = toUpdateInfo.ApplicationName + ' - ' +		;
		Transform(toUpdateInfo.VersionNumber) + ' - ' +							;
		Transform(toUpdateInfo.VersionNumber) + ' - ' +							;
		Dtoc(Evl(toUpdateInfo.VersionDate, Date(2001,1,1)), 1)
Endif
		
Return Execscript (_Screen.cThorDispatcher, 'Result=', toUpdateInfo)


Procedure ErrorMessage (tcMessage, tcAppName)
	#Define CR Chr[13]
	Local lcMessage
	WritetoCFULog('MessageBox: ' + tcMessage)
	lcMessage = tcMessage + CR + CR + 'Cancelling ... ' + CR + CR + 'This error may self-correct if "Check For Updates" is run again.'
	Messagebox (lcMessage, 0, 'Error: ' + tcAppName)

Endproc


Procedure WritetoCFULog (tcText, tlDivider)
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', tcText, tlDivider)
EndProc 
