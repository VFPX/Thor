Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"JustBehave installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'JustBehave'
    .Component            = 'Yes'
    .VersionLocalFilename = 'JustBehaveVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .AvailableVersion     = 'JustBehave - 1 - June 26, 2008 - 20080626'
    .SourceFileUrl        = 'https://github.com/VFPX/JustBehave/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/JustBehave'
    .LinkPrompt           = 'JustBehave Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
Extends the behavior of any Visual FoxPro baseclass or custom framework class without the need for additional code.

If a given class requires a behavior which is not inherited in a particular class hierarchy branch, the particular 
code will be “cut and pasted” into the individual control or an entirely new class branch.
Behavior code is loaded once for the entire application and that all registered controls share the common behavior. 
The overall result is a smaller footprint and a potentially more stable operating environment.

The goals of this project are:

    Allow custom behaviors for base or thin UI classes in a centralized manner which will allow multiple behaviors to be added to produce rich UI interfaces with virtually NO programming.
    Improve UI performance and stability by centralizing behavior code and allowing lightweight controls.
     EndText
    Return lcNotes
EndProc
