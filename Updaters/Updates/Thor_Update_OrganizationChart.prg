Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"Organization Chart installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'Organization Chart'
    .Component            = 'Yes'
    .VersionLocalFilename = 'OrganizationChartVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .AvailableVersion     = 'Organization Chart - 1 - June 16, 2011 - 20110616'
    .SourceFileUrl        = 'https://github.com/VFPX/OrganizationChart/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/OrganizationChart'
    .LinkPrompt           = 'Organization Chart Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
Project Manager: Jijo Pappachan jijopappachan@gmail.com

Currently we don’t have a native Organization Chart control in VFP. With this project, developers 
can easily create Organization Tree view.
    EndText
    Return lcNotes
EndProc
