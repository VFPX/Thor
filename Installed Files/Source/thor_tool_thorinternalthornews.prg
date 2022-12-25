#Define 	ccThorNewsURL 		'http://vfpx.codeplex.com/wikipage?title=Thor%20News'

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
		And 'O' = Vartype (lxParam1)		;
		And 'thorinfo' == Lower (lxParam1.Class)

	With lxParam1

		* Required
		.Prompt		   = 'Thor News' && used in menus

		* Optional
		.Description   = 'News headlines about Thor'
		.StatusBarText = ''

		* These are used to group and sort tools when they are displayed in menus or the Thor form
		.Category      = 'Thor' && creates categorization of tools; defaults to .Source if empty

		* For public tools, such as PEM Editor, etc.
		.Author		   = 'Jim Nelson'
		.OptionClasses = 'clsCheckForUpdates, clsRunThor, clsRunThorInterval, clsLastNewsDate, clsLastNewsVersion'
		.OptionTool	   = ccTool 

		.ForumName 		= GetForumNames()
		.ForumLink 		= GetForumLinks()
*!* * Removed 11/16/2012 / JRN

*!* 		.BlogName 		= '-Jim Nelson'
*!* 		.BlogLink 		= 'http://jimrnelson.blogspot.com/'

		.ChangeLogName 	= GetChangeLogNames()
		.ChangeLogLink 	= GetChangeLogLinks()

	Endwith

	Return lxParam1
Endif

If Pcount() = 0
	Do ToolCode
Else
	Do ToolCode With lxParam1
Endif

Return


Procedure GetForumNames
	Local lcForums
	lcForums = '-Thor' && - Causes this to appear first; remainder are alphabetical
	lcForums = lcForums + chr(13) + 'OFUG'
	lcForums = lcForums + chr(13) + 'GoFish'
	lcForums = lcForums + chr(13) + 'Dynamic Forms'
	Return lcForums
Endproc

Procedure GetForumLinks
	Local lcForums
	lcForums = 'https://groups.google.com/forum/?fromgroups#!forum/FoxProThor'
	lcForums = lcForums + chr(13) + 'https://groups.google.com/forum/?fromgroups=#!forum/ofug'
	lcForums = lcForums + chr(13) + 'https://groups.google.com/forum/?fromgroups#!forum/FoxProGoFish'
	lcForums = lcForums + chr(13) + 'https://groups.google.com/forum/?fromgroups#!forum/FoxProDynamicForms'
	Return lcForums
Endproc

Procedure GetChangeLogNames
	Local lcChangeLogs
	lcChangeLogs = '-Thor'  && - Causes this to appear first; remainder are alphabetical
	lcChangeLogs = lcChangeLogs + chr(13) + 'PEM Editor'
	lcChangeLogs = lcChangeLogs + chr(13) + 'Thor Repository'
	lcChangeLogs = lcChangeLogs + chr(13) + 'IntellisenseX'
	lcChangeLogs = lcChangeLogs + chr(13) + 'VFPX Projects'
	Return lcChangeLogs
Endproc

Procedure GetChangeLogLinks
	Local lcChangeLogs
	lcChangeLogs = 'https://docs.google.com/document/d/1Fs4dwMq3Ckgr4vReP1_YxHc1wQnEyHX94tUfaFsZ4us/edit'
	lcChangeLogs = lcChangeLogs + chr(13) + 'https://docs.google.com/document/d/1WE_ItHG8JJMCF-YbMCeJCELd08Qjr4HYLzde55rk-oI/edit'
	lcChangeLogs = lcChangeLogs + chr(13) + 'https://docs.google.com/document/d/1ASU-huMjxQ3hl7rRw3OqoJOGeQ8bAvnxs_2mJINDPKY/edit'
	lcChangeLogs = lcChangeLogs + chr(13) + 'https://docs.google.com/document/d/1WRfYGzJAdcAWCcpcwbs_BOE8xpSOmK6T8zSPwZKKf54/edit'
	lcChangeLogs = lcChangeLogs + chr(13) + 'https://docs.google.com/document/d/1Tz5mZGZRu1Ynu4CX2qxaVba1JkaeETHSvMz--O4DzMc/edit'
	Return lcChangeLogs
