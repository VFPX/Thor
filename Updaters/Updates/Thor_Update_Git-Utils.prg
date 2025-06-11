lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor Launcher, see "Applications -> Git Utilities"', 0 ,"Git Utilities installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@', '') 

With loUpdateObject
    .ApplicationName      = 'Git Utilities'
    .Component            = 'No'
    .ToolName             = 'Thor_Tool_ThorInternalRepository'
    .VersionLocalFilename = 'GitUtilitiesVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .VersionFileURL       = 'https://raw.githubusercontent.com/mikepotjer/vfp-git-utils/master/ThorUpdater/GitUtilitiesVersionFile.txt'
Endwith

Return loUpdateObject
