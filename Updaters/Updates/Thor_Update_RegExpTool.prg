Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"VFPRegExpTester installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'VFPRegExpTool'
    .Component            = 'Yes'
    .VersionLocalFilename = 'nfJson VersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .VersionNumber	  = '1'
    .VersionDate          = Date(2016,  8, 23)
    .ProjectCreationDate  = Date(2016,  7, 30)


    .SourceFileUrl        = 'https://github.com/VFPX/VFPRegExTool/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/VFPRegExTool'
    .LinkPrompt           = 'VFP RegEx Tool Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
Provides a testing tool so Visual FoxPro developers can simply verify regular expression within the Visual FoxPro IDE. It is based on vbScript.regexp.
EndText
    Return lcNotes
EndProc
