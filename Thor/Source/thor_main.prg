#include Thor_UI.H
#Define ccSTARS Replicate('*', 40)

Lparameters tcAction, tlParam
* If we're running this PRG directly (ie. during Thor development), set a path
* to the Source folder and use the parent folder (the development directory) as
* the root. Otherwise, use the folder the application is running from as the
* root.

Local loGetThor As 'RunThor'
Local laStack[1], lcAction, lcApp, lcFolder, lcMessage, loThor

Astackinfo (laStack)
lcApp = laStack[Alen (laStack, 1), 2]
If Upper (Justfname (lcApp)) = 'THOR.FXP'
	lcFolder = Addbs (Justpath (Fullpath ('..\', lcApp)))
Else
	lcFolder = Addbs (Justpath (Fullpath (lcApp)))
Endif Upper (Justfname (lcApp)) = 'THOR.FXP'

****************************************************************

lcAction = Upper (Transform (tcAction))

Do Case
	Case lcAction = 'RUN'
		If Not ThorInstalled (lcFolder)
			ThorInstall (lcFolder)
		Endif
		ThorRun (lcFolder, tlParam)

	Case lcAction = 'EDIT'
		ThorEdit (lcFolder)

	Case lcAction = 'FORMRUNTOOL'
		ThorRunTool (lcFolder)

	Case lcAction = 'HELP'
		ThorHelp (lcFolder)

	Case lcAction = 'CLEAR HOTKEYS'
		ThorClearHotKeys (lcFolder)

	Case lcAction = 'ALL TOOLS'
		ThorAllTools (lcFolder)

	Case lcAction = 'THOR REPOSITORY'
		ThorAllTools (lcFolder, 'Thor Repository')

	Case lcAction = 'INSTALL'
		ThorInstall (lcFolder)
		lcMessage = 'Please use the Thor Forum for your questions, comments, etc. --'
		lcMessage = lcMessage + ccCR + "        Choose Forums->Thor from the main Thor menu."
		ExecScript(_screen.cThorDispatcher, 'Thor_Proc_Messagebox', lcMessage, 0, 'Thor Help and the Thor Community')

	Case ThorInstalled (lcFolder)

		ThorRun (lcFolder)

	Otherwise && Install

		Select 0

		ThorInstall (lcFolder)

		ThorRun (lcFolder)
		
		_Screen.AddProperty('cThorFolderParent', lcFolder)
		
		ExecScript(_Screen.cThorDispatcher, 'Thor_Tool_Thor_CheckForUpdates')

		ThorEdit (_Screen.cThorFolderParent)

Endcase
****************************************************************

Return



Function ThorInstalled (lcFolder)

	Local lcFileName
	lcFileName = lcFolder + 'Thor\' + ccThorVERSIONFILE

	If Not File (lcFileName)
		Return .F.
	Endif

	Return Filetostr (lcFileName) == ccTHORInternalVERSION

Endfunc



Procedure ThorInstall (lcFolder)

	CreateDirectoryStructure (lcFolder)

	CreateThorTables (lcFolder + 'Thor\Tables\')

	CreateRunThorPRG (lcFolder)

	CreateVersionNumber (lcFolder + 'Thor\')

	CreateThorInternalTools (lcFolder)
	
	Close Tables 

	If PemStatus(_screen, 'cThorDispatcher', 5)
		ExecScript(_screen.cThorDispatcher, 'Thor_Proc_Messagebox', ccTHORVERSION + ' installed', 0, 'Installation complete')
	Else 
		MessageBox(ccTHORVERSION + ' installed', 0, 'Installation complete', 3000)
	EndIf 

Endproc



Procedure CreateDirectoryStructure

	* Create the Thor directory structure if it doesn't already exist.

	Lparameters tcFolder

	CreateThorFolder(tcFolder + 'Thor')
	CreateThorFolder(tcFolder + 'Thor\Tables')
	CreateThorFolder(tcFolder + 'Thor\Tools')
	CreateThorFolder(tcFolder + 'Thor\Tools\Samples')
	CreateThorFolder(tcFolder + 'Thor\Tools\' + ccMyTools)
	CreateThorFolder(tcFolder + 'Thor\Tools\' + ccMySettings)
	CreateThorFolder(tcFolder + 'Thor\Tools\' + ccProcs)
	CreateThorFolder(tcFolder + 'Thor\Tools\' + ccUpdates)
	CreateThorFolder(tcFolder + 'Thor\Tools\' + ccUpdates + '\My Updates')
	CreateThorFolder(tcFolder + 'Thor\Tools\' + ccUpdates + '\Never Update')
	CreateThorFolder(tcFolder + 'Thor\Tools\' + ccUpdates + '\Removed')
	CreateThorFolder(tcFolder + 'Thor\Tools\' + ccApps)
	CreateThorFolder(tcFolder + 'Thor\Tools\' + ccComponents)
	CreateThorFolder(tcFolder + 'Thor\Tools\' + ccMyTemplates)

EndProc


Procedure CreateThorFolder(tcFolder)
	If Not Directory (tcFolder)
		Md (tcFolder)
	Endif
EndProc 


Procedure CreateThorTables
	Lparameters tcFolder

	* Create the Thor tables if they do not already exist

	Local loMenuDefs
	CreateHotKeyDefinitions (tcFolder)

	loMenuDefs = CreateMenuDefinitions (tcFolder)

	CreateMenuTools (tcFolder, loMenuDefs)

	CreateToolHotKeyAssignments (tcFolder)

	CreateStartUpTools (tcFolder)

	CreateToolBarTools (tcFolder)

	CreateFavorites (tcFolder)

	CreateTableAliases (tcFolder)

	* Thor preferences.
	If Not File (tcFolder + 'Thor.DBF')
		Create Table (tcFolder + 'Thor')  Free									;
			(Key C(30), Caption M, Value M, Display M, Type C(1), Valid M,		;
			  Class C(20), Library C(20))
	Else
		Use (tcFolder + 'Thor.DBF') Exclusive
	Endif Not File (tcFolder + 'Thor.DBF')

	If Empty (Field ('Tool'))
		Alter Table Thor Alter Column Class M
		Alter Table Thor Alter Column Library M

		Alter Table Thor Add Column SortKey N(6)
		Alter Table Thor Add Column Tool C(60)

		Replace All Tool With 'Thor', SortKey With Recno()
		Index On Iif (Tool = 'Thor', 'A', 'B') + Tool + Str (SortKey, 6, 0) + Key Tag Order
	Endif

	Locate For Key = 'ThorHotKey'
	Do Case
		Case Not Found()
			Insert Into Thor																;
				(Key, Caption, Value, Display, Type, Valid, 'Tool', Class, Library)			;
				Values ('ThorHotKey', ccTHOR_HOT_KEY,										;
				  'Alt-F12', 'Alt-F12', 'C', '', 'Thor', 'ThorOptionsControls', 'Thor_UI.vcx')
		Case Library # 'Thor_UI.vcx'
			Replace Tool With 'Thor', Class With 'ThorOptionsControls', Library With 'Thor_UI.vcx'
	Endcase

	Locate For Key = 'UpdateMessage'
	Do Case
		Case Not Found()
			Insert Into Thor																;
				(Key, Caption, Value, Display, Type, Valid, 'Tool', Class, Library)			;
				Values ('UpdateMessage', ccUPDATE_MESSAGE,									;
				  'Y', ccYES, 'L', '', 'Thor', 'ThorOptionsControls', 'Thor_UI.vcx')
		Case Library # 'Thor_UI.vcx'
			Replace Tool With 'Thor', Class With 'ThorOptionsControls', Library With 'Thor_UI.vcx'
	Endcase

	Locate For Key = 'FontSize'
	Do Case
		Case Not Found()
			Insert Into Thor																;
				(Key, Caption, Value, Display, Type, Valid, 'Tool', Class, Library)			;
				Values ('FontSize', ccFONT_SIZE,											;
				  '8', '8', 'N', '', 'Thor', 'ThorOptionsControls', 'Thor_UI.vcx')
		Case Library # 'Thor_UI.vcx'
			Replace Tool With 'Thor', Class With 'ThorOptionsControls', Library With 'Thor_UI.vcx'
	Endcase

	Locate For Key = 'LauncherFontSize'
	Do Case
		Case Not Found()
			Insert Into Thor																;
				(Key, Caption, Value, Display, Type, Valid, 'Tool', Class, Library)			;
				Values ('LauncherFontSize', ccFONT_SIZE,									;
				  '8', '8', 'N', '', 'Thor', 'ThorOptionsControls', 'Thor_UI.vcx')
		Case Library # 'Thor_UI.vcx'
			Replace Tool With 'Thor', Class With 'ThorOptionsControls', Library With 'Thor_UI.vcx'
	Endcase

	Locate For Key = 'ThorToolsSystemMenu'
	Do Case
		Case Not Found()
			Insert Into Thor																;
				(Key, Caption, Value, Display, Type, Valid, 'Tool', Class, Library)			;
				Values ('ThorToolsSystemMenu', ccUPDATE_MESSAGE,							;
				  'Y', ccYES, 'L', '', 'Thor', 'ThorOptionsControls', 'Thor_UI.vcx')
		Case Library # 'Thor_UI.vcx'
			Replace Tool With 'Thor', Class With 'ThorOptionsControls', Library With 'Thor_UI.vcx'
	Endcase

	Locate For Key = 'ThorToolsBarDock0'
	Do Case
		Case Not Found()
			Insert Into Thor																;
				(Key, Caption, Value, Display, Type, Valid, 'Tool', Class, Library)			;
				Values ('ThorToolsBarDock0', ccUPDATE_MESSAGE,							;
				  'N', ccNo, 'L', '', 'Thor', 'ThorOptionsControls', 'Thor_UI.vcx')
		Case Library # 'Thor_UI.vcx'
			Replace Tool With 'Thor', Class With 'ThorOptionsControls', Library With 'Thor_UI.vcx'
	Endcase

	AddThorOption('Settings in Home(7)', ccUPDATE_MESSAGE, 'N', ccNo, 'L', '', 'Thor', 'ThorOptionsControls', 'Thor_UI.vcx')
	
	*!* * Removed 06/01/2011
	*!* Locate For Key = 'SystemMenuPads'
	*!* If Not Found()
	*!* 		Insert Into Thor Values ('SystemMenuPads', ccSYSTEM_MENU_PADS,		;
	*!* 			'Y', ccYES, 'L', '', '', '')
	*!* Endif

	Use

	* LogFile

	If Not File (tcFolder + 'Thor_LogFile.DBF')
		Create Table (tcFolder + 'Thor_LogFile') Free		;
			(PRGName C(60), Count I, FirstTime T, LastTime T)
		Index On PRGName Tag PRGName
	Endif Not File (tcFolder + 'LogFile.DBF')

Endproc


Procedure AddThorOption(lcKey, lcCaption, lcValue, lcDisplay, lcType, lcValid, lcTool, lcClass, lcLibrary)
	Locate For Key = lcKey
	Do Case
		Case Not Found()
			Insert Into Thor																;
				(Key, Caption, Value, Display, Type, Valid, Tool, Class, Library)			;
				Values (lcKey, lcCaption, lcValue, lcDisplay, lcType, lcValid, lcTool, lcClass, lcLibrary)
		Case Library # 'Thor_UI.vcx'
			Replace Tool With lcTool, Class With lcClass, Library With lcLibrary
	Endcase
EndProc 


Procedure CreateHotKeyDefinitions (tcFolder)
	If Not File (tcFolder + 'HotKeyDefinitions.DBF')
		Create Table (tcFolder + 'HotKeyDefinitions') Free					;
			(Id I Autoinc, nKeyCode I, nShifts N(1), Descript C(40),		;
			  FKYValue C(2) NoCPTrans)
		Index On Id Tag Id
		Use
	Endif Not File (tcFolder + 'HotKeyDefinitions.DBF')
Endproc


Procedure 	CreateMenuDefinitions (tcFolder)

	Local loMenuDefs As 'Empty'
	If Not File (tcFolder + 'MenuDefinitions.DBF')
		Create Table (tcFolder + 'MenuDefinitions')  Free						;
			(Id I Autoinc, Prompt C(60), Internal L, TopLevel L, Popup L,		;
			  PopupName C(20), SortOrder I, HotKeyID I, StatusBar M)
		Index On SortOrder Tag SortOrder
		Index On Id Tag Id
		Index On HotKeyID Tag HotKeyID

		Insert Into MenuDefinitions (Prompt, Internal, TopLevel, PopupName, SortOrder)		;
			Values ('File', .T., .T., '_mFile', 1)
		Insert Into MenuDefinitions (Prompt, Internal, TopLevel, PopupName, SortOrder)		;
			Values ('Edit', .T., .T., '_mEdit', 2)
		Insert Into MenuDefinitions (Prompt, Internal, TopLevel, PopupName, SortOrder)		;
			Values ('View', .T., .T., '_mView', 3)
		Insert Into MenuDefinitions (Prompt, Internal, TopLevel, PopupName, SortOrder)		;
			Values ('Tools', .T., .T., '_mTools', 4)
		Insert Into MenuDefinitions (Prompt, Internal, TopLevel, PopupName, SortOrder)		;
			Values ('Program', .T., .T., '_mProg', 5)
		Insert Into MenuDefinitions (Prompt, Internal, TopLevel, PopupName, SortOrder)		;
			Values ('Window', .T., .T., '_mWindow', 6)
		Insert Into MenuDefinitions (Prompt, Internal, TopLevel, PopupName, SortOrder)		;
			Values ('Help', .T., .T., '_mSystem', 7)
		Insert Into MenuDefinitions (Prompt, Internal, TopLevel, PopupName, SortOrder)		;
			Values ('Tho\<r', .F., .T., 'Thor_Internal', 8)
	Else
		Use (tcFolder + 'MenuDefinitions.DBF') Exclusive
	Endif Not File (tcFolder + 'MenuDefinitions.DBF')

	If Empty(Field('Launcher', 'MenuDefinitions'))
		Alter Table MenuDefinitions Add Column Launcher L
	Endif

	loMenuDefs = Createobject('Empty')
	AddProperty(loMenuDefs, 'RunAllTools', 	CreateMenuDef('Tho\<r Tools', 	.F., .T., ccRunAllTools, 101))
	AddProperty(loMenuDefs, 'More', 		CreateMenuDef('More', 			.F., .F., 'Thor_More', 104))

	* Seemingly out of order, but done here because of already installed menus
	Locate For PopupName = 'Thor_Internal'
	Replace StatusBar With 'Configures Thor, gives access to help pages, the Thor framework, and the Thor discussion group; runs Check For Updates'

	Locate For PopupName = ccRunAllTools
	Replace StatusBar With 'Runs all Thor Tools'

	Use

	Return loMenuDefs

EndProc


Procedure CreateMenuTools (tcFolder, loMenuDefs)
	* MenuTools

	If Not File (tcFolder + 'MenuTools.DBF')
		Create Table (tcFolder + 'MenuTools') Free									;
			(Id I Autoinc, MenuID I, PRGName C(60), SubMenuID I, Separator L,		;
			  SortOrder I, Prompt C(60), StatusBar M)
		Index On SortOrder Tag SortOrder
		Index On SubMenuID Tag SubMenuID
		Index On MenuID Tag MenuID
		Index On Id Tag Id
	Else
		Use (tcFolder + 'MenuTools.DBF')
	Endif Not File (tcFolder + 'MenuTools.DBF')
	
	RemoveOldThorMainMenuItems(tcFolder, loMenuDefs)
	AddThorMainMenuItems(tcFolder, loMenuDefs)
	
EndProc


Procedure CreateMenuDef (lcPrompt, llInternal, llTopLevel, lcPopupName, lnSortOrder)
	Locate For PopupName = lcPopupName
	If not Found()
		Insert Into MenuDefinitions (Prompt, Internal, TopLevel, PopupName, SortOrder)		;
			Values (lcPrompt, llInternal, llTopLevel, lcPopupName, lnSortOrder)
	EndIf
	Return ID
EndProc 


Procedure CreateToolHotKeyAssignments (tcFolder)
	If Not File (tcFolder + 'ToolHotKeyAssignments.DBF')
		Create Table (tcFolder + 'ToolHotKeyAssignments') Free		;
			(Id I Autoinc, PRGName C(60), HotKeyID I)
		Index On HotKeyID Tag HotKeyID
		Index On Upper (PRGName) Tag PRGName
		Index On Id Tag Id
		Use
	Endif Not File (tcFolder + 'ToolHotKeyAssignments.DBF')
EndProc

Procedure CreateStartupTools (tcFolder)
	If Not File (tcFolder + 'StartupTools.DBF')
		Create Table (tcFolder + 'StartupTools')  Free		;
			(Id I Autoinc, PRGName C(60), StartUp L)
		Index On Upper (PRGName) Tag PRGName
		Index On Id Tag Id
		Use
	Endif Not File (tcFolder + 'StartupTools.DBF')
EndProc

Procedure CreateToolBarTools (tcFolder)
	If Not File (tcFolder + 'ToolBarTools.DBF')
		Create Table (tcFolder + 'ToolBarTools')  Free (		;
			Id 			I Autoinc, ;
			PRGName 	C(60), ;
			Enabled 	L, ;
			Icon 		C(200), ;
			ToolTip 	C(200), ;
			Order 		N(4), ;
			Style 		N(2), ;
			Caption 	C(60)) 
		Index On Upper (PRGName) Tag PRGName
		Index On Id Tag Id
	Else
		Use (tcFolder + 'ToolBarTools.DBF') Exclusive
	Endif Not File (tcFolder + 'Thor.DBF')

	If Empty (Field ('Caption'))
		Alter Table ToolBarTools Add Column Style   N(2)
		Alter Table ToolBarTools Add Column Caption C(60)
	EndIf
	Use 
EndProc


Procedure CreateFavorites (tcFolder)
	If Not File (tcFolder + 'Favorites.DBF')
		Create Table (tcFolder + 'Favorites')  Free		;
			(Id I Autoinc, PRGName C(60), StartUp L)
		Index On Upper (PRGName) Tag PRGName
		Index On Id Tag Id
		Use
	Endif Not File (tcFolder + 'Favorites.DBF')
EndProc


Procedure CreateTableAliases (tcFolder)
	If Not File (tcFolder + 'TableAliases.DBF')
		Create Table (tcFolder + 'TableAliases')  Free		;
			(Id I Autoinc, Alias C(40), Table C(200))
		Index On Upper (Alias) Tag Alias
		Index On Id Tag Id
	Else
		Use (tcFolder + 'TableAliases.DBF') Exclusive
	Endif 
	If Len(TableAliases.Table) < 200
		Alter Table TableAliases Alter Column Table C(200) 
	EndIf 
	
	Use
EndProc


Procedure CreateVersionNumber

	Lparameters tcFolder

	Erase (tcFolder + ccThorVERSIONFILE)
	Strtofile (ccTHORInternalVERSION, tcFolder + ccThorVERSIONFILE)

Endproc


Procedure AddThorMainMenuItems(tcFolder, loMenuDefs)

	Local lnMoreID
	AddThorMainMenuItem (8, 'Thor_Tool_ThorInternalRunTool', 105, 'Launcher', 'Find and run tools, explore descriptions, etc')
	AddThorMainMenuItem (8, ccINTERNALEDITPRG, 110, 'Configure', 'Assign hot keys, create menus and sub-menus, etc.')
	AddThorMainMenuItem (8, ccCHECKFORUPDATES, 120, 'Check for Updates', 'Check for and install any outstanding updates')

	AddThorMainMenuSeparator (8, 200, 'SEPARATOR1')

	AddThorMainMenuItem (8, ccThorNews, 	205, 	'Thor News', 'All the latest and greatest news about Thor and Thor tools.')
	AddThorMainMenuItem (8, ccThorTWEeTs, 	206, 	'Thor TWEeTs', "History of all Thor TWEeTs (This Week's Exceptional Tools")
	AddThorMainMenuItem (8, 'Thor-Forums', 	214, 	'Forums', '')
	AddThorMainMenuItem (8, 'Thor-Blogs', 	217, 	'Blogs', '')
	AddThorMainMenuItem (8, ccINTERNALHELPPRG, 220, 'Home Pages for VFPX Projects', 'Help for Thor')
	AddThorMainMenuItem (8, 'Thor-Videos', 	230,	'Thor videos', '')

	AddThorMainMenuSeparator (8, 300, 'SEPARATOR11')
	AddThorSubMenu (8, loMenuDefs.More, 999, 'More')

	lnMoreID = loMenuDefs.More
	AddThorMainMenuItem (lnMoreID, ccMANAGEPLUGINS, 210, 'Manage Plug-Ins', 'Manages plug-in PRGS used by some tools')
	AddThorMainMenuItem (lnMoreID, ccOPENFOLDERS, 220, 'Open Folder', 'Opens various Thor folders')
	AddThorMainMenuItem (lnMoreID, ccUSAGESUMMARY, 235, 'Thor Usage Summary', 'Summary of usage of Thor tools')

	AddThorMainMenuSeparator (lnMoreID, 300, 'SEPARATOR3')

	AddThorMainMenuItem (lnMoreID, ccINTERNALFRAMEWORK, 310, 'Thor Framework', 'Framework of tools to assist in creating tools')
	AddThorMainMenuItem (lnMoreID, ccDEBUGMODE, 320, 'Debug Mode', 'Toggles debug mode for working on Thor and IDE Tools')

	AddThorMainMenuSeparator (lnMoreID, 400, 'SEPARATOR41')
	AddThorMainMenuItem	(lnMoreID, 'Thor-ChangeLogs', 410, 'Change Logs', '')
	AddThorMainMenuItem	(lnMoreID, 'Thor-ERs', 420, 'Thor ERs', '')
Endproc


Procedure AddThorSubMenu (lnMenuID, lnSubmenuID, lnSortOrder, lcPrompt)
	Locate for MenuID = lnMenuID and SubMenuID = lnSubmenuID
	If Found()
		Replace sortorder with lnSortOrder, Prompt with lcPrompt
	Else
		Insert into MenuTools (MenuID, SubmenuID, SortOrder, Prompt);
		values (lnMenuID, lnSubmenuID, lnSortOrder, lcPrompt) 	
	EndIf

EndProc 


Procedure RemoveOldThorMainMenuItems(tcFolder, loMenuDefs)
	
	RemoveThorMainMenuItem (loMenuDefs.More, ccSOURCEFILES, 230, 'Source Files', 'Downloads source files for APPs')
	RemoveThorMainMenuItem (8, ccINTERNALALLTOOLSPRG, 120, 'Run Tool', 'All tools registered with Thor')

	RemoveThorMainMenuItem (8, ccINTERNALMODIFY, 210, 'Modify Tool', 'Open tool with Modify Command')
	RemoveThorMainMenuItem (8, ccMANAGEPLUGINS, 215, 'Manage Plug-Ins', 'Manages plug-in PRGS used by some tools')
	RemoveThorMainMenuItem (8, ccCOMMUNITY, 210, 'Community / Discussions', 'Community for discussing Thor, Thor Repository, and related topics.')
	RemoveThorMainMenuItem (8, ccOPENFOLDERS, 220, 'Open Folder', 'Opens various Thor folders')
	RemoveThorMainMenuItem (8, ccSOURCEFILES, 230, 'Source Files', 'Downloads source files for APPs')
	RemoveThorMainMenuItem (8, ccINTERNALFRAMEWORK, 240, 'Thor Framework', 'Framework of tools to assist in creating tools')
	RemoveThorMainMenuItem (8, ccDEBUGMODE, 250, 'Debug Mode', 'Toggles debug mode for working on Thor and IDE Tools')

	RemoveThorMainMenuSeparator (8, 500, 'SEPARATOR3')
	RemoveThorMainMenuSeparator (8, 300, 'SEPARATOR2')

	RemoveThorMainMenuItem (8, ccINTERNALRepostitory, 320, 'Repository Home Page', 'Home page for Thor Repository')
	RemoveThorMainMenuItem (8, ccINTERNALTOOLLINK, 330, 'Tool Home Pages', 'Home page for each tool (if any)')

EndProc


Procedure AddThorMainMenuItem (lnMenuID, lcPRGName, lnSortOrder, lcPrompt, lcStatusBar)
	Locate For MenuID = lnMenuID And Upper (PRGName) = Upper (lcPRGName)
	If Found()
		Replace SortOrder With lnSortOrder, Prompt With lcPrompt
	Else
		Insert Into MenuTools (MenuID, PRGName, SortOrder, Prompt, StatusBar)  ;
			Values (lnMenuID, lcPRGName, lnSortOrder, lcPrompt, lcStatusBar)
	Endif
Endproc


Procedure RemoveThorMainMenuItem (lnMenuID, lcPRGName, lnSortOrder, lcPrompt, lcStatusBar)
	Locate For MenuID = lnMenuID And Upper (PRGName) = Upper (lcPRGName)
	If Found()
		Delete
	Endif
Endproc


Procedure AddThorMainMenuSeparator (lnMenuID, lnSortOrder, lcStatusBar)
	Locate For MenuID = lnMenuID And Upper (StatusBar) = lcStatusBar
	If Found()
		Replace SortOrder With lnSortOrder
	Else
		Insert Into MenuTools (MenuID, SortOrder, Separator, StatusBar)	 ;
			Values (lnMenuID, lnSortOrder, .T., lcStatusBar)
	Endif
Endproc


Procedure RemoveThorMainMenuSeparator (lnMenuID, lnSortOrder, lcStatusBar)
	Locate For MenuID = lnMenuID And Upper (StatusBar) = lcStatusBar
	If Found()
		Delete
	Endif
Endproc


Procedure CreateRunThorPRG

	* Create the RunThor.PRG

	Lparameters tcFolder

	Local lcFolder, lcRunThor
	Text To lcRunThor Noshow Textmerge
Lparameters tnInterval, tlInstallAllUpdates

Local lcTableName

If Not Empty (tnInterval) And 'N' = VarType (tnInterval) And tnInterval > 0
	lcTableName = '<<tcFolder>>Thor\Tables\LastCheckForUpdatesDate.DBF'
	Select 0
	If File (lcTableName)
		Use (lcTableName)
	Else
		Create Table (lcTableName) Free (LastDate D)
	Endif

	If Reccount() = 0
		Append Blank
	Endif

	Goto Top
	If Date() >= LastDate + tnInterval
		Replace LastDate With Date()
		Use

		Do '<<tcFolder>>Thor.APP' With 'Run', .T. && installs Thor, but without startups

		Execscript (_Screen.cThorDispatcher, 'Thor_Tool_Thor_CheckForUpdates', tlInstallAllUpdates)
	Else
		Use
	Endif

Endif	

Do '<<tcFolder>>Thor.APP' With 'Run', .F. && normal installation of Thor (with startups)

Endtext

	*	lcFolder = tcFolder
	*	Erase (tcFolder + 'RunThor.???')
	*	Strtofile (lcRunThor, tcFolder + 'RunThor.PRG')

	lcFolder = tcFolder + 'Thor\'
	Erase (lcFolder + 'RunThor.???')
	Strtofile (lcRunThor, lcFolder + 'RunThor.PRG')

Endproc


Procedure ThorEdit (lcFolder)

	Local loThor As 'Thor_Engine' Of 'Thor.vcx'
	Local laPRGS[1], lcStartFolder, lnCount, lnI, loTools

	If Pemstatus (_Screen, 'oThorUI', 5) And 'O' = Vartype (_Screen.oThorUI)
		With _Screen.oThorUI
			If .WindowState = 1
				.WindowState = 0
			Endif
			.Show()
		Endwith
	Else
		loThor	= Newobject ('Thor_Engine', 'Thor.vcx', '', lcFolder)
		loTools	= loThor.GetToolsCollection (lcFolder + 'Thor\Tools\')
		_Screen.AddProperty ('oThorUI')
		Do Form ThorUI Name _Screen.oThorUI Linked With loTools, lcFolder

		lcStartFolder = lcFolder + 'Thor\Tools\' + ccMyStartThorUI
		lnCount		  = Adir (laPRGS, lcStartFolder + '\*.PRG')
		For lnI = 1 To lnCount
			Do (lcStartFolder + '\' + laPRGS[lnI, 1]) With _Screen.oThorUI
		Endfor
	Endif

Endproc


Procedure ThorRunTool (lcFolder)

	Local loThor As 'Thor_Engine' Of 'Thor.vcx'
	Local laPRGS[1], lcStartFolder, lnCount, lnI, loTools

	If Pemstatus (_Screen, 'oThorRunTool', 5) And 'O' = Vartype (_Screen.oThorRunTool)
		With _Screen.oThorRunTool
			If .WindowState = 1
				.WindowState = 0
			Endif
			.Show()
		Endwith
	Else
		_Screen.AddProperty ('oThorRunTool')
		Do Form ThorFormRunTool Name _Screen.oThorRunTool Linked With lcFolder
	Endif

Endproc


Procedure ThorHelp (lcFolder)
	Local loLink
	loLink = Newobject ('_ShellExecute', Home() + 'FFC\_Environ.vcx')
	loLink.ShellExecute (ThorHelpURL)
Endproc


Procedure ThorAllTools (lcFolder, lcSource)
	Local loGetThor As 'RunThor'
	Local loThor
	loGetThor = Createobject ('RunThor')
	loThor	  = loGetThor.GetThor (lcFolder + 'Thor.APP', lcFolder + 'Thor\')
	loThor.PopupAllTools (Set ('DataSession'), lcSource)
Endproc


Procedure ThorRun (lcFolder, tlParam)
	Local loGetThor As 'RunThor'
	Local loThor
	loGetThor = Createobject ('RunThor')
	loThor	  = loGetThor.GetThor (lcFolder + 'Thor.APP', lcFolder + 'Thor\')
	loThor.AddProperty('cApplication', lcFolder + 'Thor.APP')
	loThor.Run (tlParam)
	ExecScript(_Screen.cThorDispatcher, 'Thor_Tool_ThorInternalThorNews', 'RunThor')
Endproc


Procedure ThorClearHotKeys (lcFolder)
	Local loGetThor As 'RunThor'
	Local loThor
	loGetThor = Createobject ('RunThor')
	loThor	  = loGetThor.GetThor (lcFolder + 'Thor.APP', lcFolder + 'Thor\')
	loThor.ClearHotKeys ()
Endproc


Define Class RunThor As Session

	Procedure GetThor (lcApp, lcFolder)
		Return Newobject ('Thor_Run', 'thor_run.vcx', '', lcApp, lcFolder)
	Endproc

Enddefine


Procedure CreateThorInternalTools

	Lparameters tcFolder

	Local lcPRGName, lcToolsFolder
	lcToolsFolder = tcFolder + 'Thor\Tools\'

    InstallTool(GetThor_Tool_ThorInternalAllTools (tcFolder), ;
        lcToolsFolder + 'Thor_Tool_ThorInternalAllTools.PRG')

    InstallTool(GetThor_Tool_ThorInternalEdit (tcFolder), ;
        lcToolsFolder + 'Thor_Tool_ThorInternalEdit.PRG')

    InstallTool(GetTHOR_TOOL_THORINTERNALFRAMEWORK (tcFolder), ;
        lcToolsFolder + 'THOR_TOOL_THORINTERNALFRAMEWORK.PRG')

    InstallTool(GetThor_Tool_ThorInternalFrameworkHelp (tcFolder), ;
        lcToolsFolder + 'Thor_Tool_ThorInternalFrameworkHelp.PRG')

    InstallTool(GetThor_Tool_ThorInternalHelp (tcFolder), ;
        lcToolsFolder + 'Thor_Tool_ThorInternalHelp.PRG')

    InstallTool(GetThor_Tool_ThorInternalManagePlugIns (tcFolder), ;
        lcToolsFolder + 'Thor_Tool_ThorInternalManagePlugIns.PRG')

    InstallTool(GetThor_Tool_ThorInternalModifyTool (tcFolder), ;
        lcToolsFolder + 'Thor_Tool_ThorInternalModifyTool.PRG')

    InstallTool(GetThor_Tool_ThorInternalRepository (tcFolder), ;
        lcToolsFolder + 'Thor_Tool_ThorInternalRepository.PRG')

    InstallTool(GetThor_Tool_ThorInternalRepositoryHomePage (tcFolder), ;
        lcToolsFolder + 'Thor_Tool_ThorInternalRepositoryHomePage.PRG')

    InstallTool(GetThor_Tool_ThorInternalRunTool (tcFolder), ;
        lcToolsFolder + 'Thor_Tool_ThorInternalRunTool.PRG')

    InstallTool(Getthor_tool_thorinternalthornews (tcFolder), ;
        lcToolsFolder + 'thor_tool_thorinternalthornews.PRG')

    InstallTool(GetThor_Tool_ThorInternalToolLink (tcFolder), ;
        lcToolsFolder + 'Thor_Tool_ThorInternalToolLink.PRG')

    InstallTool(GetTHOR_TOOL_THORINTERNALTWEETS (tcFolder), ;
        lcToolsFolder + 'THOR_TOOL_THORINTERNALTWEETS.PRG')

    InstallTool(GetTHOR_TOOL_THORINTERNALUSAGESUMMARY (tcFolder), ;
        lcToolsFolder + 'THOR_TOOL_THORINTERNALUSAGESUMMARY.PRG')

    InstallTool(GetThor_Tool_Thor_CheckForUpdates (tcFolder), ;
        lcToolsFolder + 'Thor_Tool_Thor_CheckForUpdates.PRG')

    InstallTool(GetThor_Tool_Thor_Community (tcFolder), ;
        lcToolsFolder + 'Thor_Tool_Thor_Community.PRG')

    InstallTool(GetThor_Proc_AfterComponentInstall (tcFolder), ;
        lcToolsFolder + 'Procs\Thor_Proc_AfterComponentInstall.PRG')

    InstallTool(GetThor_Proc_BeforeComponentInstall (tcFolder), ;
        lcToolsFolder + 'Procs\Thor_Proc_BeforeComponentInstall.PRG')

    InstallTool(GetThor_Proc_CheckForUpdate (tcFolder), ;
        lcToolsFolder + 'Procs\Thor_Proc_CheckForUpdate.PRG')

    InstallTool(GetThor_Proc_CheckInternetConnection (tcFolder), ;
        lcToolsFolder + 'Procs\Thor_Proc_CheckInternetConnection.PRG')

    InstallTool(GetThor_Proc_Check_For_Updates (tcFolder), ;
        lcToolsFolder + 'Procs\Thor_Proc_Check_For_Updates.PRG')

    InstallTool(GetThor_Proc_DownloadAndExtractToPath (tcFolder), ;
        lcToolsFolder + 'Procs\Thor_Proc_DownloadAndExtractToPath.PRG')

    InstallTool(GetThor_Proc_DownloadAndInstallUpdates (tcFolder), ;
        lcToolsFolder + 'Procs\Thor_Proc_DownloadAndInstallUpdates.PRG')

    InstallTool(GetThor_Proc_DownloadFileFromURL (tcFolder), ;
        lcToolsFolder + 'Procs\Thor_Proc_DownloadFileFromURL.PRG')

    InstallTool(GetThor_Proc_Expand_Bitly_Url (tcFolder), ;
        lcToolsFolder + 'Procs\Thor_Proc_Expand_Bitly_Url.PRG')

    InstallTool(GetThor_Proc_ExtractFiles (tcFolder), ;
        lcToolsFolder + 'Procs\Thor_Proc_ExtractFiles.PRG')

    InstallTool(GetThor_Proc_ExtractFilesFromZip (tcFolder), ;
        lcToolsFolder + 'Procs\Thor_Proc_ExtractFilesFromZip.PRG')

    InstallTool(GetThor_Proc_ExtractToPath (tcFolder), ;
        lcToolsFolder + 'Procs\Thor_Proc_ExtractToPath.PRG')

    InstallTool(GetThor_Proc_GetAvailableVersionInfo (tcFolder), ;
        lcToolsFolder + 'Procs\Thor_Proc_GetAvailableVersionInfo.PRG')

    InstallTool(GetThor_Proc_GetUpdateList (tcFolder), ;
        lcToolsFolder + 'Procs\Thor_Proc_GetUpdateList.PRG')

    InstallTool(GetThor_Proc_GetUpdaterObject (tcFolder), ;
        lcToolsFolder + 'Procs\Thor_Proc_GetUpdaterObject.PRG')

    InstallTool(GetThor_Proc_GetUpdaterObject2 (tcFolder), ;
        lcToolsFolder + 'Procs\Thor_Proc_GetUpdaterObject2.PRG')

    InstallTool(GetThor_Proc_MessageBox (tcFolder), ;
        lcToolsFolder + 'Procs\Thor_Proc_MessageBox.PRG')

    InstallTool(GetThor_Proc_SetLibrary (tcFolder), ;
        lcToolsFolder + 'Procs\Thor_Proc_SetLibrary.PRG')

    InstallTool(GetThor_Proc_UpdateWaitWindow (tcFolder), ;
        lcToolsFolder + 'Procs\Thor_Proc_UpdateWaitWindow.PRG')

    InstallTool(GetThor_Proc_WriteToCFULog (tcFolder), ;
        lcToolsFolder + 'Procs\Thor_Proc_WriteToCFULog.PRG')

*** DH 2018-04-10: copy the contents of Source\Procs to Thor\Tools
	local lcSource, laFiles[1], lnFiles, lnI, lcFile
	lcSource = tcFolder + 'Source\Procs\'
	lnFiles  = adir(laFiles, lcSource + '*.*')
	for lnI = 1 to lnFiles
		lcFile = laFiles[lnI, 1]
*** DH 2021-12-28: added TRY structure
		try
			copy file (lcSource + lcFile) to (lcToolsFolder + lcFile)
		catch
		endtry
	next lnI
*** DH 2018-04-10: end of new code

EndProc


Procedure InstallTool(tcCode, tcFileName)
	Erase (tcFileName)
	StrToFile (tcCode, tcFileName)

EndProc

Procedure GetThor_Tool_ThorInternalAllTools (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1
		.Prompt		 = 'All Thor Tools'
		.Description = 'Menu of all tools registered with Thor'
		.Source		 = 'Thor'
		.Version     = '<<lcVersion>>'
		.Sort		 = 30
	Endwith

	Return lxParam1
Endif

Do ToolCode

Return

****************************************************************
****************************************************************
* Normal processing for this tool begins here.
Procedure ToolCode
	Do '<<tcFolder>>Thor.APP' with 'All Tools'
EndProc

	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Tool_ThorInternalEdit (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1
		.Prompt		 = 'Edit Thor'
		.Summary     = 'Form for Thor'
		.Description = 'Opens main Thor form: assign hot keys to tools, create popup menus and assign hot keys to them,';
			+ ' modify VFP system menus, etc.'
		.FolderName	 = '<<tcFolder>>'
		.Source		 = 'Thor'
		.Version     = '<<lcVersion>>'
		.Sort		 = 10
	Endwith

	Return lxParam1
Endif

Do ToolCode

Return

****************************************************************
****************************************************************
* Normal processing for this tool begins here.
Procedure ToolCode
	Do '<<tcFolder>>Thor.APP' with 'Edit'
EndProc

	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetTHOR_TOOL_THORINTERNALFRAMEWORK (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
#Define ccLF 	Chr(10)
#Define ccCR 	Chr(13)
#Define ccTab  	Chr(9)
#Define ccCRLF 	ccCR + ccLF

Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1								;
		And 'O' = Vartype (lxParam1)		;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1
		.Prompt		 = 'Framework'
		.Description = 'Framework of tools to assist in creating tools'
		.Source		 = 'Thor'
		.Version     = '<<lcVersion>>'
		.Sort		 = 30
	Endwith

	Return lxParam1

Endif

Do ToolCode

Return

****************************************************************
****************************************************************
* Normal processing for this tool begins here.

Procedure ToolCode
	Local loFramework As Object
	Local laLines[1], lcDisplay, lcFileName, lcHomePage, lcIndent, lcLine, lcThisLine, lcVariable
	Local lnCount, lnI, lnPos

	lcIndent	= '' && Chr(9)
	loFramework	= Execscript (_Screen.cThorDispatcher, '?')

*** DH 2018-04-10: new URL
	lcDisplay = '* ' + [<<lcVersion>>] + ccCRLF + ccCRLF		;
		+  '*   Thor Framework home page =  https://github.com/VFPX/Thor/blob/master/Docs/Thor_tools_making_tools.md'

	If Not Empty (loFramework.External)
		lnCount	  = Alines ( laLines, loFramework.External, 5)
		lcDisplay = lcDisplay + ccCRLF + ccCRLF +  + Replicate ('*', 40) + ' External APPs ' + Replicate ('*', 40)
		For lnI = 1 To lnCount
			lcLine = laLines[lnI]
			If '||' $ lcLine
				lnPos	   = At ('||', lcLine)
				lcVariable = Left (lcLine, lnPos - 1) + ' = '
				lcLine	   = Substr (lcLine, lnPos + 2)
			Else
				lcVariable = ''
			Endif

			If '|' $ lcLine
				lnPos	   = At ('|', lcLine)
				lcHomePage = Substr (lcLine, lnPos + 1)
				lcThisLine = Left (lcLine, lnPos - 1)
				lcDisplay = lcDisplay + ccCRLF													;
					+ ccCRLF + lcIndent + '* ' + Getwordnum (lcThisLine, 2) + ' home page = ' + lcHomePage ;
					+ CreateLocalIntellisense (lcVariable, lcThisLine)							;
					+ ccCRLF + lcIndent + lcVariable + 'ExecScript(_Screen.cThorDispatcher, "' + lcThisLine;
    				 + IIF(0 = (Occurs(["], lcThisLine) % 2), '"', '') + ')'
			Else
				lcDisplay = lcDisplay + ccCRLF								;
					+ CreateLocalIntellisense (lcVariable, lcThisLine)		;
					+ ccCRLF + lcIndent + lcVariable + 'ExecScript(_Screen.cThorDispatcher, "' + lcLine;
    				 + IIF(0 = (Occurs(["], lcLine) % 2), '"', '') + ')'
			Endif
		Endfor
	Endif

	lcDisplay = lcDisplay + ccCRLF + ccCRLF + Replicate ('*', 40) + '* Internal *' + Replicate ('*', 40)
	lnCount	  = Alines ( laLines, loFramework.Internal, 5)

	For lnI = 1 To lnCount
		lcLine = laLines[lnI]
		Do Case
			Case lcLine = [Empty]
				lcDisplay = lcDisplay + ccCRLF
			Case lcLine = '*' or lcLine = 'Local'
				lcDisplay = lcDisplay + ccCRLF + lcIndent + lcLine
			Otherwise
				If '|' $ lcLine
					lnPos = At ('|', lcLine)
					lcDisplay = lcDisplay + ccCRLF + lcIndent		;
						+ Left (lcLine, lnPos - 1) + ' = ExecScript(_Screen.cThorDispatcher, "' + Substr (lcLine, lnPos + 1) ;
						+ IIF(0 = (Occurs(["], lcLine) % 2), '"', '') + ')'
				Else
					lcDisplay = lcDisplay + ccCRLF + lcIndent		;
						+ 'ExecScript(_Screen.cThorDispatcher, "' + lcLine ;
						+ IIF(0 = (Occurs(["], lcLine) % 2), '"', '') + ')'
				Endif
		Endcase
	Endfor

	lcFileName = Forceext (Addbs (Sys(2023)) + 'ThorFramework', 'prg')
	Try
		Erase (lcFileName)
		Strtofile (lcDisplay, lcFileName, .F.)
	Catch

	Endtry
	Modify Command (lcFileName) Nowait

Endproc


Procedure CreateLocalIntellisense (lcVariable, lcThisLine)
	Local lcClass, lcClassLibrary, lcQuote, lcResult, loObject

	loObject = Execscript (_Screen.cThorDispatcher, lcThisLine)
	If 'O' # Vartype (loObject)
		Return ''
	Endif

	lcClass		   = loObject.Class
	lcClassLibrary = loObject.ClassLibrary
	If File (lcClassLibrary)
		lcQuote	 = Iif (' ' $ lcClassLibrary, '"', '')
		lcResult = ccCRLF + 'Local ' + Alltrim (lcVariable, 1, ' ', '=' ) + ' as ' + lcClass + ' of ' + lcQuote + lcClassLibrary + lcQuote
		Return lcResult
	Else
		Return ''
	Endif

Endproc

	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Tool_ThorInternalFrameworkHelp (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
*** DH 2018-04-10: new URL for .Link
	Text To lcCode Noshow Textmerge
Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1
		.Prompt		 = 'Help for Thor Framework'
		.Description = 'Follows link to Thor Home Page'
		.Source		 = 'Thor'
		.Version     = '<<lcVersion>>'
		.Sort		 = 20
		.Link        = 'https://github.com/VFPX/Thor/blob/master/Docs/Thor_help.md'
	Endwith

	Return lxParam1
Endif

Do ToolCode

Return

****************************************************************
****************************************************************
* Normal processing for this tool begins here.
Procedure ToolCode
	Do '<<tcFolder>>Thor.APP' with 'Help'
EndProc

	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Tool_ThorInternalHelp (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
*** DH 2018-04-10: new URL for .Link
	Text To lcCode Noshow Textmerge
Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1
		.Prompt		 = 'Help for Thor'
		.Description = 'Follows link to Thor Home Page'
		.Source		 = 'Thor'
		.Version     = '<<lcVersion>>'
		.Sort		 = 20
		.Link        = 'https://github.com/VFPX/Thor/blob/master/Docs/Thor_help.md'
	Endwith

	Return lxParam1
Endif

Do ToolCode

Return

****************************************************************
****************************************************************
* Normal processing for this tool begins here.
Procedure ToolCode
	lcFormFileName = Execscript (_Screen.cThorDispatcher, 'Full Path=Thor_Proc_ProjectHomePages.SCX')
	Do Form (lcFormFileName)
EndProc

	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Tool_ThorInternalManagePlugIns (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' == Lower (lxParam1.Class)

	With lxParam1

		* Required
		.Prompt	 = 'Manage Plug-In PRGs'
		.Summary = 'Manage Plug-In PRGs'

		* Optional
		.Description = 'Manage Plug-In PRGs'

		* These are used to group and sort tools when they are displayed in menus or the Thor form
		.Category = 'Settings & Misc.' && allows categorization for tools with the same source
		.Sort	  = 999 && the sort order for all items from the same Source, Category and Sub-Category
		.PlugInClasses = 'clsBeforeComponentInstall, clsAfterComponentInstall'

		* For public tools, such as PEM Editor, etc.
		.Author        = 'Jim Nelson'
		.CanRunAtStartup = .F.

	Endwith

	Return lxParam1
Endif

If Pcount() = 0
	Do ToolCode
Else
	Do ToolCode With lxParam1
Endif

Return

****************************************************************
****************************************************************
* Normal processing for this tool begins here.                  
Procedure ToolCode
	Lparameters lxParam1

	Local lcFileName
	If Type ('_Screen.cThorDispatcher') = 'C'
		Execscript (_Screen.cThorDispatcher, 'PEMEditor_StartIDETools')
		lcFileName    = Execscript (_Screen.cThorDispatcher, 'Full Path=Thor_Tool_ThorInternalManagePlugIns.SCX')
		Do Form  (lcFileName)
	Else
		Messagebox ('Thor is not active; this tool requires Thor', 16, 'Thor is not active', 0)
	Endif

Endproc


****************************************************************
****************************************************************

Define Class clsBeforeComponentInstall As Custom

	Source				= 'Thor'
	PlugIn				= 'BeforeComponentInstall'
	Description			= 'Called during "Check For Updates" before a component is installed (in a sub-folder of Thor\Tools\Components).'
	Tools				= 'Check For Updates'
	FileNames			= 'Thor_Proc_BeforeComponentInstall.PRG'
	DefaultFileName		= '*Thor_Proc_BeforeComponentInstall.PRG'
	DefaultFileContents	= ''

	Procedure Init
		****************************************************************
		****************************************************************
		*##*Text To This.DefaultFileContents Noshow
Lparameters tcApplicationName, tcInstallationFolder

		*##*Endtext
		****************************************************************
		****************************************************************
	Endproc

Enddefine


****************************************************************
****************************************************************

Define Class clsAfterComponentInstall As Custom

	Source				= 'Thor'
	PlugIn				= 'AfterComponentInstall'
	Description			= 'Called during "Check For Updates" after a component is installed (in a sub-folder of Thor\Tools\Components).'
	Tools				= 'Check For Updates'
	FileNames			= 'Thor_Proc_AfterComponentInstall.PRG'
	DefaultFileName		= '*Thor_Proc_AfterComponentInstall.PRG'
	DefaultFileContents	= ''

	Procedure Init
		****************************************************************
		****************************************************************
		*##*Text To This.DefaultFileContents Noshow
Lparameters tcApplicationName, tcInstallationFolder

		*##*Endtext
		****************************************************************
		****************************************************************
	Endproc

Enddefine


	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Tool_ThorInternalModifyTool (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1
		.Prompt		 = 'Modify Tool'
		.Description = 'Menu to open Thor tools for modification with Modify Command'
		.Source		 = 'Thor'
		.Version     = '<<lcVersion>>'
		.Sort		 = 30
	Endwith

	Return lxParam1
Endif

Do ToolCode

Return

****************************************************************
****************************************************************
* Normal processing for this tool begins here.
Procedure ToolCode
	Do '<<tcFolder>>Thor.APP' with 'All Tools'
EndProc

	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Tool_ThorInternalRepository (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1
		.Prompt		 = 'All Thor Repository Tools'
		.Description = 'Menu of all tools registered in the Thor Repository'
		.Source		 = 'Thor'
		.FolderName	 = '<<tcFolder>>Thor\Tools\'
		.Version     = '<<lcVersion>>'
		.Sort		 = 40
	Endwith

	Return lxParam1
Endif

Do ToolCode

Return

****************************************************************
****************************************************************
* Normal processing for this tool begins here.
Procedure ToolCode
	Do '<<tcFolder>>Thor.APP' with 'Thor Repository'
EndProc

	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Tool_ThorInternalRepositoryHomePage (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
*** DH 2018-04-10: new URL for #DEFINE
	Text To lcCode Noshow Textmerge
#Define ThorFrameworkURL 		'https://github.com/VFPX/Thor/blob/master/Docs/Thor_repository.md'

Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1
		.Prompt		 = 'Link to Thor Repository'
		.Description = 'Link to Home Page for Thor Repository'
		.Source		 = 'Thor'
		.Version     = '<<lcVersion>>'
		.Sort		 = 20
		.Link        = ThorFrameworkURL
	Endwith

	Return lxParam1
Endif

Do ToolCode

Return

****************************************************************
****************************************************************
* Normal processing for this tool begins here.
Procedure ToolCode
	Local loLink
	loLink = Newobject ('_ShellExecute', Home() + 'FFC\_Environ.vcx')
	loLink.ShellExecute (ThorFrameworkURL)
EndProc

	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Tool_ThorInternalRunTool (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1								;
		And 'O' = Vartype (lxParam1)		;
		And 'thorinfo' == Lower (lxParam1.Class)

	With lxParam1

		.Prompt		 = 'Tool Launcher'
		.Description = 'Find and run tools, browse descriptions, set options, ...'
		.Source		 = 'Thor'
		.Version     = '<<lcVersion>>'
		.Sort		 = 20
		.CanRunAtStartUp = .T.
		.VideoLink   = 'http://youtu.be/2ttBR9vQqew'

	Endwith

	Return lxParam1
Endif

If Pcount() = 0
	Do ToolCode
Else
	Do ToolCode With lxParam1
Endif

Return

****************************************************************
****************************************************************
* Normal processing for this tool begins here.                  
Procedure ToolCode
	Lparameters lxParam1

	Execscript (_Screen.cThorDispatcher, 'FORMRUNTOOL')

Endproc

	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure Getthor_tool_thorinternalthornews (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
*** DH 2018-04-10: new URL for #DEFINE
	Text To lcCode Noshow Textmerge
#Define 	ccThorNewsURL 		'https://github.com/VFPX/Thor/blob/master/Docs/Thor_news.md'

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


	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Tool_ThorInternalToolLink (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1
		.Prompt		 = 'Tool Home Page'
		.Description     = 'Menu to access home page (or description) for any tool'
		.Source		 = 'Thor'
		.Version     = '<<lcVersion>>'
		.Sort		 = 30
	Endwith

	Return lxParam1
Endif

Do ToolCode

Return

****************************************************************
****************************************************************
* Normal processing for this tool begins here.
Procedure ToolCode
	Do '<<tcFolder>>Thor.APP' with 'All Tools'
EndProc

	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetTHOR_TOOL_THORINTERNALTWEETS (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
*** DH 2018-04-10: new URL
	Text To lcCode Noshow Textmerge
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
		.Prompt		   = 'Thor TWEeTs' && used in menus

		* Optional
		.Description   = 'Home page for Thor TWEeTs'
		.StatusBarText = ''

		* These are used to group and sort tools when they are displayed in menus or the Thor form
		.Category      = 'Thor' && creates categorization of tools; defaults to .Source if empty

		* For public tools, such as PEM Editor, etc.
		.Author		   = 'Jim Nelson'

	Endwith

	Return lxParam1
Endif

If Pcount() = 0
	Do ToolCode
Else
	Do ToolCode With lxParam1
Endif

Return



****************************************************************
****************************************************************
* Normal processing for this tool begins here.                  
Procedure ToolCode
	Lparameters lxParam1

	If Not Execscript (_Screen.cThorDispatcher, 'Thor_Proc_CheckInternetConnection')
		If 'L' = Vartype (lxParam1)
			Messagebox ('No Internet Connection Found!', 16, 'No Internet Connection', 0)
			Return .F.
		Endif
	Endif

	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_Shell', 'https://github.com/VFPX/Thor/blob/master/Docs/TWEeTs.md')


Endproc



	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetTHOR_TOOL_THORINTERNALUSAGESUMMARY (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1								;
		And 'O' = Vartype(lxParam1)			;
		And 'thorinfo' == Lower(lxParam1.Class)

	With lxParam1

		* Required
		.Prompt		   = 'Thor usage summary' && used in menus

		* Optional
		.Description = 'Summary of usage of Thor tools'

		* These are used to group and sort tools when they are displayed in menus or the Thor form
		.Category      = 'Thor' && creates categorization of tools; defaults to .Source if empty

		* For public tools, such as PEM Editor, etc.
		.Author        = 'Jim Nelson'

	Endwith

	Return lxParam1
Endif

If Pcount() = 0
	Do ToolCode
Else
	Do ToolCode With lxParam1
Endif

Return

****************************************************************
****************************************************************
* Normal processing for this tool begins here.                  
Procedure ToolCode
	Lparameters lxParam1

	Local loThor As Thor_Engine Of 'C:\VISUAL FOXPRO\PROGRAMS\9.0\COMMON\Thor\Source\Thor.vcx'
	Local lcKey, lcToolFolder, loTool, loTools

	* Main Thor Engine
	loThor        = Execscript(_Screen.cThorDispatcher, 'Thor Engine=')

	lcToolFolder  = Execscript(_Screen.cThorDispatcher, 'Tool Folder=')

	loTools = loThor.GetToolsCollection(Addbs(lcToolFolder))

	Select  *														;
			  From(lcToolFolder + '..\Tables\Thor_LogFile')			;
		Order By Count Desc											;
		Into Cursor Thor_Summary Readwrite
	Use In Thor_LogFile
	Scan
		lcKey = Upper(Forceext(Alltrim(prgname), 'prg'))
		If 0 # loTools.GetKey(lcKey)
			loTool = loTools.Item(lcKey)
			Replace prgname With loTool.Prompt
		Endif
	Endscan

	Goto Top
	Browse Normal Nowait

Endproc

	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Tool_Thor_CheckForUpdates (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
Lparameters tlInstallAllUpdates

If Vartype (tlInstallAllUpdates) # 'L'
	Return
Endif

Execscript (_Screen.cThorDispatcher, 'Thor_Proc_Check_For_Updates')

	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Tool_Thor_Community (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
#Define ThorCommunityURL 		'http://groups.google.com/group/FoxProThor'

Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1
		.Prompt		 = 'Community / Discussions'
		.Description = 'Link to home page for discussions about Thor'
		.Source		 = 'Thor'
		.Version     = '<<lcVersion>>'
		.Sort		 = 30
	Endwith

	Return lxParam1

Endif

Do ToolCode

Return


****************************************************************
****************************************************************
* Normal processing for this tool begins here.
Procedure ToolCode
	Local loLink
	loLink = Newobject ('_ShellExecute', Home() + 'FFC\_Environ.vcx')
	loLink.ShellExecute (ThorCommunityURL)
EndProc

	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Proc_AfterComponentInstall (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
Lparameters tcApplicationName, tcInstallationFolder, tcZipFile


	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Proc_BeforeComponentInstall (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
Lparameters tcApplicationName, tcInstallationFolder


	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Proc_CheckForUpdate (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
Lparameters toUpdateInfo

*-- Get the available version from the cloud. (2011-11-07 M. Slay - Revised to pass in UpdateInfo object
toUpdateInfo = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_GetAvailableVersionInfo', toUpdateInfo)

Execscript (_Screen.cThorDispatcher, 'Result=', toUpdateInfo) 
Return toUpdateInfo  
	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Proc_CheckInternetConnection (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
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

	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Proc_Check_For_Updates (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
Local laFiles[1], lcToolFolder, lcUpdateFolder, llAutoRun, lnFileCount, lnI, lnReturn

*** DH 2021-12-28: changed URL from VFPXRepository to GitHub
#Define UpdaterURL 'https://raw.githubusercontent.com/VFPX/Thor/master/ThorUpdater/Updates.zip'

*** DH 2022-01-06: added SET SAFETY OFF to eliminate overwrite prompts
set safety off

WritetoCFULog('Begin CFU - ' + Transform(Datetime()))

If Not Execscript (_Screen.cThorDispatcher, 'Thor_Proc_CheckInternetConnection')
	Messagebox ('No Internet Connection Found!', 16, 'No Internet Connection', 0)
	Return .F.
Endif

WritetoCFULog('Checking for updates to Thor', .T.)

If Execscript (_Screen.cThorDispatcher, 'Thor_Proc_DownloadAndInstallUpdates', .T.) >= 0

	lcToolFolder   = Execscript (_Screen.cThorDispatcher, 'Tool Folder=')
	WritetoCFULog('Erasing Thor FXP files...')
	EraseFXPFiles (lcToolFolder)
	WritetoCFULog('Erasing Thor FXP files from Thor Procs folder...')
	EraseFXPFiles (lcToolFolder + 'Procs')
	WritetoCFULog('Erasing Thor FXP files from Thor MyTools folder...')
	EraseFXPFiles (lcToolFolder + 'My Tools')

	lcUpdateFolder = Addbs (lcToolFolder) + 'Updates\'
	lnFileCount	   = Adir (laFiles, lcUpdateFolder + '*.PRG')
	WritetoCFULog('Processing (' + transform(lnFileCount) + ') Thor updater programs...')

	For lnI = 1 To lnFileCount
		If Not Upper (laFiles[lnI, 1]) == Upper ('Thor_Update_Thor.PRG')
			Erase (lcUpdateFolder + laFiles[lnI, 1])
		Endif
	Endfor
	*** Download the zip of Updaters, and install them
	lnReturn = Execscript (_Screen.cThorDispatcher	;
		  , 'Thor_Proc_DownloadAndExtractToPath'	;
		  , UpdaterURL + '?=' + Sys(2015)			;
		  , lcToolFolder							;
		  , .T.										;
		  , 'Updates')

	*** Check if called from RunThor, meaning it is from AutoRun
	llAutoRun = .F.
	For lnI = 1 To Program (-1)
		llAutoRun = llAutoRun Or 'RUNTHOR' $ Upper (Sys(16, lnI))
	Endfor

	WritetoCFULog('Checking for updates to all other apps', .T.)
	
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_DownloadAndInstallUpdates', .F., llAutoRun)

	Execscript (_Screen.cThorDispatcher, 'Run')

Endif

Execscript (_Screen.cThorDispatcher, 'Thor_Tool_ThorInternalThorNews', 'Check For Updates')

Wait Clear

Return


Procedure EraseFXPFiles (tcFolder)
	Local lcFolder, lnCount, lnI, loException
	lcFolder = Addbs (tcFolder)
	lnCount	 = Adir (laFiles, lcFolder + '*.FXP')
	For lnI = 1 To lnCount
		Try
			Erase (lcFolder + laFiles[lnI, 1])
		Catch To loException

		Endtry
	Endfor
Endproc


Procedure WritetoCFULog(tcText, tlDivider)
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WritetoCFULog(', tcText, tlDivider)
EndProc 

	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Proc_DownloadAndExtractToPath (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
Lparameters tcSourceFileURL, tcInstallPath, tlShowCopyErrorDialog, tcAppName

#Define ERROR_DOWNLOADING_FILE	-1
#Define ERROR_EXTRACTING_FILE	-2
#Define ERROR_INSTALLING_FILES	-3

Local lcDownloadDestinationFile, lcDownloadPath, lcTempName, llReturn, lnReturn

*--- Download the file to temp folder ---------------------------
_Screen.AddProperty ('cThorLastZipFile', '')

lcDownloadPath			  = Sys(2023) && Store ZIP file to user's Temp folder
lcTempName				  = 'Thor_ToolInstaller_' + Evl (tcAppName, 'X') + Sys(2015)
lcDownloadDestinationFile = Addbs (lcDownloadPath) + lcTempName + '.zip' && create a random name for the ZIP file

llReturn = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_DownloadFileFromURL', tcSourceFileURL, lcDownloadDestinationFile)

If Not llReturn
	Return Execscript (_Screen.cThorDispatcher, 'Result=', ERROR_DOWNLOADING_FILE)
Endif

_Screen.AddProperty ('cThorLastZipFile', lcDownloadDestinationFile)

*-- Extract to temp folder and then to target install folder ----------
lnReturn = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_ExtractToPath'  ;
	  , lcDownloadDestinationFile, lcTempName, tcAppName, tcInstallPath, tlShowCopyErrorDialog)

Return Execscript (_Screen.cThorDispatcher, 'Result=', lnReturn)

	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Proc_DownloadAndInstallUpdates (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
Lparameters tlIsThor, llAutoRun

Local lnReturn
lnReturn = CheckForUpdates_Main (tlIsThor, llAutoRun)

Execscript (_Screen.cThorDispatcher, 'Result=', lnReturn)

Return



***************************************************************
#Define ccUpdateDelimiter      Chr(0)
#Define ccPropertyDelimiter    Chr(1)
#Define ccFieldDelimiter       Chr(2)

#Define ccCR Chr(13)
#Define ccLF Chr(10)

#Define EmptyVerDate			Date(2001,1,1)
#Define DaysForRecentReleases	60
***************************************************************

Procedure CheckForUpdates_Main (tlIsThor, llAutoRun)

	Local lcCol, lcRow, lnCurrentUpdateCount, lnResult, loUpdateList

	WritetoCFULog('Getting list of Updaters')
	loUpdateList		 = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_GetUpdateList', tlIsThor)
	lnCurrentUpdateCount = loUpdateList.Count

	If lnCurrentUpdateCount = 0
		Return 0
	Endif

	loUpdateList = GetAvailableVersionInfo (loUpdateList)
	Wait Clear
	If 'O' # Vartype (loUpdateList) && failure to get update list?
		WritetoCFULog('Aborting ... no update list found')
		Return - 1
	Endif

	If tlIsThor
		loUpdateList = SelectFromUpdateList (loUpdateList)
		lnResult	 = CheckIfReadyToGo (loUpdateList)
	Else
		loUpdateList = SelectUpdates (loUpdateList, llAutoRun)
		Use In (Select ('crsr_ThorUpdates'))
		If Type ('loUpdateList') = 'O' And loUpdateList.Count > 0
			lnResult = 1
		Else
			lnResult = 0
		Endif
	Endif

	If lnResult = 1
		loUpdateList = ClearAll (loUpdateList)
		InstallUpdates (loUpdateList)

		Wait Clear
		? 'Updating complete'

		Execscript (_Screen.cThorDispatcher, 'Thor_Proc_MessageBox', 'Updating completed', 0, 'Thor Updates...')
		Return 1
	Else
		WritetoCFULog('Exiting ... no updates selected')
	Endif

	Return lnResult

Endproc


Procedure GetAvailableVersionInfo (toUpdateList)

	Local loUpdateList As 'Collection'
	Local laMembers[1], lcName, lnI, lnJ, loNewVersionInfo, loUpdateInfo

	loUpdateList = Createobject ('Collection')

	For lnI = 1 To toUpdateList.Count
		loUpdateInfo = toUpdateList[lnI]
		If loUpdateInfo.NeverUpdate # 'Y'
			WritetoCFULog('Getting available version info for ' + loUpdateInfo.ApplicationName)
			loUpdateInfo = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_GetAvailableVersionInfo', loUpdateInfo)
		Endif
		If loUpdateInfo.ErrorCode = 0
			loUpdateList.Add (loUpdateInfo)
		Endif
	Endfor

	Wait Clear
	Return loUpdateList

Endproc


Procedure SelectFromUpdateList (toUpdateList)

	Local laMembers[1], lcName, lnI, lnJ, loNewVersionInfo, loUpdateInfo, loUpdateList

	loUpdateList = Createobject ('Collection')

	For lnI = 1 To toUpdateList.Count
		loUpdateInfo     = toUpdateList[lnI]
		If Not Empty (loUpdateInfo.SourceFileURL)		;
				And Not loUpdateInfo.AvailableVersion == loUpdateInfo.CurrentVersion
			loUpdateList.Add (loUpdateInfo)
		Endif
	Endfor
	Return loUpdateList

Endproc


Procedure CheckIfReadyToGo (toUpdateList)
	*   Returns:
	*       1 = Doit it!
	*       0 = Nothing to do
	*      -1 = Cancelled
	Local lcMessage, lcNames, lnI, lnResponse, loUpdateInfo

	lcNames = ''
	For lnI = 1 To toUpdateList.Count
		loUpdateInfo = toUpdateList[lnI]
		lcNames		 = lcNames + Chr(13) + Space(8) + loUpdateInfo.ApplicationName + ': ' + loUpdateInfo.AvailableVersion
	Endfor

	If toUpdateList.Count > 0
		lcMessage = 'Ready to install ' + Transform (toUpdateList.Count) + ' update(s):' + Chr(13) + lcNames
		lnResponse = Messagebox (lcMessage + Chr(13) + Chr(13) +								;
			  'CLEAR ALL and CLOSE ALL statements must be run in order to update.' + Chr(13) + Chr(13) + ;
			  'Do you wish to continue?', 4, 'Allow CLEAR ALL, etc.?')
		Return Iif (lnResponse = 6, 1, -1)
	Else
		Return 0
	Endif

Endproc


Procedure SelectUpdates (loUpdateList, llAutoRun)
	Local loResultList As 'Collection'
	Local lcFormFileName, llAnyFound, llResult, lnResult

	llAnyFound = CreateUpdatesCursor (loUpdateList)
	If llAutoRun And Not llAnyFound
		Return
	Endif

	lcFormFileName = Execscript (_Screen.cThorDispatcher, 'Full Path=CheckForUpdates.SCX')
	Do Form (lcFormFileName) To llResult

	If llResult
		Select crsr_ThorUpdates
		loResultList = Createobject ('Collection')
		Scan For UpdateNow
			loResultList.Add (loUpdateList[RecNo])
		Endscan
		Return loResultList
	Endif

Endproc



Procedure CreateUpdatesCursor (toUpdateList)

	Local laLines[1], llAnyFound, lnI, lnLineCount, loVersionInfo
	Create Cursor crsr_ThorUpdates (			;
		  Recno					N(4),			;
		  AppName  				C(40),			;
		  InstalledVersion		C(100),			;
		  InstalledVerNumber	C(100),			;
		  InstalledVerDate		C(20),			;
		  AvailableVersion		C(100),			;
		  AvailableVerNumber	C(100),			;
		  AvailableVerDate		C(20),			;
		  Status                C(40),			;
		  ProjectCreationDate   D,				;
		  UpdateNow           	L,				;
		  NeverUpdate			L,				;
		  NeverUpdateFile		C(250),			;
		  FromMyUpdates			L,				;
		  Notes					M,				;
		  Link                	M,				;
		  LinkPrompt			C(100),			;
		  IsNew		       		L,				;
		  IsCurrent        		L,				;
		  SortKey			    C(100),			;
		  VerDate               D				;
		  )

	llAnyFound = .F.
	
	For lnI = 1 To toUpdateList.Count
		With toUpdateList[lnI]

			Insert Into crsr_ThorUpdates														;
				(Recno, AppName, InstalledVersion,	AvailableVersion, Notes, FromMyUpdates, ProjectCreationDate)		;
				Values																			;
				(lnI, .ApplicationName, .CurrentVersion, .AvailableVersion, .Tag, .FromMyUpdates = 'Y', .ProjectCreationDate)

			loVersionInfo = GetVersionInfo (.CurrentVersion)
			Replace	InstalledVerNumber	With  Alltrim (loVersionInfo.VerNumber) + Iif (loVersionInfo.VerDate <= EmptyVerDate, '', ' (' + Dtoc (loVersionInfo.VerDate) + ')')
			*!* Replace	InstalledVerNumber	With  loVersionInfo.VerNumber		;
			*!* 		InstalledVerDate	With  loVersionInfo.VerDate

			*!* * Removed 10/3/2012 / JRN
			*!* If (Not .CurrentVersion == .AvailableVersion) And Not Empty (.AvailableVersion)
			If Not Empty (.AvailableVersion)
				loVersionInfo = GetVersionInfo (.AvailableVersion)
				Replace	AvailableVerNumber	With  Alltrim (loVersionInfo.VerNumber) + ' (' + Dtoc (loVersionInfo.VerDate) + ')'
				*!* Replace	AvailableVerNumber	With  loVersionInfo.VerNumber		;
				*!* 		AvailableVerDate	With  loVersionInfo.VerDate
			Endif

			Replace	NeverUpdate		 With  .NeverUpdate = 'Y'									;
					UpdateNow		 With  (Not NeverUpdate)									;
					  And (.AvailableVersion > EVL(.CurrentVersion, ' ')						;
					  	or GetLastWord(.AvailableVersion) > GetLastWord('20999999 ' + .CurrentVersion))		;
					  And (.UpdateNowIfNotInstalled = 'Yes' Or Not Empty (.CurrentVersion))		;
					IsNew			 With  .ProjectCreationDate >= Date() - DaysForRecentReleases					;
					IsCurrent		 With  .CurrentVersion == .AvailableVersion					;
					NeverUpdateFile	 With  .NeverUpdateFile										;
					Notes			 With  Transform(.Notes)									;
					Link			 With  Transform(.Link)										;
					LinkPrompt		 With  Transform(Evl (.LinkPrompt, .Link))					;
					VerDate          with  loVersionInfo.VerDate

			Replace	SortKey	 With														;
					  Icase(UpdateNow, 'A',												;
						NeverUpdate, 'Z',												;
						Empty(InstalledVerNumber) And IsNew, 'B',						;
						Empty(InstalledVerNumber) And VerDate > Date() - DaysForRecentReleases, 'D',		;
						IsCurrent, 'C',													;
						'X') +															;
					  Upper(AppName)	
					  
			Replace	Status	 With														;
					  Icase(Left(SortKey, 1) = 'A', 'Update available',					;
						Left(SortKey, 1) = 'B', 'New Project',							;
						Left(SortKey, 1) = 'C', 'Current',								;
						Left(SortKey, 1) = 'D', 'Recently Updated',						;
						'Not Installed') 															
						
			llAnyFound = llAnyFound Or UpdateNow

		Endwith
	Endfor && lnI = 1 to toUpdateList.Count

	Select  *										;
		From crsr_ThorUpdates						;
		Into Cursor crsr_ThorUpdates Readwrite		;
		Order By SortKey
	Goto Top

	Return llAnyFound

Procedure GetVersionInfo (lcVersion)
	Local loResult As 'Empty'
	Local laLines[1], lnLineCount
	loResult = Createobject ('Empty')
	AddProperty (loResult, 'VerNumber', '')
	AddProperty (loResult, 'VerDate', EmptyVerDate)

	If Empty (lcVersion)
		Return loResult
	Endif

	lnLineCount = Alines (laLines, lcVersion, 5, '-')
	Do Case
		Case lnLineCount = 1
			loResult.VerNumber = laLines[1]
		Case lnLineCount = 2
			loResult.VerNumber = laLines[1]
			*	loResult.VerDate   = laLines[2]
		Case lnLineCount = 3
			loResult.VerNumber = laLines[2]
			*	loResult.VerDate   = laLines[3]
		Otherwise
			loResult.VerNumber = laLines[2]
			loResult.VerDate   = laLines[3]
			Try
				loResult.VerDate = Date (Val (Substr (laLines[4], 1, 4)), Val (Substr (laLines[4], 5, 2)), Val (Substr (laLines[4], 7, 2)))
			Catch
			Endtry
	Endcase
	Return loResult
EndProc


Procedure GetLastWord(tcText)
	Return GetWordNum(tcText, GetWordCount(tcText))
EndProc 

**********************************************************************
**********************************************************************

Procedure ClearAll (toUpdateList)

	Local loUpdateList As 'Collection'
	Local laMembers[1], laProperties[1], laUpdates[1], lcName, lcProp, lcUpdateInfo, lnDelim, lnI, lnJ
	Local loUpdate, lxValue

*** DH 2021-12-28: added this line to preserve the folder Thor.app runs from
	loThor = execscript(_screen.cThorDispatcher, 'Thor Engine=')
	addproperty(_screen, 'cThorAppFolder', loThor.cAppFolder)

	* saving all custom properties into _Screen._ThorClearAllObject
	* so that they can be restored after the Clear All
	lcUpdateInfo = ''
	For lnI = 1 To toUpdateList.Count
		loUpdate = toUpdateList (lnI)
		Amembers (laMembers, loUpdate)
		For lnJ = 1 To Alen (laMembers)
			lcName  = laMembers[lnj]
			If Pemstatus (loUpdate, lcName, 4)
				lxValue = Getpem (loUpdate, lcName)
				If Type ('lxvalue') = 'C'
					lcUpdateInfo = lcUpdateInfo + lcName + ccFieldDelimiter + lxValue + ccPropertyDelimiter
				Endif
			Endif
		Endfor
		lcUpdateInfo = lcUpdateInfo + ccUpdateDelimiter
	Endfor && lnI = 1 to loUpdateList.Count

	_Screen.AddProperty ('_ThorClearAllObject', lcUpdateInfo)

	Release All

	Clear All
	Clear All
	Clear All
	Clear All
	Clear All
	Clear All

	Close All
	Clear Program

	Inkey (.25) && not sure if this is needed

	Alines (laUpdates, _Screen._ThorClearAllObject, 5, ccUpdateDelimiter)
	loUpdateList = Createobject ('Collection')
	For lnI = 1 To Alen (laUpdates)
		loUpdate = Createobject ('Empty')
		Alines (laProperties, laUpdates[lnI], 5, ccPropertyDelimiter)
		For lnJ = 1 To Alen (laProperties)
			lcProp	= laProperties[lnJ]
			lnDelim	= At (ccFieldDelimiter, lcProp)
			AddProperty (loUpdate, Left (lcProp, lnDelim - 1), Substr (lcProp, lnDelim + 1))
		Endfor
		loUpdateList.Add (loUpdate)
	Endfor && lnI = 1 to Alen(laUpdates)

*** DH 2021-12-28: delete Thor.App if it needs to be updated
	if lower(loUpdate.AppName) = 'thor.app'
		erase (addbs(_screen.cThorAppFolder) + 'Thor.app')
	endif

	Return loUpdateList
Endproc


Procedure InstallUpdates (toUpdateList)
	Local lcAPPFolder, lcAPPName, lcApplicationName, lcDestFolder, lcDestZip, lcDownloadedZip
	Local lcDownloadsFolder, lcExecPhrase, lcInstallationFolder, lcToolFolder, lcUpdatePhrase
	Local lcVersionFile, lnI, lnReturn, loException, loUpdate, ltFileTimeStamp

	WritetoCFULog('Downloading and installing selected updates', .T.)
	lcToolFolder	  = Addbs (Execscript (_Screen.cThorDispatcher, 'Tool Folder='))
	lcDownloadsFolder = Addbs (SyS(2023)) + 'Thor Downloads\'
	CreateFolder (lcDownloadsFolder)

	For lnI = 1 To toUpdateList.Count
		loUpdate     = toUpdateList (lnI)

		If loUpdate.Component = 'Yes'
			lcAPPFolder		  = Addbs (lcToolFolder + 'Components')
		Else
			lcAPPFolder		  = Addbs (lcToolFolder + 'Apps')
		Endif

		lcApplicationName = Chrtran (loUpdate.ApplicationName, ' ' + GetInvalidFileNameChars(), '')
		lcDestFolder	  = Addbs (lcDownloadsFolder + lcApplicationName)
		lcDestZip		  = lcDestFolder + Chrtran (loUpdate.AvailableVersion, GetInvalidFileNameChars(), '') + '.Zip'
		CreateFolder (lcDestFolder)

		lcInstallationFolder = loUpdate.InstallationFolder
		If Empty (lcInstallationFolder)
			lcInstallationFolder = lcAPPFolder + lcApplicationName
		Endif
		CreateFolder (lcInstallationFolder)

		ltFileTimeStamp = .F.
		If (Not Empty (loUpdate.AppName))							;
				And (Not Empty (loUpdate.CurrentVersion))			;
				And Not loUpdate.CurrentVersion == loUpdate.AvailableVersion
			lcAPPName = Addbs (lcInstallationFolder) + loUpdate.AppName
			If File (lcAPPName)
				ltFileTimeStamp = Fdate (lcAPPName, 1)
			Endif
		Endif

		_Screen.AddProperty ('cThorLastZipFile', '')

		WritetoCFULog('Download ' + loUpdate.ApplicationName)
		If loUpdate.Component = 'Yes'
			Execscript (_Screen.cThorDispatcher, 'Thor_Proc_BeforeComponentInstall', loUpdate.ApplicationName, lcInstallationFolder)
		Endif

		If Not Empty (loUpdate.SourceFileURL)
			WritetoCFULog('Attempting download of ' + loUpdate.SourceFileURL)
			lnReturn = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_DownloadAndExtractToPath'		;
				  , loUpdate.SourceFileURL, lcInstallationFolder, 'Y' $ Upper (loUpdate.ShowErrorMessage), loUpdate.ApplicationName)
			If lnReturn < 0 And Pemstatus(loUpdate, 'AltSourceFileURL', 5) And Not Empty(loUpdate.AltSourceFileURL)
				WritetoCFULog('Download failed; attempting alternate download of ' + loUpdate.AltSourceFileURL)
				lnReturn = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_DownloadAndExtractToPath'	;
					  , loUpdate.AltSourceFileURL, lcInstallationFolder, 'Y' $ Upper (loUpdate.ShowErrorMessage), loUpdate.ApplicationName)
			Endif
		Else
			lnReturn = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_ExtractToPath'					;
				  , loUpdate.LocalSourceZip, 'Thor_ToolInstaller_' + Evl (loUpdate.ApplicationName, 'X') + Sys(2015) ;
				  , loUpdate.ApplicationName, lcInstallationFolder, 'Y' $ Upper (loUpdate.ShowErrorMessage))
		Endif
		
		WritetoCFULog('Copy Zip ' + loUpdate.ApplicationName)
		* copy zip to our new Downloads folder
		lcDownloadedZip = _Screen.cThorLastZipFile
		Try
			Delete File (lcDestZip)
			Copy File (lcDownloadedZip) To (lcDestZip)
		Catch
		Endtry

		If Not Empty (ltFileTimeStamp)							;
				And ltFileTimeStamp = Fdate (lcAPPName, 1)		;
				And File (Addbs (lcInstallationFolder) + loUpdate.VersionLocalFilename)
			lnReturn = -999 && failure
		Endif

		If lnReturn > 0
			WritetoCFULog('Install ' + loUpdate.ApplicationName)
			If loUpdate.Component = 'Yes'
				Execscript (_Screen.cThorDispatcher, 'Thor_Proc_AfterComponentInstall', loUpdate.ApplicationName, lcInstallationFolder, lcDownloadedZip)
			Endif

			Try
				Delete File (lcDownloadedZip)
			Catch
			Endtry

			lcUpdatePhrase = loUpdate.RegisterWithThor
			lcUpdatePhrase = Strtran (lcUpdatePhrase, '##InstallFolder##', Addbs (lcInstallationFolder))
			lcUpdatePhrase = Strtran (lcUpdatePhrase, '##LocalVersionFile##', loUpdate.LocalVersionFile)
			lcUpdatePhrase = Strtran (lcUpdatePhrase, '##Version##', Alltrim (Getwordnum (loUpdate.AvailableVersion, 2, '-')))
			lcUpdatePhrase = Strtran (lcUpdatePhrase, '##FullVersionText##', loUpdate.AvailableVersion)
			lcUpdatePhrase = Strtran (lcUpdatePhrase, '##Link##', loUpdate.Link)

			*!* Try
			lcExecPhrase = CreateDefines (loUpdate) + lcUpdatePhrase
			Execscript (lcExecPhrase)
			*!* Catch To loException
			*!*     ShowErrorMsg (loException)
			*!* Endtry

			lcVersionFile = loUpdate.LocalVersionFile
			Erase (lcVersionFile)
			Strtofile (loUpdate.AvailableVersion, lcVersionFile)

			? loUpdate.AvailableVersion + ' ... Updated'
		Else
			?
			? '********** Failed: ' + loUpdate.AvailableVersion
			? '********** See ' + lcDestZip
			? 
		Endif
	Endfor && lnI = 1 to loUpdateList.Count
Endproc


Procedure ShowErrorMsg
	Lparameters loException

	Messagebox ('Error: ' + Transform (loException.ErrorNo)     + Chr(13) + Chr(13) +		;
		  'Message: ' + loException.Message                     + Chr(13) + Chr(10) +		;
		  'Procedure: ' + loException.Procedure                 + Chr(13) + Chr(10) +		;
		  'Line: ' + Transform (loException.Lineno)             + Chr(13) + Chr(10) +		;
		  'Code: ' + loException.LineContents												;
		  , 0        + 48, 'Error')
Endproc


Procedure CreateDefines (loUpdate)
	Local laMembers[1], lcDefines, lcName, lnJ, lxValue
	lcDefines = ''
	Amembers (laMembers, loUpdate)
	For lnJ = 1 To Alen (laMembers)
		lcName	= laMembers[lnj]
		lxValue	= Getpem (loUpdate, lcName)
		If Type ('lxvalue') = 'C' And Not Chr(13) $ lxValue
			lcDefines = lcDefines + '#Define cc' + lcName + ' [' + lxValue + ']' + Chr(13)
		Endif
	Endfor
	Return lcDefines
Endproc


Procedure CreateFolder (lcFolder)
	If Not Directory (lcFolder)
		Mkdir (lcFolder)
	Endif
Endproc

* Following from Sergey
Function GetInvalidFileNameChars()
	Local lcInvalidFileNameChars, lnAsc
	lcInvalidFileNameChars = [*/:<>?|\] + Chr(34)
	For lnAsc = 0 To 31
		lcInvalidFileNameChars = lcInvalidFileNameChars + Chr (lnAsc)
	Endfor
	Return lcInvalidFileNameChars
Endfunc


Procedure WritetoCFULog (tcText, tlDivider)
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', tcText, tlDivider, 1)
EndProc 
	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Proc_DownloadFileFromURL (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
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


	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Proc_Expand_Bitly_Url (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
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

  
	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Proc_ExtractFiles (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
	Lparameters tcSource, tcDestinationPath, tlExtractFromFirstFolder, tlShowCopyErrorDialog
	
	&& Parameter tcSource is a fully qualifed path or path+filename+ext (i.e. "C:\TEMP\downloads" or "C:\TEMP\downloads\SomeFile.zip")

	* --- Credit: Original code sample came from here: http://www.tek-tips.com/faqs.cfm?fid=5113

	#DEFINE ERROR_SOURCE_FILE_NOT_FOUND 	-1
	#DEFINE ERROR_CREATING_DESTINATION_PATH -2
	#DEFINE ERROR_OPENING_SOURCE 			-3
	#DEFINE ERROR_EXTRACTING_FILES 			-4

	Local loShellApp as "shell.application"
	Local lnError, loFiles
	Local lnAnswerYesToAllOverwriteFilePrompts, lnCreateDestinationFolderIfNotPresent, lnShowErrorDialog, lnOptions
	
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Copying files to install folder...')
	
	lnError = 0
	
	*-- Create the destination folder, in case it is not present [Universal Thread Message ID: 1450231]
	If Not Directory(tcDestinationPath)
		Try
			Declare Integer SHCreateDirectory In shell32		;
				Integer hWindow, String pszPath
			SHCreateDirectory(_vfp.HWnd, Strconv(tcDestinationPath + Chr(0), 5))
		Catch
			lnError =  ERROR_CREATING_DESTINATION_PATH
		Finally
		Endtry
	Endif && not Directory(tcDestinationPath)
		
	If lnError < 0
		lcErrorMessage = 'Error creating or accessing install folder [' + tcDestinationPath  + ']'
		MessageBox(lcErrorMessage, 16, 'Error!')
		Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', lcErrorMessage)
		Execscript (_Screen.cThorDispatcher, 'Result=', lnError)
		Return lnError
	EndIf
	
	*-- Open the zip file or path  -----------------------------------------------
	Try
		loShellApp = Createobject("shell.application")

		loFiles = loShellApp.NameSpace(tcSource).Items

		If tlExtractFromFirstFolder
			loFiles = loShellApp.NameSpace(loFiles.Item(0)).Items && Make entry point the first folder within zip file or source path
		EndIf
	Catch
		lnError = ERROR_OPENING_SOURCE
	Finally
	Endtry
	
	If lnError < 0
		MessageBox('Error opening ZIP file.', 16, 'Error!')
		Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Error opening ZIP file or path [' + tcSource + '] to copy from.')
		Execscript (_Screen.cThorDispatcher, 'Result=', lnError)
		Return lnError
	Endif	

	Local lcLibrary
	lcLibrary = Set("Library")
	Set Library to 
	
	*-- Extract the files to the destination folder
	Try
		For Each oItem In loFiles
			lnAnswerYesToAllOverwriteFilePrompts = 16
			lnCreateDestinationFolderIfNotPresent = 512
			lnShowErrorDialog = iif(tlShowCopyErrorDialog, 1024, 0)
			lnOptions = lnAnswerYesToAllOverwriteFilePrompts + lnCreateDestinationFolderIfNotPresent + lnShowErrorDialog
			loShellApp.NameSpace(tcDestinationPath).CopyHere(oItem, lnOptions) 
		Endfor		
	Catch
		lnError = ERROR_EXTRACTING_FILES
	Finally
	EndTry
	
	Set Library to &lcLibrary
		
	If lnError < 0
		Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Error extracting files from [' + tcSource + ']')
		MessageBox('Error extracting files.', 16, 'Error!')
		Execscript (_Screen.cThorDispatcher, 'Result=', lnError)
		Return lnError
	Endif

	lnReturn = 1
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Copied files from [' + tcSource + '] to [' + tcDestinationPath + ']')
	Execscript (_Screen.cThorDispatcher, 'Result=', lnReturn)
	Return lnReturn

	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Proc_ExtractFilesFromZip (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
Lparameters tcSource, tcDestinationPath, tlExtractFromFirstFolder

* Parameter tcSource is a fully qualifed path or path+filename+ext (i.e. "C:\TEMP\downloads" or "C:\TEMP\downloads\SomeFile.zip")

Local llReturn, lnResult

*** DH 2022-03-04: changed to the Shell.Application instead of VFPCompression.fll because the latter has a bug that prevents some newly downloaded ZIPs from being completely unzipped
***llReturn = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_SetLibrary', 'VFPCompression.fll')

Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Extracting from [' + tcSource + '] to [' + tcDestinationPath + ']')

***If llReturn
***	If UnzipOpen (tcSource)
***		UnzipTo (tcDestinationPath)
***		UnzipClose()
***	Else
***		lnResult = -1
***	Endif
***Else
***	lnReturn = -2
***	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Error loading VFP Compression library [VFPCompression.fll]')
***EndIf

try
	loShell = createobject('Shell.Application')
	loFiles = loShell.NameSpace(tcSource).Items
	loShell.NameSpace(tcDestinationPath).CopyHere(loFiles)
	lnResult = 1
catch to loException
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', 'Error extracting: ' + loException.Message)
	lnResult = -1
endtry

Execscript (_Screen.cThorDispatcher, 'Result=', lnResult)
Return lnResult

	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Proc_ExtractToPath (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
#Define ERROR_DOWNLOADING_FILE	-1
#Define ERROR_EXTRACTING_FILE	-2
#Define ERROR_INSTALLING_FILES	-3

Lparameters lcDownloadDestinationFile, lcTempName, tcAppName, tcInstallPath, tlShowCopyErrorDialog

*-- Extract to temp folder -------------------------------------------------------------------
Local loFSO As 'Scripting.FileSystemObject'
Local lcTempFolder, lnCopyFilesToInstallFolder, lnExtractFilesToTempFolder, lnReturn

lcTempFolder = Addbs (Sys(2023)) + lcTempName
loFSO		 = Createobject ('Scripting.FileSystemObject')
loFSO.CreateFolder (lcTempFolder) && Create the temp folder

ExecScript(_Screen.cThorDispatcher, "Thor_Proc_UpdateWaitWindow", 'Extracting.... Please wait.')
lnExtractFilesToTempFolder = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_ExtractFilesFromZip', lcDownloadDestinationFile, lcTempFolder)

*--- Copy files from temp folder to target install folder ----------
If lnExtractFilesToTempFolder > 0
	ExecScript(_Screen.cThorDispatcher, "Thor_Proc_UpdateWaitWindow",  'Installing.... Please wait.')
	lnCopyFilesToInstallFolder = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_ExtractFiles', lcTempFolder, tcInstallPath, .F., tlShowCopyErrorDialog)
Else
	Execscript (_Screen.cThorDispatcher, 'Result=', ERROR_EXTRACTING_FILE)
Endif

If lnExtractFilesToTempFolder > 0 And lnCopyFilesToInstallFolder > 0
	lnReturn =  1
	ExecScript(_Screen.cThorDispatcher, "Thor_Proc_UpdateWaitWindow", 'Update complete!')
Else
	Messagebox ('Error updating ' + Evl (tcAppName, '') + '.', 0, 'Failure!')
	lnReturn = ERROR_INSTALLING_FILES
Endif

Execscript (_Screen.cThorDispatcher, 'Result=', lnReturn)
Return lnReturn

	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Proc_GetAvailableVersionInfo (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
#Define CR 			Chr[13]
#Define STARS 		Replicate('=', 40)
#Define MaxTries 	4

Lparameters toUpdateInfo

*-- 2011-07 M. Slay - Revised to set properties on passed toUpdateInfo
Local lcLocalVersionFile, lcVersionFileCode, lcVersionFileUrl, llReturn, lnAttempt, laLines[1]

lcLocalVersionFile = Addbs (Sys(2023)) + Justfname (toUpdateInfo.VersionLocalFilename) && Temp folder
lcVersionFileUrl   = toUpdateInfo.VersionFileUrl

If Not Empty (lcVersionFileUrl)

	For lnAttempt = 1 To MaxTries
		toUpdateInfo.ErrorCode = 0
		llReturn			   = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_DownloadFileFromURL', lcVersionFileUrl, lcLocalVersionFile)

		If llReturn = .T.
			lcVersionFileCode = Filetostr (lcLocalVersionFile)

			*-- The downloaded file above contains VFP code which will set properties on the passed object:
			Try
				WritetoCFULog('Executing code from downloaded version file...')
				toUpdateInfo = Execscript (lcVersionFileCode, toUpdateInfo)
			Catch
				WritetoCFULog('ERROR while executing code from downloaded version file!')
				toUpdateInfo.ErrorCode = -1
			Endtry

			Do Case
				Case toUpdateInfo.ErrorCode = 0
					Exit
				Case lnAttempt = MaxTries
					If Alines (laLines, lcVersionFileCode) > 4 && ignore messages about earlier versions which did not pass objects
						ErrorMessage ('Invalid format in version file for ' + toUpdateInfo.AppName + CR	+ ;
							  STARS + CR + 'URL: ' + lcVersionFileUrl + CR +					;
							  STARS + CR + lcVersionFileCode + CR +								;
							  STARS, toUpdateInfo.AppName)
					Endif
				Otherwise
			Endcase

		Else
			toUpdateInfo.ErrorCode = -5
			WritetoCFULog('Error getting available version information from server.')
			If lnAttempt = MaxTries
				ErrorMessage ('Error getting available version information from server.' + toUpdateInfo.AppName + CR	+ ;
					  STARS + CR + 'URL: ' + lcVersionFileUrl + CR +							;
					  STARS, toUpdateInfo.AppName)
			Endif
		EndIf
		
	Endfor

Endif

If Empty(toUpdateInfo.AvailableVersion)
	toUpdateInfo.AvailableVersion = toUpdateInfo.ApplicationName + ' - ' +		;
		Transform(toUpdateInfo.VersionNumber) + ' - ' +							;
		Transform(toUpdateInfo.VersionNumber) + ' - ' +							;
		Dtoc(Evl(toUpdateInfo.VersionDate, Date(2001,1,1)), 1)
Endif
		
Return Execscript (_Screen.cThorDispatcher, 'Result=', toUpdateInfo)


Procedure ErrorMessage (tcMessage, tcAppName)
	#Define CR Chr[13]
	Local lcMessage
	WritetoCFULog('MessageBox: ' + tcMessage)
	lcMessage = tcMessage + CR + CR + 'Cancelling ... ' + CR + CR + 'This error may self-correct if "Check For Updates" is run again.'
	Messagebox (lcMessage, 0, 'Error: ' + tcAppName)

Endproc


Procedure WritetoCFULog (tcText, tlDivider)
	Execscript (_Screen.cThorDispatcher, 'Thor_Proc_WriteToCFULog', tcText, tlDivider)
EndProc 

	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Proc_GetUpdateList (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
*-- 2011-11-07 M. Slay - Added new properties to UpdateInfo object so it can be passed to all
*-- the various calls to have the properties set.

Lparameters tlIsThor

Local loUpdateList As 'Collection'
Local laFiles[1], lcCode, lcFile, lcFolder, lcLocalVersion, lcLocalVersionFile, lcNeverUpdateFolder
Local lcRemovedFolder, lcToolFolder, lcUpdateFolder, llSuccess, lnFileCount, lnI, loResult, loTool

lcToolFolder		= Execscript (_Screen.cThorDispatcher, 'Tool Folder=')
lcUpdateFolder		= Addbs (lcToolFolder) + 'Updates\'
lcNeverUpdateFolder	= lcUpdateFolder + 'Never Update\'
lcRemovedFolder		= lcUpdateFolder + 'Removed\'

loUpdateList   = Createobject ('Collection')

AddUpdateFolder (loUpdateList, tlIsThor, lcUpdateFolder, lcNeverUpdateFolder, lcRemovedFolder, lcToolFolder, 'No')

AddUpdateFolder (loUpdateList, tlIsThor, lcUpdateFolder + 'My Updates\', lcNeverUpdateFolder, lcRemovedFolder, lcToolFolder, 'Yes')

Execscript (_Screen.cThorDispatcher, 'Result=', loUpdateList)
Return loUpdateList


Procedure AddUpdateFolder (loUpdateList, tlIsThor, lcUpdateFolder, lcNeverUpdateFolder, lcRemovedFolder, lcToolFolder, tcFromMyUpdates)
	Local laFiles[1], laLocalVersionInfo[1], lcCode, lcFile, lcFolder, lcLocalVersion
	Local lcLocalVersionFile, lcVersionFileUrl, llSuccess, lnFileCount, lnI, loResult, loTool
	lnFileCount	 = Adir (laFiles, lcUpdateFolder + 'Thor_Update_*.PRG')

	For lnI = 1 To lnFileCount
		lcFile	 = lcUpdateFolder + laFiles[lnI, 1]

		If File (lcRemovedFolder + laFiles[lnI, 1])
			Loop
		Endif

		loResult	  = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_GetUpdaterObject2')
		loResult.File = lcFile
		loResult.FromMyUpdates = tcFromMyUpdates

		lcCode	 = Filetostr (lcFile)
		Try
			loResult  = Execscript (lcCode, loResult)
			llSuccess = .T.
		Catch
			llSuccess = .F.
		Endtry

		If llSuccess
			If 'L' # Vartype(tlIsThor) Or tlIsThor = (Upper (loResult.ApplicationName) == 'THOR')
				loTool = Execscript (_Screen.cThorDispatcher, 'ToolInfo=', loResult.ToolName)

				If Isnull (loTool)
					If loResult.Component = 'Yes'
						lcFolder		  = Addbs(Addbs (lcToolFolder) + 'Components') + loResult.ApplicationName
					Else
						lcFolder		  = Addbs(Addbs (lcToolFolder) + 'Apps') + loResult.ApplicationName
					Endif
					lcLocalVersionFile = Addbs (lcFolder) + loResult.VersionLocalFilename
					If File (lcLocalVersionFile)
						lcLocalVersion	   = Filetostr (lcLocalVersionFile)
						loResult.AlreadyInstalled = 'Yes'
					Else
						lcLocalVersion	   = ''
						loResult.AlreadyInstalled = 'No'
					Endif
				Else
					lcFolder		   = loTool.FolderName
					lcLocalVersionFile = Addbs (lcFolder) + loResult.VersionLocalFilename
					If File (lcLocalVersionFile)
						lcLocalVersion	   = Filetostr (lcLocalVersionFile)
						loResult.AlreadyInstalled = 'Yes'
					Else
						loResult.AlreadyInstalled = 'No'
					Endif
				Endif

				loResult.InstallationFolder	= lcFolder
				loResult.LocalVersionFile	= lcLocalVersionFile
				loResult.NeverUpdateFile	= lcNeverUpdateFolder + laFiles[lnI, 1]

				lcVersionFileUrl   = loResult.VersionFileURL

				If Not Empty (loResult.InstallationFolder)

					If Empty(loResult.AvailableVersion);
							and Not Empty(loResult.ApplicationName);
							and Not Empty(loResult.VersionNumber);
							and Not Empty(loResult.VersionDate)
						loResult.AvailableVersion = loResult.ApplicationName + ' - ' +		;
							Transform(loResult.VersionNumber) + ' - ' +							;
							Transform(loResult.VersionNumber) + ' - ' +							;
							Dtoc(Evl(loResult.VersionDate, Date(2001,1,1)), 1)
					Endif


					If (Empty (lcVersionFileUrl) And Empty(loResult.AvailableVersion)) Or Empty (lcLocalVersionFile)
						loResult.ErrorMessage = 'One of the required version files properties is empty.'
						loResult.ErrorCode	  = -1
					Endif

					*-- Read the local version string
					If File (lcLocalVersionFile)
						Alines (laLocalVersionInfo, Filetostr (lcLocalVersionFile))
						If Alen (laLocalVersionInfo) >= 2
							loResult.CurrentVersion =  laLocalVersionInfo[2]
						Else
							loResult.CurrentVersion =  laLocalVersionInfo[1]
						Endif
					Endif
				Endif

				If File (loResult.NeverUpdateFile)
					loResult.NeverUpdate = 'Yes'
				Endif

				If loResult.ErrorCode >= 0
					loUpdateList.Add (loResult)
				Endif
			Endif
		Endif
	Endfor

Endproc

	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Proc_GetUpdaterObject (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
Local loUpdaterObject As 'clsUpdaterObject'
loUpdaterObject = Createobject ('clsUpdaterObject')
Execscript (_Screen.cThorDispatcher, 'Result=', loUpdaterObject)
Return

Define Class clsUpdaterObject As Custom

	* Properties to be defined in Updater PRGs
	APPName				 = '' && Name of the APP file
	ApplicationName		 = '' && Name of the application
	ToolName			 = '' && Name of the tool used to determine where the APP is stored
	Component            = 'No'
	FindInstalledVersion = 'No'
	VersionFileURL		 = '' && URL of the version file in the cloud
	VersionLocalFilename = '' && Name of the local version file
	RegisterWithThor	 = '' && To be executed to register this APP with Thor
	ShowErrorMessage	 = 'Yes'
	UnzipAfterDownload	 = 'Yes'
	SourceZipURL		 = '' && URL for the zip of source files
	LocalSourceZip       = ''
	NeverUpdateFile		 = ''
	UpdateNowIfNotInstalled = 'No'	
	ProjectCreationDate  = Date(2001,1,1)

	* Properties used along the way by the updater process
	File			   = ''
	InstallationFolder = ''
	LocalVersionFile   = ''

	CurrentVersion	 = ''
	ErrorMessage	 = ''
	ErrorCode		 = 0
	NeverUpdate		 = 'No'
	AlreadyInstalled = 'No'
	FromMyUpdates    = 'Yes'

	* Properties set by the cloud version file
	AvailableVersion	   = ''
	VersionNumber		   = ''
	VersionDate			   = {//}
	AvailableVersionDate   = ''
	AvailableVersionNumber = ''
	SourceFileURL		   = ''
	Notes				   = ''
	Link				   = ''
	LinkPrompt			   = ''

Enddefine


	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Proc_GetUpdaterObject2 (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
Local loUpdaterObject As 'clsUpdaterObject'
loUpdaterObject = Createobject ('clsUpdaterObject')
Execscript (_Screen.cThorDispatcher, 'Result=', loUpdaterObject)
Return

Define Class clsUpdaterObject As Custom

	* Properties to be defined in Updater PRGs
	APPName				 = '' && Name of the APP file
	ApplicationName		 = '' && Name of the application
	ToolName			 = '' && Name of the tool used to determine where the APP is stored
	Component            = 'No'
	FindInstalledVersion = 'No'
	VersionFileURL		 = '' && URL of the version file in the cloud
	VersionLocalFilename = '' && Name of the local version file
	RegisterWithThor	 = '' && To be executed to register this APP with Thor
	ShowErrorMessage	 = 'Yes'
	UnzipAfterDownload	 = 'Yes'
	SourceZipURL		 = '' && URL for the zip of source files
	LocalSourceZip       = ''
	NeverUpdateFile		 = ''
	UpdateNowIfNotInstalled = 'No'	
	ProjectCreationDate  = Date(2001,1,1)

	* Properties used along the way by the updater process
	File			   = ''
	InstallationFolder = ''
	LocalVersionFile   = ''

	CurrentVersion	 = ''
	ErrorMessage	 = ''
	ErrorCode		 = 0
	NeverUpdate		 = 'No'
	AlreadyInstalled = 'No'
	FromMyUpdates    = 'Yes'

	* Properties set by the cloud version file
	AvailableVersion	   = ''
	VersionNumber		   = ''
	VersionDate			   = {//}
	AvailableVersionDate   = ''
	AvailableVersionNumber = ''
	SourceFileURL		   = ''
	Notes				   = ''
	Link				   = ''
	LinkPrompt			   = ''

Enddefine


	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Proc_MessageBox (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
#Define cnMessageBoxTimeout    3000

Lparameters tcMessageBoxText, tnDialogBoxType, tcTitleBarText
Local lnMessageBoxTimeout, lnResult

If Pemstatus(_Screen, 'nThorCFUMessageBoxTimeout', 5)
	lnMessageBoxTimeout = _Screen.nThorCFUMessageBoxTimeout
Else
	lnMessageBoxTimeout = cnMessageBoxTimeout
Endif

lnResult = Messagebox (tcMessageBoxText, tnDialogBoxType, tcTitleBarText, lnMessageBoxTimeout)

Execscript (_Screen.cThorDispatcher, 'Result=', lnResult)
Return lnResult

	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Proc_SetLibrary (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
Lparameters tcLibrary

Local lcFileUrl, lcLocalFilename, lcToolFolder, lcUrlFolder, llReturn

lcToolFolder  = Execscript (_Screen.cThorDispatcher, 'Tool Folder=')
lcLocalFilename = lcToolFolder + tcLibrary 
lcUrlFolder = 'http://foxpro.mattslay.com/Common/'
lcFileUrl = lcUrlFolder + tcLibrary  
llReturn = .t.

*-- Download the file if it is not present...
If !File(lcLocalFilename)
	llReturn = Execscript (_Screen.cThorDispatcher, 'Thor_Proc_DownloadFileFromURL', lcFileUrl, lcLocalFilename)
EndIf

If llReturn and File(lcLocalFilename)
	Set Library To (lcLocalFilename) Additive
Else
	llReturn = .f.
Endif

Execscript (_Screen.cThorDispatcher, 'Result=', llReturn)
Return llReturn
 
	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Proc_UpdateWaitWindow (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
Lparameters lcText, lxParam2, lxParam3, lxParam4

Wait Window (lcText) at 20, 30 Nowait 
	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc

Procedure GetThor_Proc_WriteToCFULog (tcFolder)

	Local lcCode, lcVersion
	lcVersion = ccTHORVERSION
	Text To lcCode Noshow Textmerge
#Define CR Chr[13]
#Define LF Chr(10)
#Define cnIndent Space(30)

Lparameters lcText, llDivider, lnOffset

Local laStax[1], lcLine, lcLogtext, lcPRG, lcPrefix, lcProcedure, lcSuffix, lnLine, lnRow, lnStax
lnStax = Astackinfo (laStax)

If Evl (lcText, '' ) == 'Begin CFU' Or Not Pemstatus (_Screen, 'cThorLogForCFU', 5)
	_Screen.AddProperty ('cThorLogForCFU', Addbs (Sys(2023)) + 'Thor_CFU_Log_' + Ttoc(Datetime(),1) + '.txt')
Endif

Do Case
	Case llDivider
		lcLine = '*===== ' + lcText + '  '
		Strtofile (CR + LF + Padr (lcLine, 150, '=') + CR + LF, _Screen.cThorLogForCFU, 1)

	Case lnStax > (3 + Evl(lnOffset, 0))
		lnRow = lnStax - (3 + Evl(lnOffset, 0))

		*!* * Removed 6/5/2012 / JRN
		*!* lcProcedure	= laStax[lnRow, 3]
		*!* lcPRG		= laStax[lnRow, 4]
		*!* lnLine		= laStax[lnRow, 5]
		*!* lcPrefix	= Time()
		*!* lcSuffix    = Iif (										;
		*!* 	  lcProcedure # Juststem (Justfname (lcPRG)),		;
		*!* 	  ' ' + lcProcedure + ' in',						;
		*!* 	  '')												;
		*!* 	+ ' ' + Justfname (lcPRG)							;
		*!* 	+ ', line ' + Transform (lnLine)

		lcPRG		= laStax[lnRow, 4]
		lnLine		= laStax[lnRow, 5]
		lcPrefix	= Time()
		lcSuffix    = ' ' + Justfname (lcPRG) + ', line ' + Transform (lnLine)

		If Empty (lcText)
			lcLogtext = lcPrefix + '  ' + lcSuffix
		Else
			lcLogtext = lcPrefix + '  ' + lcText + CR + LF + cnIndent + lcSuffix
		Endif

		Strtofile (lcLogtext + CR + LF, _Screen.cThorLogForCFU, 1)
Endcase

	EndText
	Return Strtran(lcCode, '*##*', '')

EndProc



