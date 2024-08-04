Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"GDIPlusX installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'GDIPlusX'
    .Component            = 'Yes'
    .VersionLocalFilename = 'GDIPlusXVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .AvailableVersion     = 'GDIPlusX - 1.22 - August 4, 2024 - 20240804'
    .SourceFileUrl        = 'https://github.com/VFPX/GDIPlusX/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/GDIPlusX'
    .LinkPrompt           = 'GDIPlusX Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
GDIPlusX is a set of Visual FoxPro 9.0 class libraries that wrap the 603 GDI+ Flat API functions of GDIPlus.dll.

The library currently consist of 64 VFP wrapper classes and 47 enumeration classes with over 1,500 properties and methods.

The object model of these classes closely emulates the classes contained in the System.Drawing namespace 
of Visual Studio .NET. This not only makes the library easier to use, but also allows VFP developers to 
tap into thousands of GDI+ code samples, written in .NET, that can be easily translated to VFP code. 
The library currently includes over 90% of the functionality included in the following namespaces of .NET:

    System.Drawing
    System.Drawing.Drawing2D
    System.Drawing.Imaging
    System.Drawing.Text    
    EndText
    Return lcNotes
EndProc
