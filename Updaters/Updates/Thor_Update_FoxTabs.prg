#Define	ccThorToolName 'Thor_Tool_FoxTabs'

Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('Thor tool "FoxTabs" created', 0 ,"FoxTabs downloaded", 3000)

    * Create tool under VFPx
    loThorInfo = Execscript (_Screen.cThorDispatcher, 'Thor Register=')

    With loThorInfo
        * Required
        .PRGName       = ccThorToolName
        .FolderName    = '##InstallFolder##'
        .Prompt        = 'FoxTabs'
        
        * Optional
        .Description   = 'DataTabs'

        * These are used to group and sort tools when they are displayed in menus or the Thor form
        .Category      = 'Applications'
		.CanRunAtStartUp = .T.
        
        @@@Text To .Code Noshow Textmerge
Do ('##InstallFolder##FoxTabs.APP')
        @@@Endtext

        llRegister = .Register()

    Endwith
    
EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'FoxTabs'
    .VersionLocalFilename = 'DataExplorerVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .VersionNumber	  = 'FoxTabs 1.2'
    .VersionDate          = Date(2014, 10, 26)
    .SourceFileUrl        = 'https://github.com/VFPX/FoxTabs/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/FoxTabs'
    .LinkPrompt           = 'FoxTabs Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
FoxTabs is a handy little utility for adding a tabbed window interface to the VFP IDE. It is written in VFP and uses 
BindEvents heavily. With the limited space available in the VFP IDE, it can be time consuming to find and switch 
among open windows. FoxTabs makes it easier to find the correct editor or designer you have open.

FoxTabs is a project originally started in Australia by Scott Scovell and Craig Bailey. Their generosity made the 
move to VFPX simple and allows the development to progress. Thanks to both!
    EndText   
    Return lcNotes
EndProc
