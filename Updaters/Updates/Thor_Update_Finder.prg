#Define VersionFileName 'FinderVersionFile.txt'
Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    Messagebox('Tool "Finder" installed', 0 ,"Finder...", 3000)
EndText

With loUpdateObject
    .ApplicationName      = 'Finder'
	.InstallInTools	      = .T.
    .VersionNumber        = '1.1.20'
    .VersionDate          = Date(2024, 12, 01)
    .SourceFileUrl        = 'https://raw.githubusercontent.com/VFPX/Finder/master/Finder.zip'
    .LinkPrompt           = 'Finder Home Page'
    .Link                 = 'https://github.com/VFPX/Finder'
    .VersionLocalFilename = VersionFileName
    .RegisterWithThor     = lcRegisterWithThor
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes

Text to lcNotes NoShow TextMerge
EndText

    Return lcNotes
EndProc
