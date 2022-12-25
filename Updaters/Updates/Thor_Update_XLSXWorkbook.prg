Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"XLSX Workbook installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'XLSX Workbook'
    .Component            = 'Yes'
    .VersionLocalFilename = 'XLSX Workbook VersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .VersionNumber	  = '1.2'
    .VersionDate          = Date(2016, 09, 28)
    .ProjectCreationDate  = Date(2015, 10, 8)


    .SourceFileUrl        = 'https://github.com/ggreen86/XLSX-Workbook-Class/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/ggreen86/XLXS-Workbook-Class'
    .LinkPrompt           = 'XLSX Workbook Home Page'

    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
Current release allows writing to XLSX format files without any automation. Support for full cell export with cell formatting and formulas. Cell formatting includes borders, font (size, name, bold, italic, underline, etc), foreground color, and background color, and number formatting. Multiple sheet support.

A PDF file is included for the documentation on the methods and properties. See the Demo() method for example of uses; a PRG is included that calls the Demo() method.
EndText
    Return lcNotes
EndProc
