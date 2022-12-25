Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"Win7TLib installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'Win7TLib'
    .Component            = 'Yes'
    .VersionLocalFilename = 'Win7TLibVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .AvailableVersion     = 'Win7TLib - 0.80 Alpha - Oct. 16, 2010 - 20101016'
    .SourceFileUrl        = 'https://github.com/VFPX/Win7TLib/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/Win7TLib'
    .LinkPrompt           = 'Win7TLib Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
Integrate Windows 7 Taskbar Functionality into your VFP Applications

Project Manager: Steve Ellenoff

The Win7TLib project was created to allow VFP developers full integration of all the new Windows 7 Taskbar 
functionality into applications with minimal effort.
    EndText
    Return lcNotes
EndProc
