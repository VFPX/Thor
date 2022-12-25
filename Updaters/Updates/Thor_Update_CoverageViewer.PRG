Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge

    * Create tool under VFPx
    loThorInfo = Execscript (_Screen.cThorDispatcher, 'Thor Register=')

    With loThorInfo
        * Required
        .PRGName       = 'Thor_Tool_CoverageViewer'
        .FolderName    = '##InstallFolder##'
        .Prompt        = 'Coverage Viewer'
        .Summary       = 'Coverage Viewer'
        
        * Optional
        @@@Text to .Description NoShow
Alternative to Coverage Profiler

        * These are used to group and sort tools when they are displayed in menus or the Thor form
        .Source        = 'VFPx'
        .Category      = ''
        .Link          = 'https://github.com/VFPX/CoverageViewer'
		.CanRunAtStartUp = .F.

        @@@Text To .Code Noshow Textmerge

        Do '##InstallFolder##CvgViewr.app'

        @@@Endtext

        llRegister = .Register()

    Endwith
    
EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'Coverage Viewer'
    .VersionLocalFilename = 'CoverageViewerVersionFile.txt'
    .AppName          = 'CvgViewr.app'
    .ApplicationName  = 'Coverage Viewer'
    .ToolName         = 'Thor_Tool_CvgViewr'
    .SourceFileUrl        = 'https://github.com/VFPX/CoverageViewer/archive/refs/heads/master.zip'
    .Component            = 'No'
    .RegisterWithThor     = lcRegisterWithThor
    .Link          = 'https://github.com/VFPX/CoverageViewer'

    .VersionNumber	  = '1'
    .VersionDate          = Date(2016,  5, 2)
    
    .ProjectCreationDate  = Date(2016,  5, 2)
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
Here are some notes.
EndText
    Return lcNotes
EndProc
