#Define ccThorToolName      'Thor_Tool_Code_References'

Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge

    * Create tool under VFPx
    loThorInfo = Execscript (_Screen.cThorDispatcher, 'Thor Register=')

    With loThorInfo
        * Required
        .PRGName       = ccThorToolName
        .FolderName    = '##InstallFolder##'
        .Prompt        = 'Code References'
        .Summary       = 'Code References'
        
        * Optional
        .Description   = 'Installs enhanced version of Code References.  Need only be run once.'

        * These are used to group and sort tools when they are displayed in menus or the Thor form
        .Source        = 'VFPx'
        .Category      = ''
        .Link          = '##Link##'
		.CanRunAtStartUp = .F.

        * For public tools, such as PEM Editor, etc.
        .Version       = '##Version##'
        
        @@@Text To .Code Noshow Textmerge

    If Messagebox("Install update to Code References?", 3 ,"Code References", 0) = 6
        lcCurDir = FullPath(Curdir())
        Cd ('##InstallFolder##')
        Do Install
        Cd (lcCurDir)
    Endif

        @@@Endtext

        llRegister = .Register()

    Endwith
    
    * Execute the tool
    ExecScript(_Screen.cThorDispatcher, ccThorToolName)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'Code References'
    .VersionLocalFilename = 'FoxRefVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor

    .AvailableVersion     = 'Code References - 1.2 Beta - October 9, 2010 - 20101009'
    .SourceFileUrl        = 'https://github.com/VFPX/CodeReferences/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/CodeReferences'
    .LinkPrompt           = 'Code References Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject

Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
An enhanced version of Code References. 
    EndText
    Return lcNotes
EndProc
