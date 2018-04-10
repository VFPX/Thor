* Thanks for the fox wiki http://fox.wikis.com/wc.dll?Wiki~IsSystemConnectedToInternet it was easy to modify the prg

#Define  FLAG_ICC_FORCE_CONNECTION 1

Local lcUrl, llResult
*Declare Long InternetCheckConnection In Wininet.Dll String Url, Long dwFlags, Long Reserved
Declare SHORT InternetGetConnectedState IN wininet;
    INTEGER @ lpdwFlags,;
       INTEGER   dwReserved

*!* Fast and reliable web site
*!* lcUrl = 'http://www.google.com'  && or maybe better to check for the in this case correct web site?
*!* Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Checking internet connection by contacting ' + lcUrl)

*!*If InternetCheckConnection (lcUrl, FLAG_ICC_FORCE_CONNECTION, 0) # 0
Local lnFlags
lnFlags = 0

If InternetGetConnectedState(@lnFlags, 0) = 1
    llResult = .T.
		Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Internet connection test passed.')    
Else
    llResult = .F.
		Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Internet connection test FAILED!!!')        
EndIf

Return ExecScript(_Screen.cThorDispatcher, 'Result=', llResult)
