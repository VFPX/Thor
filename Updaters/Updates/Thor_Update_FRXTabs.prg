Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"FRXTabs installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'FRXTabs'
    .Component            = 'Yes'
    .VersionLocalFilename = 'FRXTabsVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .AvailableVersion     = 'FRXTabs - 1 - Feb. 5, 2012 - 20120205'
    .SourceFileUrl        = 'https://github.com/VFPX/FRXTabs/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/FRXTabs'
    .LinkPrompt           = 'FRXTabs Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
Data-Driven Extension for VFP Report Designer

Project Manager: Doug Hennig

The VFP Report Designer can be extended by adding new tabs to existing dialogs without modifying 
any source code; this is done by adding “T” records to the report registry table. However, the only 
way to make changes to existing tabs is to modify the source and rebuild ReportBuilder.APP.

FRXTabs provides a data-driven mechanism to define each tab in each dialog at runtime. To change a 
tab, simply subclass the existing one, make any desired changes, and change the record in the registry 
table to specify the subclass rather than the original. No changes are required to ReportBuilder.APP.
    EndText
    Return lcNotes
EndProc
