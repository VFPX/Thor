Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"VFP2C32 installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'VFP2C32'
    .Component            = 'Yes'
    .VersionLocalFilename = 'VFP2C32VersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .VersionNumber        = '2.0.0.12'
    .VersionDate          = Date(2013, 2, 2)

    .SourceFileUrl        = 'https://github.com/ChristianEhlscheid/vfp2c32/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/ChristianEhlscheid/vfp2c32'
    .LinkPrompt           = 'VFP2C32 Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
FLL with wrappers for many WinAPI functions, and C Struct/Enum converter


Provide functionality contained in the WinAPI to Visual FoxPro developers in easy to use functions.
Enable Visual FoxPro developers to more easily write their own wrappers around C style libraries.

The project manager, Christian Ehlscheid, can be reached at c.ehlscheid@gmx.de. 
    EndText
    Return lcNotes
EndProc
