#Define 	ccThorVersionURL 	'https://raw.githubusercontent.com/VFPX/ThorNews/master/NewsItems/CurrentItemNumber.txt'
#Define 	ccThorNewsURL 		'https://github.com/VFPX/ThorNews/blob/main/NewsItems/Item_^^Version^^.md'

#Define 	ccTool 				'Thor News'
#Define     ccCheckForCFU		'Thor News/CFU'
#Define     ccRunThor			'Thor News/Run Thor'
#Define     ccRunThorInterval	'Thor News/Run Thor Interval'
#Define     ccDateLastSeen   	'Thor News/Last News - Date'
#Define     ccLastVersionSeen	'Thor News/Last News Version'

#Define     ccEditClassName 	'clsThorNews'

#Define ccCR  Chr[13]

Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1								;
		And 'O' = Vartype (m.lxParam1)		;
		And 'thorinfo' == Lower (m.lxParam1.Class)

	With m.lxParam1

		* Required
		.Prompt		   = 'Thor News' && used in menus
		.AppID 		   = 'Thor'

		* Optional
		.Description   = 'News headlines about Thor'
		.StatusBarText = ''

		* These are used to group and sort tools when they are displayed in menus or the Thor form
		.Category      = 'Thor' && creates categorization of tools; defaults to .Source if empty

		* For public tools, such as PEM Editor, etc.
		.Author		   = 'Jim Nelson'
		.OptionClasses = 'clsCheckForUpdates, clsRunThor, clsRunThorInterval, clsLastNewsDate, clsLastNewsVersion'
		.OptionTool	   = ccTool

	Endwith

	Return m.lxParam1
Endif

If Pcount() = 0
	Do ToolCode
Else
	Do ToolCode With m.lxParam1
Endif

Return

****************************************************************
* Normal processing for this tool begins here.                  
Procedure ToolCode
	Lparameters lxParam1

	Local loShell As 'wscript.shell'
	Local lcURL, lcVersion, lcVersionFileName, ldDataLastSeen, llCheckFirst, llFailed, llShowIt
	Local lnDateInterval, lnHTMLVersion, lnLastVersion

	* Main Thor Engine ... needed to get / set options
	llShowIt	 = .T.
	llCheckFirst = .F.
	Do Case
		Case 'L' = Vartype (m.lxParam1)

		Case Upper (m.lxParam1) = Upper ('Check For Updates')
			llShowIt	 = Execscript(_Screen.cThorDispatcher, 'Get Option=', ccCheckForCFU, ccTool)
			llCheckFirst = .T.

		Case Upper (m.lxParam1) = Upper ('RunThor')
			ldDataLastSeen = Execscript(_Screen.cThorDispatcher, 'Get Option=', ccDateLastSeen, ccTool)
			lnDateInterval = Execscript(_Screen.cThorDispatcher, 'Get Option=', ccRunThorInterval, ccTool)
			llShowIt = Execscript(_Screen.cThorDispatcher, 'Get Option=', ccRunThor, ccTool) And ;
				(m.ldDataLastSeen + m.lnDateInterval) <= Date()
			llCheckFirst = .T.
	Endcase

	If Not m.llShowIt
		Return
	Endif

	If Not Execscript (_Screen.cThorDispatcher, 'Thor_Proc_CheckInternetConnection')
		If 'L' = Vartype (m.lxParam1)
			Messagebox ('No Internet Connection Found!', 16, 'No Internet Connection', 0)
			Return .F.
		Endif
	Endif

	lcVersionFileName = Addbs (Sys(2023)) + 'Thor.NewsVersion' + Sys(2015) + '.txt'
	Try
		Execscript (_Screen.cThorDispatcher, 'Thor_Proc_DownloadFileFromURL', ccThorVersionURL, m.lcVersionFileName)
		lnHTMLVersion = GetVersionFromHTML (Filetostr (m.lcVersionFileName ))
		llFailed	  = .F.
	Catch
		llFailed = .T.
	Endtry

	If m.llFailed
		Return
	Endif

	Execscript(_Screen.cThorDispatcher, 'Set Option=', ccDateLastSeen, ccTool, Date())

	lnLastVersion = Nvl(Execscript(_Screen.cThorDispatcher, 'Get Option=', ccLastVersionSeen, ccTool), 0)
	If m.llCheckFirst And m.lnHTMLVersion = m.lnLastVersion
		Return
	Endif

	Execscript(_Screen.cThorDispatcher, 'Set Option=', ccLastVersionSeen, ccTool, m.lnHTMLVersion)

	loShell	  = Createobject ('wscript.shell')
	lcVersion = Transform(Int(m.lnHTMLVersion))
	lcURL	  = Strtran(ccThorNewsURL, '^^Version^^', m.lcVersion)
	m.loShell.Run (Textmerge(m.lcURL))