Endproc

****************************************************************
****************************************************************
* Normal processing for this tool begins here.                  
Procedure ToolCode
	Lparameters lxParam1

	Local loShell As 'wscript.shell'
	Local lcHTMLFileName, ldDataLastSeen, llCheckFirst, llFailed, llShowIt, lnDateInterval
	Local lnHTMLVersion
	If Not Execscript (_Screen.cThorDispatcher, 'Thor_Proc_CheckInternetConnection')
		If 'L' = Vartype (lxParam1)
			Messagebox ('No Internet Connection Found!', 16, 'No Internet Connection', 0)
			Return .F.
		Endif
	Endif

	* Main Thor Engine ... needed to get / set options
	llShowIt	 = .T.
	llCheckFirst = .F.
	Do Case
		Case 'L' = Vartype (lxParam1)

		Case Upper (lxParam1) = Upper ('Check For Updates')
			llShowIt	 = ExecScript(_Screen.cThorDispatcher, "Get Option=", ccCheckForCFU, ccTool)
			llCheckFirst = .T.

		Case Upper (lxParam1) = Upper ('RunThor')
			ldDataLastSeen = ExecScript(_Screen.cThorDispatcher, "Get Option=", ccDateLastSeen, ccTool)
			lnDateInterval = ExecScript(_Screen.cThorDispatcher, "Get Option=", ccRunThorInterval, ccTool)
			llShowIt = ExecScript(_Screen.cThorDispatcher, "Get Option=", ccRunThor, ccTool) And			;
				(ldDataLastSeen + lnDateInterval) <= Date()
			llCheckFirst = .T.
	Endcase

	If Not llShowIt
		Return
	Endif

	lcHTMLFileName = Addbs (Sys(2023)) + 'ThorNews' + Sys(2015) + '.html'
	Try
		Execscript (_Screen.cThorDispatcher, 'Thor_Proc_DownloadFileFromURL', ccThorNewsURL, lcHTMLFileName)
		lnHTMLVersion = GetVersionFromHTML (Filetostr (lcHTMLFileName))
		llFailed	  = .F.
	Catch
		llFailed = .T.
	Endtry

	If llFailed
		Return
	Endif

	ExecScript(_Screen.cThorDispatcher, "Set Option=", ccDateLastSeen, ccTool, Date())

	If llCheckFirst And lnHTMLVersion = ExecScript(_Screen.cThorDispatcher, "Get Option=", ccLastVersionSeen, ccTool)
		Return
	Endif

	ExecScript(_Screen.cThorDispatcher, "Set Option=", ccLastVersionSeen, ccTool, lnHTMLVersion)

	loShell = Createobject ('wscript.shell')
	loShell.Run (ccThorNewsURL)

Endproc


Procedure GetVersionFromHTML (lcHTML)

	Local loRegExp As 'VBScript.RegExp'
	Local lnVersion, loMatches
	loRegExp = Createobject ('VBScript.RegExp')

	With loRegExp
		.IgnoreCase	= .T.
		.Global		= .T.
		.MultiLine	= .T.

		.Pattern  = '^.*<p>Last edited.*version.*</p>'
		loMatches = .Execute (lcHTML)
	Endwith

	If loMatches.Count # 0
		lnVersion = Val (Strextract (loMatches.Item[0].Value, 'version', '</p>', 1, 1))
	Else
		lnVersion = 0
	Endif

	Return lnVersion
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

		*##*TEXT To loRenderEngine.cBodyMarkup Noshow Textmerge
		
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
			
		*##*ENDTEXT

		loRenderEngine.Render(This, ccTool)

	Endproc

Enddefine

