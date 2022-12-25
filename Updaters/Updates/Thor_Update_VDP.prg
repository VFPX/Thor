Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"VFPDosPrint installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'VFPDosPrint'
    .Component            = 'Yes'
    .VersionLocalFilename = 'VFPDosPrintVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .VersionNumber 	  = '1.0' && this must be character!
    .VersionDate          = Date(2014, 7, 25) && this avoids date formatting issues
    .ProjectCreationDate  = Date(2014, 7, 21)

    .SourceFileUrl        = 'https://github.com/VFPX/VFPDosPrint/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/VFPDosPrint'
    .LinkPrompt           = 'VDP Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
DOSPrint is a VFP class library that lets you to quickly generate text-based reports and send them directly to any dot-matrix printer, using all the printers speed and other features.

DOSPrint offers a rich object interface that allow you to manually generate any text-based report, but use its exclusive and easy-to-use Format Files. Using a format file with DOSPrint, you can generate complex text-based reports with just a couple of code lines. This format files lets you to "visually" designs your text-based reports using a very simple syntax based on sections. Its so easy to design a format file that even your final users will be able to design their own DOSPrint reports!
    EndText
    Return lcNotes
EndProc

