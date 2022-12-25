Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"Automated Build installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'Automated Build'
    .Component            = 'Yes'
    .VersionLocalFilename = 'AutomatedBuildVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .AvailableVersion     = 'Automated Build - 1 - June 23, 2009 - 20090623'
    .SourceFileUrl        = 'https://github.com/VFPX/AutomatedBuild/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/AutomatedBuild'
    .LinkPrompt           = 'Automated Build Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
Automate your Visual FoxPro application builds using extensions to CruiseControl.NET.

Build automation, continuous integration...

This project is mainly an extension for CruiseControl.NET, written in Visual FoxPro. It should also work with Team Foundation Server. The goals of the project include: provide the environment for a build server that can build Visual FoxPro projects without an interactive user sitting in front of it, record build errors, and so on.

Tools work in both Visual FoxPro 9 and 8. It’s already in production at several sites, each building several projects from different developers for many months and works flawlessly. 

This project is completely separate and different from the VFPX MSBuild project.
    EndText
    Return lcNotes
EndProc
