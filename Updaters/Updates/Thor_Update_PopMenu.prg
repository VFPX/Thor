Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"PopMenu installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'PopMenu'
    .Component            = 'Yes'
    .VersionLocalFilename = 'PopMenuVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .AvailableVersion     = 'PopMenu - Alpha - July 11, 2008 - 20080711'
    .SourceFileUrl        = 'https://github.com/VFPX/PopMenu/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/PopMenu'
    .LinkPrompt           = 'PopMenu Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
Provides owner-drawn object-oriented shortcut menus.

This project is similar to the OOP Menu Project but provides shortcut menus and "owner drawn" menus, 
allowing you to create Office-style menus. It has the following characteristics:

    The style of menu will be consistent with Operating System
    It will be allow to Owner draw
    It allows recursive definition of the structure similar to Treeview
    Connect multiple menu object.
    User can use ICO,MSK,BMP picture.
    Users can easily control the location of pop-up menu.This is very useful for the Toolbar and the system tray. 
    EndText
    Return lcNotes
EndProc
