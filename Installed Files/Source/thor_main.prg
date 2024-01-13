#include Thor_UI.H

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
		EndIf
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
Return

* ================================================================================
* ================================================================================

#Define ____Border1 ''

Function ThorInstalled (lcFolder)

	Local lcFileName
	lcFileName = lcFolder + 'Thor\' + ccThorVERSIONFILE

	If Not File (lcFileName)
		Return .F.
	Endif

	Return Filetostr (lcFileName) == ccTHORInternalVERSION

Endfunc


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

	_Screen.AddProperty('cThorFolder', lcFolder + 'Thor\')

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
	EndProc
	
	Procedure Destroy
		Close Tables
	EndProc 

Enddefine


* ================================================================================
* ================================================================================

#Define _____Border2 ''


Procedure ThorInstall (lcFolder)

	CreateDirectoryStructure (lcFolder)

	CreateThorTables (lcFolder + 'Thor\Tables\')

	CreateRunThorPRG (lcFolder)

	CreateVersionNumber (lcFolder + 'Thor\')

	Close Tables 

	*!* ******** JRN Removed 2024-01-08 ********
	*!* If PemStatus(_screen, 'cThorDispatcher', 5)
	*!* 	ExecScript(_screen.cThorDispatcher, 'Thor_Proc_Messagebox', ccTHORVERSION + ' installed', 0, 'Installation complete')
	*!* Else 
		MessageBox(ccTHORVERSION + ' installed', 0, 'Installation complete', 3000)
	*!* ******** JRN Removed 2024-01-08 ********
	*!* EndIf 

Endproc



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

	*!* ******** JRN Removed 2023-11-28 ********
	*!* If Not File (tcFolder + 'Thor_LogFile.DBF')
	*!* 	Create Table (tcFolder + 'Thor_LogFile') Free		;
	*!* 		(PRGName C(60), Count I, FirstTime T, LastTime T)
	*!* 	Index On PRGName Tag PRGName
	*!* Endif Not File (tcFolder + 'LogFile.DBF')

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
		Use (tcFolder + 'MenuTools.DBF') Exclusive 
	Endif Not File (tcFolder + 'MenuTools.DBF')
	
	RemoveOldThorMainMenuItems(tcFolder, loMenuDefs)
	AddThorMainMenuItems(tcFolder, loMenuDefs)
	
	Select MenuTools
	Pack
	
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
	AddThorMainMenuItem (8, ccINTERNALEDITPRG, 110, '\<Configure', 'Assign hot keys, create menus and sub-menus, etc.')
	AddThorMainMenuItem (8, ccCHECKFORUPDATES, 120, 'Check for \<Updates', 'Check for and install any outstanding updates')
	AddThorMainMenuItem (8, 'Thor_Tool_ToolManager', 130, 'Tool \<Manager', 'Tool manager and editor')
	AddThorMainMenuItem (8, 'Thor_Tool_ThorInternalRunTool', 140, '\<Launcher', 'Find and run tools, explore descriptions, etc')
	AddThorMainMenuItem (8, 'Thor_Tool_AllHotKeys', 150, '\<Browse Hot Keys', 'Browse all assigned hot keys')
	AddThorMainMenuItem (8, 'Thor_Tool_ThorChangeLog', 160, "What's New (Thor Change Log)", 'Change Log for Thor')

	AddThorMainMenuSeparator (8, 200, 'SEPARATOR1')

	AddThorMainMenuItem (8, ccThorNews, 	205, 	'\<News', 'All the latest and greatest news about Thor and Thor tools.')
	AddThorMainMenuItem (8, ccINTERNALHELPPRG, 220, '\<VFPX Home Page', 'Help for Thor')
	AddThorMainMenuItem (8, 'Thor-Forums', 	224, 	'\<Issues', '')
	AddThorMainMenuItem (8, 'Thor-Videos', 	230,	'\<Videos', '')
	AddThorMainMenuItem (8, ccOPENFOLDERS, 240, '\<Folders', 'Opens various Thor folders')

	*!* ** { JRN -- 6/26/2023 7:50:58 AM - Begin

	*!* lnMoreID = loMenuDefs.More
	*!* AddThorMainMenuItem (lnMoreID, ccMANAGEPLUGINS, 210, 'Manage \<Plug-Ins', 'Manages plug-in PRGS used by some tools')
	*!* AddThorMainMenuItem (lnMoreID, ccOPENFOLDERS, 220, 'Thor \<Folders', 'Opens various Thor folders')
	*!* RemoveThorMainMenuItem (lnMoreID, ccUSAGESUMMARY, 235, 'Thor Usage Summary', 'Summary of usage of Thor tools')

	*!* AddThorMainMenuSeparator (lnMoreID, 300, 'SEPARATOR3')

	*!* AddThorMainMenuItem (lnMoreID, ccINTERNALFRAMEWORK, 310, 'Thor Framework', 'Framework of tools to assist in creating tools')
	*!* AddThorMainMenuItem (lnMoreID, ccDEBUGMODE, 320, '\<Debug Mode', 'Toggles debug mode for working on Thor and IDE Tools')

	*!* AddThorMainMenuSeparator (lnMoreID, 400, 'SEPARATOR41')
	*!* AddThorMainMenuItem	(lnMoreID, 'Thor-ChangeLogs', 410, 'Change \<Logs', '')
	*!* RemoveThorMainMenuItem 	(lnMoreID, 'Thor-ERs', 420, 'Thor ERs', '')

	AddThorMainMenuItem (8, ccMANAGEPLUGINS, 410, 'Manage \<Plug-Ins', 'Manages plug-in PRGS used by some tools')

	AddThorMainMenuSeparator (8, 300, 'SEPARATOR3')

	AddThorMainMenuItem (8, ccINTERNALFRAMEWORK, 510, 'Framework', 'Framework of tools to assist in creating tools')
	AddThorMainMenuItem (8, ccDEBUGMODE, 520, '\<Debug Mode', 'Toggles debug mode for working on Thor and IDE Tools')

	*!* ** } JRN -- 6/26/2023 7:50:58 AM - End
	
	
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
	
	RemoveThorMainMenuItem (8, ccThorTWEeTs, 	206, 	'Thor TWEeTs', "History of all Thor TWEeTs (This Week's Exceptional Tools")
	RemoveThorMainMenuItem (8, 'Thor-Blogs', 	217, 	'Blogs', '')
	*!* ******** JRN Removed 2023-11-28 ********
	*!* RemoveThorMainMenuSeparator (8, 300, 'SEPARATOR11')
	*	RemoveThorMainMenuItem (8, loMenuDefs.More, 999, 'More')
	Delete For MenuID = 8 And SortOrder = 999

	RemoveThorMainMenuItem (loMenuDefs.More, ccSOURCEFILES, 230, 'Source Files', 'Downloads source files for APPs')
	RemoveThorMainMenuItem (8, ccINTERNALALLTOOLSPRG, 120, 'Run Tool', 'All tools registered with Thor')

	RemoveThorMainMenuItem (8, ccINTERNALMODIFY, 210, 'Modify Tool', 'Open tool with Modify Command')
	*!* ******** JRN Removed 2023-11-28 ********
	*!* RemoveThorMainMenuItem (8, ccMANAGEPLUGINS, 215, 'Manage Plug-Ins', 'Manages plug-in PRGS used by some tools')
	RemoveThorMainMenuItem (8, ccCOMMUNITY, 210, 'Community / Discussions', 'Community for discussing Thor, Thor Repository, and related topics.')
	*!* ******** JRN Removed 2023-11-28 ********
	*!* RemoveThorMainMenuItem (8, ccOPENFOLDERS, 220, 'Open Folder', 'Opens various Thor folders')
	RemoveThorMainMenuItem (8, ccSOURCEFILES, 230, 'Source Files', 'Downloads source files for APPs')
	*!* ******** JRN Removed 2023-11-28 ********
	*!* RemoveThorMainMenuItem (8, ccINTERNALFRAMEWORK, 240, 'Thor Framework', 'Framework of tools to assist in creating tools')
	*!* ******** JRN Removed 2023-11-28 ********
	*!* RemoveThorMainMenuItem (8, ccDEBUGMODE, 250, 'Debug Mode', 'Toggles debug mode for working on Thor and IDE Tools')

	RemoveThorMainMenuSeparator (8, 500, 'SEPARATOR3')
	*!* ******** JRN Removed 2023-11-28 ********
	*!* RemoveThorMainMenuSeparator (8, 300, 'SEPARATOR2')

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


