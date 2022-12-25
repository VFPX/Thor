#include Thor_UI.H
CreateThorTables ('C:\temp\jjj\')

Procedure CreateThorTables

	* Create the Thor tables if they do not already exist

	Lparameters tcFolder

	* HotKeyDefinitions

	If Not File (tcFolder + 'HotKeyDefinitions.DBF')
		Create Table (tcFolder + 'HotKeyDefinitions') Free					;
			(Id I Autoinc, nKeyCode I, nShifts N(1), Descript C(40),		;
			  FKYValue C(2) NoCPTrans)
		Index On Id Tag Id
		Use
	Endif Not File (tcFolder + 'HotKeyDefinitions.DBF')

	* MenuDefinitions

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
		Use (tcFolder + 'MenuDefinitions.DBF')
	Endif Not File (tcFolder + 'MenuDefinitions.DBF')

	Locate For PopupName = ccRunAllTools
	If Not Found()
		Insert Into MenuDefinitions (Prompt, Internal, TopLevel, PopupName, SortOrder)		;
			Values ('Tho\<r Tools', .F., .T., ccRunAllTools, 8)
	Endif

	* Seemingly out of order, but done here because of already installed menus
	Locate For PopupName = 'Thor_Internal'
	Replace StatusBar With 'Configures Thor, gives access to help pages, the Thor framework, and the Thor discussion group; runs Check For Updates'

	Locate For PopupName = ccRunAllTools
	Replace StatusBar With 'Runs all Thor Tools'

	Use

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

	AddThorMainMenuItem (8, ccINTERNALEDITPRG, 110, 'Configure', 'Assign hot keys, create menus and sub-menus, etc.')
	*!* * Removed 2/3/2012 
	*!* AddThorMainMenuItem (8, ccINTERNALALLTOOLSPRG, 120, 'Run Tool', 'All tools registered with Thor')
	Locate For MenuID = 8  And Upper (PRGName) = Upper (ccINTERNALALLTOOLSPRG)
	If Found()
		Delete
	Endif

	AddThorMainMenuSeparator (8, 200, 'SEPARATOR1')

	AddThorMainMenuItem (8, ccINTERNALMODIFY, 210, 'Modify Tool', 'Open tool with Modify Command')
	AddThorMainMenuItem (8, ccMANAGEPLUGINS, 215, 'Manage Plug-Ins', 'Manages plug-in PRGS used by some tools')
	AddThorMainMenuItem (8, ccOPENFOLDERS, 220, 'Open Folder', 'Opens various Thor folders')
	AddThorMainMenuItem (8, ccSOURCEFILES, 230, 'Source Files', 'Downloads source files for APPs')
	AddThorMainMenuItem (8, ccINTERNALFRAMEWORK, 240, 'Thor Framework', 'Framework of tools to assist in creating tools')
	AddThorMainMenuItem (8, ccDEBUGMODE, 250, 'Debug Mode', 'Toggles debug mode for working on Thor and IDE Tools')

	AddThorMainMenuSeparator (8, 300, 'SEPARATOR2')

	AddThorMainMenuItem (8, ccINTERNALHELPPRG, 310, 'Help Home Page', 'Help for Thor')
	AddThorMainMenuItem (8, ccINTERNALRepostitory, 320, 'Repository Home Page', 'Home page for Thor Repository')
	AddThorMainMenuItem (8, ccINTERNALTOOLLINK, 330, 'Tool Home Pages', 'Home page for each tool (if any)')

	AddThorMainMenuSeparator (8, 400, 'SEPARATOR3')

	AddThorMainMenuItem (8, ccCHECKFORUPDATES, 410, 'Check for Updates', 'Check for and install any outstanding updates')
	AddThorMainMenuItem (8, ccCOMMUNITY, 420, 'Community / Discussions', 'Community for discussing Thor, Thor Repository, and related topics.')

	Use

	* ToolHotKeyAssignments

	If Not File (tcFolder + 'ToolHotKeyAssignments.DBF')
		Create Table (tcFolder + 'ToolHotKeyAssignments') Free		;
			(Id I Autoinc, PRGName C(60), HotKeyID I)
		Index On HotKeyID Tag HotKeyID
		Index On Upper (PRGName) Tag PRGName
		Index On Id Tag Id
		Use
	Endif Not File (tcFolder + 'ToolHotKeyAssignments.DBF')

	* StartupTools

	If Not File (tcFolder + 'StartupTools.DBF')
		Create Table (tcFolder + 'StartupTools')  Free		;
			(Id I Autoinc, PRGName C(60), StartUp L)
		Index On Upper (PRGName) Tag PRGName
		Index On Id Tag Id
		Use
	Endif Not File (tcFolder + 'StartupTools.DBF')

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
			Insert Into Thor														;
				(Key, Caption, Value, Display, Type, Valid, Class, Library)			;
				Values ('ThorHotKey', ccTHOR_HOT_KEY,								;
				  'Alt-F12', 'Alt-F12', 'C', '', 'ThorHotKey', 'Thor_UI.vcx')
		Case Class # 'ThorOptionsControls'
			Replace Class With 'ThorOptionsControls', Library With 'Thor_UI.vcx'
	Endcase

	Locate For Key = 'UpdateMessage'
	Do Case
		Case Not Found()
			Insert Into Thor														;
				(Key, Caption, Value, Display, Type, Valid, Class, Library)			;
				Values ('UpdateMessage', ccUPDATE_MESSAGE,							;
				  'Y', ccYES, 'L', '', '', '')
		Case Class # 'ThorOptionsControls'
			Replace Class With 'ThorOptionsControls', Library With 'Thor_UI.vcx'
	Endcase

	Locate For Key = 'FontSize'
	Do Case
		Case Not Found()
			Insert Into Thor														;
				(Key, Caption, Value, Display, Type, Valid, Class, Library)			;
				Values ('FontSize', ccFONT_SIZE,									;
				  '8', '8', 'N', '', '', '')
		Case Class # 'ThorOptionsControls'
			Replace Class With 'ThorOptionsControls', Library With 'Thor_UI.vcx'
	Endcase

	*!* * Removed 06/01/2011
	*!* Locate For Key = 'SystemMenuPads'
	*!* If Not Found()
	*!* 		Insert Into Thor Values ('SystemMenuPads', ccSYSTEM_MENU_PADS,		;
	*!* 			'Y', ccYES, 'L', '', '', '')
	*!* Endif

	Use

	* LogFile

	If Not File (tcFolder + 'LogFile.DBF')
		Create Table (tcFolder + 'LogFile') Free		;
			(PRGName C(60), Posted T, Uploaded L)
	Endif Not File (tcFolder + 'LogFile.DBF')

Endproc
