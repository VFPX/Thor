Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"Latest release of ThemedTitleBar installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'ThemedTitleBar'
    .Component            = 'Yes'
    .VersionLocalFilename = 'ThemedTitleBar Download.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .VersionNumber	  = 'V2015.2.24'
    .VersionDate          = Date(2015, 2, 24)
    .ProjectCreationDate  = Date(2015, 1, 8)


    .SourceFileUrl        = 'https://github.com/VFPX/ThemedTitleBar/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/ThemedTitleBar'
    .LinkPrompt           = 'ThemedTitleBar Download'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
The TitleBar of a VFP form displayed 'In Screen' or 'In Top-Level Form' looks a bit outdated nowadays. At least running in Win8 and compared to Office 2013 or Visual Studio 2013. The goal of this project is to provide a modern drop-in replacement for the default TitleBar, requiring no code changes to existing forms.
EndText
    Return lcNotes
EndProc
