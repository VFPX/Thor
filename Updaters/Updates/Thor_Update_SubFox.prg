Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"SubFox installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'SubFox'
    .Component            = 'Yes'
    .VersionLocalFilename = 'SubFoxVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .AvailableVersion     = 'SubFox - 1.2.122 - Oct. 21, 2012 - 20121021'
    .SourceFileUrl        = 'https://github.com/VFPX/SubFox/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/SubFox'
    .LinkPrompt           = 'SubFox Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
Seamless integration for Subversion source code control

For Subversion:
    Simplify and automate the enumeration of which files are “versioned” within a project. Although this sounds simple, most Subversion users learn that accidentally including “extra” files in a project leads to major headaches. It is unwise to merely take “everything” in a folder.

For Tortoise:
    Automate the encoding and decoding of source files triggered by events (aka hooks).

For Visual FoxPro:
    Interact with Subversion directly from inside the Integrated Development Environment (IDE).
    Fulfill all day-to-day interactions with Subversion via Toolbar and/or the VFP Main Menu.
    Develop with VFP native language to allow developers to “add hooks” for their custom environment whenever needed.
    EndText
    Return lcNotes
EndProc

