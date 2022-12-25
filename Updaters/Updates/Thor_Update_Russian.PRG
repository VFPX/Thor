Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"VFP 9.0 Localization in Russian installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'VFP 9.0 Localization in Russian'
    .Component            = 'Yes'
    .VersionLocalFilename = 'VFP9RussianVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .AvailableVersion     = 'VFP 9.0 Localization in Russian - 1 - June 23, 2009 - 20090623'
    .SourceFileUrl        = 'https://github.com/VFPX/RussianLocalization/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/RussianLocalization'
    .LinkPrompt           = 'VFP 9.0 Localization in Russian Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
Seeks to provide a Russian-localized IDE and help for Visual FoxPro 9.0.
    EndText
    Return lcNotes
EndProc
