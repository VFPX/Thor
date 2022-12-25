Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"Tab Menu installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'Tab Menu'
    .Component            = 'Yes'
    .VersionLocalFilename = 'TabMenuVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .AvailableVersion     = 'Tab Menu - 1.0.5 - March 20, 2008 - 20080320'
    .SourceFileUrl        = 'https://github.com/VFPX/TabMenu/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/TabMenu'
    .LinkPrompt           = 'Tab Menu Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
Seeks to provide an Office 2007 style menu interface using the standard VFP menu designer 
plus extensions for VFP projects.

Project Manager: Goran Zidar(g.zidar@gmail,COM)

The latest release 1.0.5 has been made available on the 20/03/2008. This release provides 
the functionality to change the look of the UI and comes with examples including two 
different themes. 

This version also allows you to create a menu that behaves like the traditional menus 
that we are familiar with as shown in the screenshot below:
    EndText
    Return lcNotes
EndProc
