Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"nfJson installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'nfJson'
    .Component            = 'Yes'
    .VersionLocalFilename = 'nfJson VersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .VersionNumber	  = '1'
    .VersionDate          = Date(2016,  7, 22)
    .ProjectCreationDate  = Date(2016,  2, 24)


    .SourceFileUrl        = 'https://github.com/VFPX/nfJson/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/nfJson'
    .LinkPrompt           = 'nfJson Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
Provides a set of fast performance, reliable and easy to use Json functions using pure VFP.
EndText
    Return lcNotes
EndProc
