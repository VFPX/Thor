Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"VFP Grid ManyHeader installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'VFP Grid ManyHeader'
    .Component            = 'Yes'
    .VersionLocalFilename = 'VFP Grid ManyHeaderVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .AvailableVersion     = 'VFP Grid ManyHeader - 1 - June 20, 2008 - 20080620'
    .SourceFileUrl        = 'https://github.com/VFPX/VFPGridManyHeader/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/VFPGridManyHeader'
    .LinkPrompt           = 'VFP Grid ManyHeader Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
Custom container class for replacing and extending the VFP header class

The goals of this project are:

    Allow 2 or more levels of headers per column. These custom headers can also be merged with one another.
    Provide a more intuitive operation and interface for the grid’s lock columns feature.
    Address the flaw: a column can’t be moved after having been locked.
    Resolve the problem: user can unlock columns by right clicking with their mouse.
    EndText
    Return lcNotes
EndProc
