Lparameters pcUrlName, tcDownloadDestinationFile

Local lcMessage, lcRetVal, lcURL, lhInternetSession, lhUrlFile, llOK, llReturn, lnBytesRead, lnOK
Local lsAgent, lsReadBuffer

Declare Integer InternetOpen In wininet.Dll String sAgent,		;
	Integer lAccessType, String sProxyName,						;
	String sProxyBypass, Integer lFlags

Declare Integer InternetOpenUrl In wininet.Dll						;
	Integer hInternetSession, String sUrl, String sHeaders,			;
	Integer lHeadersLength, Integer lFlags, Integer lContext

Declare Integer InternetReadFile In wininet.Dll Integer hfile,		;
	String @sBuffer, Integer lNumberofBytesToRead, Integer @lBytesRead

Declare short InternetCloseHandle In wininet.Dll Integer hInst

#Define INTERNET_OPEN_TYPE_PRECONFIG 0
#Define INTERNET_OPEN_TYPE_DIRECT 1
#Define INTERNET_OPEN_TYPE_PROXY 3
#Define SYNCHRONOUS 0
#Define INTERNET_FLAG_RELOAD 2147483648
#Define CR Chr(13)

Execscript(_Screen.cThorDispatcher, 'Thor_Proc_UpdateWaitWindow', 'Contacting server.... Please wait.')

*--- 2011-11-02 M. Slay: Added this guard against empty parameters being passed
If Empty(m.pcUrlName) Or Empty(m.tcDownloadDestinationFile)
	llReturn = .F.
	Execscript (_Screen.cThorDispatcher, 'Result=', m.llReturn)
	Return m.llReturn
Endif

*--- 2011-11-02: Added support for expanding Bitly URL to long URL
If 'http://bit.ly' $ Lower(m.pcUrlName)
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Expanding bitly link [' + m.pcUrlName + ']')
	pcUrlName = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_Expand_Bitly_Url', m.pcUrlName)
	If Not Empty(m.pcUrlName)
		Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Expanded bitly link to [' + m.pcUrlName + ']')
	Endif
Endif

If Empty(m.pcUrlName)
	lcMessage = 'Requested URL is an empty string.'
	Execscript(_Screen.cThorDispatcher, 'Thor_Proc_UpdateWaitWindow', m.lcMessage)
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', m.lcMessage)
	llReturn = .F.
	Execscript (_Screen.cThorDispatcher, 'Result=', m.llReturn)
	Return m.llReturn
Endif

If '?' $ m.pcUrlName
	lcURL = m.pcUrlName + '&' + Sys(2015)
Else
	lcURL = m.pcUrlName + '?=' + Sys(2015)
Endif

*-- what application is using Internet services?
lsAgent = 'VPF 5.0'

lhInternetSession = InternetOpen(m.lsAgent, INTERNET_OPEN_TYPE_PRECONFIG, '', '', SYNCHRONOUS)

*-- debugging line - uncomment to see session handle
*-- WAIT WINDOW "Internet session handle: " + LTRIM(STR(lhInternetSession))

If m.lhInternetSession = 0
	lcMessage = 'Internet session cannot be established'
	Execscript(_Screen.cThorDispatcher, 'Thor_Proc_UpdateWaitWindow', m.lcMessage)
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', m.lcMessage)
	llReturn = .F.
	Execscript (_Screen.cThorDispatcher, 'Result=', m.llReturn)
	Return m.llReturn
Else
	lcMessage = 'Requesting file ' + Justfname(m.pcUrlName) + ' from server.'
	Execscript(_Screen.cThorDispatcher, 'Thor_Proc_UpdateWaitWindow', m.lcMessage)
	lcMessage = 'Requesting file ' + m.lcURL + ' from server.'
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', m.lcMessage)
Endif

lhUrlFile = InternetOpenUrl(m.lhInternetSession, m.lcURL, '', 0, INTERNET_FLAG_RELOAD, 0)

*-- debugging line - uncomment to see URL handle
*-- WAIT WINDOW "URL Handle: " + LTRIM(STR(lhUrlFile))

If m.lhUrlFile = 0
	lcMessage = 'URL cannot be opened'
	Execscript(_Screen.cThorDispatcher, 'Thor_Proc_UpdateWaitWindow', m.lcMessage)
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', m.lcMessage)
	Return Execscript (_Screen.cThorDispatcher, 'Result=', .F.)
Else
	lcMessage = 'Downloading...'
	Execscript(_Screen.cThorDispatcher, 'Thor_Proc_UpdateWaitWindow', m.lcMessage)
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', m.lcMessage)
Endif

lcRetVal = ''
llOK	 = .T.

Do While m.llOK
	*-- set aside a big buffer
	lsReadBuffer = Space(32767)
	lnBytesRead	 = 0
	lnOK		 = InternetReadFile(m.lhUrlFile, @m.lsReadBuffer, Len(m.lsReadBuffer), @m.lnBytesRead)

	If (m.lnBytesRead > 0)
		*** JRN 2023-08-18 : Check for unusual case from github that returns file with contents '404 not found' (or something like that)
		If Empty(m.lcRetVal) And m.lnBytesRead < 50 And Left(lsReadBuffer, 3) = '404'
			lcMessage = 'URL not found, file contents = ' + Left(lsReadBuffer, m.lnBytesRead)
			Execscript(_Screen.cThorDispatcher, 'Thor_Proc_UpdateWaitWindow', m.lcMessage)
			Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', m.lcMessage)
			Return Execscript (_Screen.cThorDispatcher, 'Result=', .F.)
		Endif

		lcRetVal = m.lcRetVal + Left(m.lsReadBuffer, m.lnBytesRead)
	Endif

	*-- error trap - either a read failure or read past eof()
	llOK = (m.lnOK = 1) And (m.lnBytesRead > 0)
Enddo

*--close all the handles we opened
InternetCloseHandle(m.lhUrlFile)
InternetCloseHandle(m.lhInternetSession)

Try
	Erase (m.tcDownloadDestinationFile)
	Strtofile(m.lcRetVal, m.tcDownloadDestinationFile, 0)
	llReturn  = .T.
	lcMessage = 'Download complete into file ' + m.tcDownloadDestinationFile
Catch
	llReturn  = .F.
	lcMessage = 'Error downloading or saving file.'
Endtry

Execscript(_Screen.cThorDispatcher, 'Thor_Proc_UpdateWaitWindow', m.lcMessage)
Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', m.lcMessage)
Execscript (_Screen.cThorDispatcher, 'Result=', m.llReturn)
Return m.llReturn

