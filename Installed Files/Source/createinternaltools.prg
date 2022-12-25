Local laPRGs[1], lcCode, lcCreateGetPROC, lcCreatePRG, lcFileName, lcInstallTool, lcNewProcs, lcPRG
Local lcProcName, lnI

loPRGList = Createobject('Collection')
AddPrgs(loPRGList, 'Thor_Tool_*.PRG')
AddPrgs(loPRGList, 'Procs_For_Thor\Thor_*.PRG')
*	AddPrgs(loPRGList, 'Updates\Thor_*.PRG')

lcCode	   = ''
lcNewProcs = ''

For lnI = 1 To loPRGList.Count
	lcPRG	   = Strtran(Alltrim (loPRGList[lnI]), '.PRG', '', 1, 1, 1)
	lcProcName = Substr (lcPRG, 1 + Rat ('\', lcPRG))
	lcFileName = Forceext (lcPRG, 'PRG')

	**********************************************
	TEXT To lcCreatePRG Textmerge Noshow

    InstallTool(Get<<lcProcName>> (tcFolder), ;
        lcToolsFolder + '<<lcFileName>>')

	ENDTEXT
	**********************************************

	lcCode = lcCode + lcCreatePRG + Chr(13) + Chr(10)

	**********************************************
	TEXT To lcCreateGetPROC Textmerge Noshow
Procedure Get<<lcProcName>> (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	{{TEXT}} To lcCode Noshow Textmerge
{{{{GoGet('<<lcPrg>>')}}}}
	{{ENDTEXT}}
	Return Strtran(lcCode, '*##*', '')

EndProc


	ENDTEXT
	**********************************************

	lcCreateGetPROC	= Strtran (lcCreateGetPROC, '{{TEXT}}', 'Text')
	lcCreateGetPROC	= Strtran (lcCreateGetPROC, '{{ENDTEXT}}', 'EndText')
	lcCreateGetPROC	= Strtran (lcCreateGetPROC, '{{{{', '<<<<')
	lcCreateGetPROC	= Strtran (lcCreateGetPROC, '}}}}', '>>>>')

	lcNewProcs = lcNewProcs + lcCreateGetPROC

Endfor

TEXT To lcInstallTool Textmerge Noshow
EndProc


Procedure InstallTool(tcCode, tcFileName)
	Erase (tcFileName)
	StrToFile (tcCode, tcFileName)

EndProc


ENDTEXT
Return lcCode + lcInstallTool + lcNewProcs




Procedure GoGet (tcFileName)
	Local lcResult, lcText
	*!*		If '\' $ tcFileName
	*!*			lcFolder = 'C:\Documents and Settings\Jim\My Documents\Dropbox\Public\Thor Repository\Current\'
	*!*			lcResult = Filetostr (Forceext (lcFolder + tcFileName, 'PRG'))
	*!*		Else
	lcResult = Filetostr (Forceext (tcFileName, 'PRG'))
	lcText	 = Strextract (lcResult, '.Version', Chr(13), 1, 5)
	If Not Empty (lcText) And '.VERSION' == Upper(GetWordNum(lcText, 1)) 
		lcResult = Stuff (lcResult, At (lcText, lcResult), Len (lcText), ".Version     = '<<lcVersion>>'" + Chr(13))
	Endif
	*!*		Endif
	Assert Not Empty(lcResult)
	Return lcResult
Endproc


Procedure AddPrgs (loPRGList, lcTemplate)
	Local laFiles[1], lcPrefix, lnFileCount, lnI
	lcPrefix = Left(lcTemplate, At('\', lcTemplate))
	lnFileCount = Adir(laFiles, lcTemplate,'',1)
	For lnI = 1 To lnFileCount
		loPRGList.Add(lcPrefix + laFiles[lnI,1])
	Endfor
Endproc


