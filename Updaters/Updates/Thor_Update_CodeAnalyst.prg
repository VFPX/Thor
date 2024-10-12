#Define	ccThorToolName 'Thor_Tool_CodeAnalyst'
#Define	CR Chr[13]

Lparameters loUpdateObject

	Text to lcRegisterWithThor NoShow TextMerge
    
    * Create tool under VFPx
    loThorInfo = Execscript (_Screen.cThorDispatcher, 'Thor Register=')

    With loThorInfo
        * Required
        .PRGName       = ccThorToolName
        .FolderName    = '##InstallFolder##'
        .Prompt        = 'Code Analyst'
        
        * Optional
        .Description   = 'A development tool that helps FoxPro developers identify areas of code that should or could be refactored.'

        * These are used to group and sort tools when they are displayed in menus or the Thor form
        .Category      = 'Applications'
		.OptionClasses = 'clsShowConfiguration'
        .OptionTool	   = 'Code Analyst'
		.CanRunAtStartUp = .F.
        
* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        #@#Text To .DefineStatements Noshow Textmerge
##@#Define		ccContainerClassName	'clsConfiguration'
##@#Define		ccXToolName				'Code Analyst'

##@#Define		ccShowConfiguration		'Show Configuration'
        #@#Endtext
* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        #@#Text To .Code Noshow Textmerge

	* -------------------------------------------------------------------------------- 
	#Define 	ccFILE		'File'
	#Define 	ccFOLDER	'Folder'
	#Define 	ccPROJECT	'Project'

	#Define		ccINSTALLFOLDER '##InstallFolder##'

	* ContextMenu home page = https://github.com/VFPX/Thor/blob/master/Docs/Thor_framework_contextmenu.md
	Local loContextMenu As ContextMenu Of 'C:\VISUAL FOXPRO\PROGRAMS\9.0\COMMON\Thor\Source\Thor_Menu.vcx'
	Local lcAPP, lcFolder, lcKeyword, llShowConfig, lnMsgBoxAns

    	lcAPP	  = ccINSTALLFOLDER + '\CodeAnalyst-master\Analyst.APP' 

	* --------------------------------------------------------------------------------
	loContextMenu = Execscript(_Screen.cThorDispatcher, 'Class= ContextMenu')

	loContextMenu.AddMenuItem('Prompt for file', , , , ccFILE)
	loContextMenu.AddMenuItem('Prompt for folder', , , , ccFOLDER)
	If _vfp.Projects.Count # 0
		loContextMenu.AddMenuItem('Current project', , , , ccPROJECT)
	Endif

	If Not loContextMenu.Activate()
		Return
	Endif

	* --------------------------------------------------------------------------------
	llShowConfig = Execscript (_Screen.cThorDispatcher, 'Get Option=', ccShowConfiguration, ccXToolName)

	If llShowConfig
		lnMsgBoxAns = Messagebox('Open configuration form for Code Analyst?', 35, 'Open configuration form')
		Do Case
			Case lnMsgBoxAns = 6 && Yes
				Do (lcAPP) With '-Config'
			Case lnMsgBoxAns = 7 && No

			Case lnMsgBoxAns = 2 && Cancel
				Return
		Endcase
	Endif

	* --------------------------------------------------------------------------------
	lcKeyword = loContextMenu.Keyword
	Do Case
		Case lcKeyword = ccFILE
			Do (lcAPP)
		Case lcKeyword = ccFOLDER
			lcFolder = Getdir()
			If Not Empty(lcFolder)
				Do (lcAPP) With 'DIRECTORY', lcFolder
			Endif
		Case lcKeyword = ccPROJECT
			Do (lcAPP) With _vfp.ActiveProject.Name
	Endcase

        #@#Endtext
* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        #@#Text To .ClassDefinitions Noshow Textmerge

****************************************************************

Define Class clsShowConfiguration As Custom

	Tool		  = ccXToolName
	Key			  = ccShowConfiguration
	Value		  = .T.
	EditClassName = ccContainerClassName

Enddefine

****************************************************************
Define Class clsConfiguration As Container

	Procedure Init
		loRenderEngine = Execscript(_Screen.cThorDispatcher, 'Class= OptionRenderEngine')

		#@@@#Text To loRenderEngine.cBodyMarkup Noshow Textmerge
		
			.Class	  = 'CheckBox'
			.AutoSize = .T.
			.Caption  = 'Ask to open configuration form before running Analyst'
			.cTool	  = ccXToolName
			.cKey	  = ccShowConfiguration

		#@@@#Endtext

		loRenderEngine.Render(This, ccXToolName)

	Endproc

	Procedure ClearISXOptions
		_Screen.AddProperty('oISXOptions', Null)
	Endproc

Enddefine

        #@#Endtext
* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        llRegister = .Register()

    Endwith

EndText


lcRegisterWithThor = Strtran(lcRegisterWithThor, '#@#')

With loUpdateObject
    .ApplicationName      = 'Code Analyst'
    .VersionLocalFilename = 'CodeAnalystVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .VersionNumber        = '1.03.1 Beta'
    .VersionDate          = Date(2013, 1, 28)
    .SourceFileUrl        = 'https://github.com/VFPX/CodeAnalyst/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/CodeAnalyst'
    .LinkPrompt           = 'Code Analyst Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
A development tool that helps FoxPro developers identify areas of code that should or could be refactored.

Code Analyst is extensible, allowing developers to create their own refactoring rules and then enable or disable them as needed. Some of the code was based on the Code References tool.

Rules can be associated with different aspects of code. For example, an Object rule might analyse all objects on a form to ensure they are using a naming convention. 
    EndText   
    Return lcNotes
EndProc