Endproc


Procedure GetVersionFromHTML (lcText)

	Local lcVersion, lnVersion

	lcVersion = Getwordnum(m.lcText, 2, '=')
	lnVersion = Val(Alltrim(m.lcVersion, 1, ' ', Chr[9], Chr[10], Chr[13]))
	Return m.lnVersion

Endproc

****************************************************************
****************************************************************

Define Class clsCheckForUpdates As Custom

	Tool		  = ccTool
	Key			  = ccCheckForCFU
	Value		  = .T.
	EditClassName = ccEditClassName

Enddefine


Define Class clsRunThor As Custom

	Tool		  = ccTool
	Key			  = ccRunThor
	Value		  = .T.
	EditClassName = ccEditClassName

Enddefine


Define Class clsRunThorInterval As Custom

	Tool		  = ccTool
	Key			  = ccRunThorInterval
	Value		  = 7
	EditClassName = ccEditClassName

Enddefine


Define Class clsLastNewsDate As Custom

	Tool		  = ccTool
	Key			  = ccDateLastSeen
	Value		  = {//}
	EditClassName = ccEditClassName

Enddefine


Define Class clsLastNewsVersion As Custom

	Tool		  = ccTool
	Key			  = ccLastVersionSeen
	Value		  = 0
	EditClassName = ccEditClassName

Enddefine

* a leftover
Define Class clsLastNewsVersion As Custom

	Tool		  = ccTool
	Key			  = 'Thor_Tool_Thor_CheckForUpdates'
	Value		  = 0
	EditClassName = ccEditClassName

Enddefine

****************************************************************
Define Class clsThorNews As Container

	Procedure Init
		loRenderEngine = Execscript(_Screen.cThorDispatcher, 'Class= OptionRenderEngine')

		TEXT To loRenderEngine.cBodyMarkup Noshow Textmerge
		
			.Class	   = 'Label'
			.Caption   = 'Check for updates to Thor News:'
			.FontBold  = .T.
			.Left      = 40
			.Autosize  = .T.
			|
			.Class	   = 'CheckBox'
			.Width	   = 300
			.Left	   = 25
			.ZWordWrap = .T.
			.Caption   = 'After running Check For Updates'
			.cTool	   = ccTool
			.cKey	   = ccCheckForCFU
			|
			.Class	   = 'CheckBox'
			.Width	   = 300
			.Left	   = 25
			.ZWordWrap = .T.
			.Caption   = 'After running RunThor'
			.cTool	   = ccTool
			.cKey	   = ccRunThor
			|
			.Class	   = 'Label'
			.Caption   = 'Number of days between checking:'
			.Autosize  = .T.
			.Left      = 40
			|
			.Class	   = 'Spinner'
			.Width     = 45
			.cTool	   = ccTool
			.cKey	   = ccRunThorInterval
			.Row-Increment = 0
			.Top       = (.Top - 4)
			
		ENDTEXT

		loRenderEngine.Render(This, ccTool)

	Endproc

Enddefine

