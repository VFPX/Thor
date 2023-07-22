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

#Define CR Chr[13]
#Define LF Chr[10]

Procedure GetLink(lcLink, lcFileName)
	Local lcContentFolder, lcDestFile, lcDirectory, lcExt, lcTextLine, lcTool, lcURL, lcURLFolder
	Local llSuccess

	Private glQuiet

	glQuiet = .T.

	lcURLFolder		= 'https://github.com/VFPX/ThorRepository/blob/master/docs/'
	lcContentFolder	= 'https://raw.githubusercontent.com/VFPX/ThorRepository/master/docs/'

	lcDestFile = Addbs(Sys(2023)) + Sys(2015) + '.Directory.txt'
	llSuccess  = Download(m.lcContentFolder + 'Directory.txt', m.lcDestFile)

	lcDirectory	= Filetostr(m.lcDestFile)
	lcTextLine	= Strextract(m.lcDirectory, Juststem(m.lcFileName), LF, 1, 7)

	Do Case
		Case Not Empty(m.lcTextLine)
			lcTextLine = Chrtran(m.lcTextLine, CR + LF, '')
			lcTool	   = Getwordnum(m.lcTextLine, 1)
			lcExt	   = Getwordnum(m.lcTextLine, 2)
			lcURL	   = Getwordnum(m.lcTextLine, 3)

			If m.lcExt = 'TXT'
				Return m.lcURL
			Else
				Return m.lcURLFolder + lcStem + '.MD'
			Endif

		Case Not Empty(m.lcLink)
			If CheckLink(m.lcLink)
				Return m.lcLink
			Endif
	Endcase

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
		If Atc('page not found', m.lcDownloaded) # 0 Or Atc('{"httpStatus":404,"type":"httpError"}', m.lcDownloaded) # 0
			llSuccess = .F.
		Endif
	Endif

	Return m.llSuccess
Endproc


Procedure Download(lcURL, lcDestFile)
	Return Execscript (_Screen.cThorDispatcher, 'Thor_Proc_DownloadFileFromURL', m.lcURL, m.lcDestFile)
Endproc