Lparameters lcToolName

Local lcDescription, lcLink, loThorUtils, loToolInfo

loToolInfo = Execscript(_Screen.cThorDispatcher, 'ToolInfo=', m.lcToolName)

lcLink	   = GetLink(m.loToolInfo.Link, m.lcToolName)
If Not Empty(m.lcLink)
	loThorUtils = Execscript(_Screen.cThorDispatcher, 'Thor_Proc_Utils')
	m.loThorUtils.GoURL(m.lcLink)
Else
	lcDescription = Evl(m.loToolInfo.Description, m.loToolInfo.Prompt)
	Messagebox(m.lcDescription, 0, m.loToolInfo.Prompt)
Endif

Endproc

* ================================================================================
* ================================================================================

Procedure GetLink(lcLink, lcFileName)
	Local lcTemp, lcURL, lcURLFile, lcURLFolder, llSuccess

	Private glQuiet

	glQuiet = .T.

	* Is there a md file (with name of tool) in the docs folder for ThorRepository?
	lcURLFolder	= 'https://github.com/VFPX/ThorRepository/blob/master/docs/'
	lcURLFile	= m.lcURLFolder + Lower(Juststem(m.lcFileName)) + '.md'
	If CheckLink(m.lcURLFile)
		Return m.lcURLFile
	Endif

	* Is there a txt file containing a link?
	lcURLFolder	= 'https://raw.githubusercontent.com/VFPX/ThorRepository/master/docs/'
	lcURLFile	= m.lcURLFolder + Lower(Juststem(m.lcFileName)) + '.txt'
	lcTemp		= Addbs(Sys(2023)) + Sys(2015)
	llSuccess	= Execscript (_Screen.cThorDispatcher, 'Thor_Proc_DownloadFileFromURL', m.lcURLFile, m.lcTemp)

	If m.llSuccess
		lcURL = Alltrim(Getwordnum(Filetostr(m.lcTemp), 2, '='), ' ', Chr[13], Chr[10], Chr[9])
		If Not Empty(m.lcURL)
			Return m.lcURL
		Endif
	Endif

	* Is there a link supplied?
	If Not Empty(m.lcLink)
		If CheckLink(m.lcLink)
			Return m.lcLink
		Endif
	Endif

	Return ''

Endproc


Procedure CheckLink(lcLink)
	Local lcDownloaded, lcTemp, lcTitle, llSuccess

	lcTemp	  = Addbs(Sys(2023)) + Sys(2015)
	llSuccess = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_DownloadFileFromURL', m.lcLink, m.lcTemp)
	Wait Clear
	If m.llSuccess
		lcDownloaded = Filetostr(m.lcTemp)
		Erase (m.lcTemp)
		lcTitle = Strextract(m.lcDownloaded, '<title>', '</title>', 1, 1)
		If Atc('page not found', m.lcDownloaded) # 0
			llSuccess = .F.
		Endif
	Endif

	Return m.llSuccess
Endproc

 