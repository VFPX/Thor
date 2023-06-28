Lparameters tcBitlyShortUrl

Local lcVersionFileResponse, lcVersionFileUrl

llReturn = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_SetLibrary', 'VFPConnection.fll')

If !llReturn
	Execscript (_Screen.cThorDispatcher, 'Result=', .f.)
	Return .f.
Endif

Try
	lcVersionFileResponse = HTTPSToStr(tcBitlyShortUrl)
Catch
	lcVersionFileResponse = '' 
Endtry

If !Empty(lcVersionFileResponse)
	lcVersionFileUrl = GetWordNum(lcVersionFileResponse, 2, '"')
Else
	lcVersionFileUrl = '' 
EndIf

Execscript (_Screen.cThorDispatcher, 'Result=', lcVersionFileUrl) 
Return lcVersionFileUrl

  