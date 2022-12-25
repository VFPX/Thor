Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"FFC installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'FFC'
    .Component            = 'Yes'
    .VersionLocalFilename = 'FFCVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .VersionNumber        = '1'
    .VersionDate          = Date(2014, 7, 4)
    .SourceFileUrl        = 'https://github.com/VFPX/FFC/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/FFC'
    .LinkPrompt           = 'FFC Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
Microsoft Visual FoxPro 9.0 Foundation Classes

The Visual FoxPro visual class (.vcx) libraries located in the Visual FoxPro ...\FFC directory. They contain a variety of foundation classes for enhancing Visual FoxPro applications with little or no programming. You can freely distribute the foundation classes with your applications. The license governing the FFC source is contained in release (see FFC_EULA.txt).
    EndText
    Return lcNotes
EndProc
