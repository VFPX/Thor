Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"ProjectHookX installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'ProjectHookX'
    .Component            = 'Yes'
    .VersionLocalFilename = 'ProjectHookXVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .AvailableVersion     = 'ProjectHookX - 1.00 - Jan. 9, 2012 - 20120109'
    .SourceFileUrl        = 'https://github.com/VFPX/ProjectHookX/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/ProjectHookX'
    .LinkPrompt           = 'ProjectHookX Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
Visual FoxPro projecthooks were released back in version 6.0. The projecthook class allows VFP developers the 
ability to write code in response to events fired while working with the Project Manager. This allows developers 
to extend the functionality of the Project Manager and automate tasks associated to the development of a 
project. The design of a traditional projecthook follows the Microsoft's initial intentions of one projecthook 
for one project. The ProjectHookX project builds and extends this concept using the hook pattern so multiple 
projecthooks are associated to a project.
    EndText
    Return lcNotes
EndProc
