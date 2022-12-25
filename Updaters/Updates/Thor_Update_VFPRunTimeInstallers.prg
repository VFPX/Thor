Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"VFP RunTime Installers installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'VFP RunTime Installers'
    .Component            = 'Yes'
    .VersionLocalFilename = 'VFP RunTime Installers VersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .VersionNumber	  = 1
    .VersionDate          = Date(2014, 12, 17)
    .ProjectCreationDate  = Date(2014, 12, 17)


    .SourceFileUrl        = 'https://github.com/VFPX/VFPRuntimeInstallers/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/VFPRuntimeInstallers'
    .LinkPrompt           = 'VFP Runtime Installers Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
The VFP runtime installers are no longer available for download from Microsoft's web site, so we've made them available on VFPX.
    EndText
    Return lcNotes
EndProc
