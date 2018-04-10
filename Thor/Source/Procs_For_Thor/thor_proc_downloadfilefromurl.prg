LPARAMETERS pcUrlName, tcDownloadDestinationFile 

DECLARE INTEGER InternetOpen IN wininet.DLL STRING sAgent, ;
      INTEGER lAccessType, STRING sProxyName, ;
      STRING sProxyBypass, INTEGER lFlags
 
DECLARE INTEGER InternetOpenUrl IN wininet.DLL ;
   INTEGER hInternetSession, STRING sUrl, STRING sHeaders,;
   INTEGER lHeadersLength, INTEGER lFlags, INTEGER lContext
 
DECLARE INTEGER InternetReadFile IN wininet.DLL INTEGER hfile, ;
      STRING @sBuffer, INTEGER lNumberofBytesToRead, INTEGER @lBytesRead
 
DECLARE short InternetCloseHandle IN wininet.DLL INTEGER hInst
 
#DEFINE INTERNET_OPEN_TYPE_PRECONFIG 0
#DEFINE INTERNET_OPEN_TYPE_DIRECT 1
#DEFINE INTERNET_OPEN_TYPE_PROXY 3
#DEFINE SYNCHRONOUS 0
#DEFINE INTERNET_FLAG_RELOAD 2147483648
#DEFINE CR CHR(13)
 
local lsAgent, lhInternetSession, lhUrlFile, llOk, lnOk, lcRetVal, lcReadBuffer, lnBytesRead
 

 
 
 
ExecScript(_Screen.cThorDispatcher, "Thor_Proc_UpdateWaitWindow", 'Contacting server.... Please wait.') 

*--- 2011-11-02 M. Slay: Added this guard against empty parameters being passed
If Empty(pcUrlName) or Empty(tcDownloadDestinationFile)
	llReturn = .f.
	Execscript (_Screen.cThorDispatcher, 'Result=', llReturn)
	Return llReturn
EndIf

*--- 2011-11-02: Added support for expanding Bitly URL to long URL
If 'http://bit.ly' $ lower(pcUrlName)
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Expanding bitly link [' + pcUrlName + ']')
	pcUrlName = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_Expand_Bitly_Url', pcUrlName)
	If !Empty(pcUrlName)
		Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Expanded bitly link to [' + pcUrlName + ']')	
	Endif
EndIf
			
If Empty(pcUrlName)
	lcMessage = "Requested URL is an empty string."
	ExecScript(_Screen.cThorDispatcher, "Thor_Proc_UpdateWaitWindow", lcMessage)
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', lcMessage)	
	llReturn = .f.
	Execscript (_Screen.cThorDispatcher, 'Result=', llReturn)
	Return llReturn
Endif

If '?' $ pcUrlName
     lcUrl = pcUrlName + '&' + Sys(2015)
Else
     lcUrl = pcUrlName + '?=' + Sys(2015)
EndIf

 *-- what application is using Internet services?
lsAgent = "VPF 5.0"
  
lhInternetSession = InternetOpen(lsAgent, INTERNET_OPEN_TYPE_PRECONFIG, '', '', SYNCHRONOUS)
 
*-- debugging line - uncomment to see session handle
*-- WAIT WINDOW "Internet session handle: " + LTRIM(STR(lhInternetSession))
 
IF lhInternetSession = 0
	lcMessage = "Internet session cannot be established"
	ExecScript(_Screen.cThorDispatcher, "Thor_Proc_UpdateWaitWindow", lcMessage)
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', lcMessage)	
	llReturn = .f.
	Execscript (_Screen.cThorDispatcher, 'Result=', llReturn)
	Return llReturn
Else
	lcMessage = 'Requesting file ' + JustFname(pcUrlName) + ' from server.' 
	ExecScript(_Screen.cThorDispatcher, "Thor_Proc_UpdateWaitWindow", lcMessage)
	lcMessage = 'Requesting file ' + JustFname(lcUrl) + ' from server.' 
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', lcMessage)	
ENDIF
 
 lhUrlFile = InternetOpenUrl(lhInternetSession, lcUrl, '', 0, INTERNET_FLAG_RELOAD, 0)
 
*-- debugging line - uncomment to see URL handle
*-- WAIT WINDOW "URL Handle: " + LTRIM(STR(lhUrlFile))
 
IF lhUrlFile = 0
	lcMessage = "URL cannot be opened"
	ExecScript(_Screen.cThorDispatcher, "Thor_Proc_UpdateWaitWindow", lcMessage)
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', lcMessage)	
	llReturn = .f.
	Execscript (_Screen.cThorDispatcher, 'Result=', llReturn)
	Return llReturn
Else
	lcMessage = "Downloading..."
	ExecScript(_Screen.cThorDispatcher, "Thor_Proc_UpdateWaitWindow", lcMessage)
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', lcMessage)	
ENDIF
 
lcRetVal = ""
llOk = .t.
 
DO WHILE llOK
   *-- set aside a big buffer
   lsReadBuffer = SPACE(32767)
   lnBytesRead = 0
   lnOK = InternetReadFile(lhUrlFile, @lsReadBuffer, LEN(lsReadBuffer), @lnBytesRead)
 
   if (lnBytesRead > 0)
      lcRetVal = lcRetVal + left(lsReadBuffer, lnBytesRead)
   endif
 
   *-- error trap - either a read failure or read past eof()
   llOk = (lnOK = 1) and (lnBytesRead > 0)
ENDDO
 
*--close all the handles we opened
InternetCloseHandle(lhUrlFile)
InternetCloseHandle(lhInternetSession)
 
Try
	Erase (tcDownloadDestinationFile)
	StrToFile(lcRetVal, tcDownloadDestinationFile,0)
	llReturn = .t.
	lcMessage = "Download complete."
Catch
	llReturn = .f.
	lcMessage = "Error downloading or saving file."
Endtry
	
ExecScript(_Screen.cThorDispatcher, "Thor_Proc_UpdateWaitWindow", lcMessage)
Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', lcMessage)	
Execscript (_Screen.cThorDispatcher, 'Result=', llReturn)
Return llReturn

