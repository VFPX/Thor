#Define CRLF		Chr[13] + Chr[10]
#Define STARS 		Replicate('=', 40)
#Define MaxTries 	1

Lparameters toUpdateInfo

*-- 2011-07 M. Slay - Revised to set properties on passed toUpdateInfo
Local laLines[1], lcApplicationName, lcLocalVersionFile, lcMsgText, lcVersionFileCode
Local lcVersionFileUrl, lcVersionFolder, llReturn, lnAttempt, loException

lcVersionFolder = _Screen.cThorCFUFolder + 'Version Files'
If Not Directory(m.lcVersionFolder )
	Mkdir (m.lcVersionFolder)
Endif

lcLocalVersionFile = m.lcVersionFolder + '\' + Justfname (m.toUpdateInfo.VersionLocalFilename) && Temp folder
lcVersionFileUrl   = m.toUpdateInfo.VersionFileURL

If Not Empty (m.lcVersionFileUrl)

	lcApplicationName = m.toUpdateInfo.ApplicationName
	WritetoCFULog('Getting available version for ' + m.lcApplicationName, .T.)

	*** JRN 2023-08-18 : No explanation why four tries, but leaving unchanged
	For lnAttempt = 1 To MaxTries
		toUpdateInfo.ErrorCode = 0

		llReturn = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_DownloadFileFromURL', m.lcVersionFileUrl, m.lcLocalVersionFile)

		If m.llReturn = .T.
			lcVersionFileCode = Filetostr (m.lcLocalVersionFile)

			*-- The downloaded file above contains VFP code which will set properties on the passed object:
			Try
				WritetoCFULog('Executing code from downloaded version file...')
				toUpdateInfo = Execscript (m.lcVersionFileCode, m.toUpdateInfo)
			Catch To m.loException
				lcMsgText = 'ERROR executing code from downloaded version file' + CRLF +		;
					STARS +																		;
					m.loException.Message + CRLF		+										;
					m.loException.LineContents + CRLF +											;
					STARS
				WritetoCFULog(m.lcMsgText)
				toUpdateInfo.ErrorCode = -1
			Endtry

			Do Case
				Case m.toUpdateInfo.ErrorCode = 0
					Exit
				Case m.lnAttempt = MaxTries
					ErrorMessage ('Error in version file for ' + m.lcApplicationName + CRLF	+	;
						  STARS + CRLF + 'URL: ' + m.lcVersionFileUrl + CRLF +					;
						  STARS + CRLF + m.lcVersionFileCode, m.lcApplicationName)
				Otherwise
			Endcase

		Else
			toUpdateInfo.ErrorCode = -5
			WritetoCFULog('Error getting available version from server.')
			If m.lnAttempt = MaxTries
				lcMsgText = 'Error getting version information for ' + m.lcApplicationName + CRLF	+ ;
					STARS + CRLF + 'URL: ' + m.lcVersionFileUrl
				ErrorMessage (m.lcMsgText, m.lcApplicationName)
			Endif
		Endif

	Endfor

Endif

If Empty(m.toUpdateInfo.AvailableVersion)
	toUpdateInfo.AvailableVersion = m.lcApplicationName + ' - ' +		;
		Transform(m.toUpdateInfo.VersionNumber) + ' - ' +				;
		Transform(m.toUpdateInfo.VersionNumber) + ' - ' +				;
		Dtoc(Evl(m.toUpdateInfo.VersionDate, Date(2001, 1, 1)), 1)
Endif

Return Execscript (_Screen.cThorDispatcher, 'Result=', m.toUpdateInfo)


Procedure ErrorMessage (tcMessage, tcAppName)
	Local lcMessage

	WritetoCFULog('MessageBox: ' + m.tcMessage)
	lcMessage = m.tcMessage + CRLF + CRLF +			;
		STARS + CRLF + CRLF +						;
		'This error might self-correct if "Check For Updates" is run again.'
	Messagebox (m.lcMessage, 0, 'Error: ' + m.tcAppName)

Endproc


Procedure WritetoCFULog (tcText, tlDivider)
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', m.tcText, m.tlDivider)
Endproc
