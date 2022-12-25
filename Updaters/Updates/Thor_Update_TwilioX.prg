Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"TwilioX installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'TwilioX'
    .Component            = 'Yes'
    .VersionLocalFilename = 'TwilioX VersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .VersionNumber	  = '1'
    .VersionDate          = Date(2015, 10, 27)
    .ProjectCreationDate  = Date(2015, 10, 27)


    .SourceFileUrl        = 'https://github.com/VFPX/TwilioX/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/TwilioX'
    .LinkPrompt           = 'TwilioX Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
Provides a wrapper class for calling Twilio.com to send texts.
EndText
    Return lcNotes
EndProc
