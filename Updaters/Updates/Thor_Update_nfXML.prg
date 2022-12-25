Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"nfXML installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'nfXML'
    .Component            = 'Yes'
    .VersionLocalFilename = 'nfJson VersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .VersionNumber	  = '1'
    .VersionDate          = Date(2016,  8, 9)
    .ProjectCreationDate  = Date(2016,  8, 1)


    .SourceFileUrl        = 'https://github.com/VFPX/nfXML/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/nfXML'
    .LinkPrompt           = 'nfXML Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
Provides two simple to use functions to convert complex XML into a VFP (empty-based) object and vice versa.

Project includes...
    nfXmlRead.prg: standalone function, receives valid XML string, returns VFP empty-based object.
    nfXmlCreate.prg: receives VFP object , returns XML string.
    test.prg: turns sample file test.xml into VFP object.
    test.xml: sample XML file
EndText
    Return lcNotes
EndProc
