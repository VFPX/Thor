Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"ctl32 Projects installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'ctl32'
    .Component            = 'Yes'
    .VersionLocalFilename = 'TabMenuVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .AvailableVersion     = 'ctl32 Projects - 1 - Sept. 3, 2008 - 20080903'
    .SourceFileUrl        = 'https://github.com/VFPX/ctl32_StatusBar/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/ctl32_StatusBar'
    .LinkPrompt           = 'ctl32 Projects Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
    EndText
    Return lcNotes
EndProc
