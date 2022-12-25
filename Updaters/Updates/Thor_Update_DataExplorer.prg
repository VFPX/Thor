#Define	ccThorToolName 'Thor_Tool_DataExplorer'

Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('Thor tool "Data Explorer" created' + chr[13] + chr[13] + 'From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"Data Explorer 3 downloaded", 5000)

    * Create tool under VFPx
    loThorInfo = Execscript (_Screen.cThorDispatcher, 'Thor Register=')

    With loThorInfo
        * Required
        .PRGName       = ccThorToolName
        .FolderName    = '##InstallFolder##'
        .Prompt        = 'Data Explorer'
        
        * Optional
        .Description   = 'Data Explorer 3'

        * These are used to group and sort tools when they are displayed in menus or the Thor form
        .Category      = 'Tables'
		.CanRunAtStartUp = .F.
        
        @@@Text To .Code Noshow Textmerge
Do ('##InstallFolder##DataExplorer.APP')
        @@@Endtext

        llRegister = .Register()

    Endwith
    
EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'Data Explorer 3'
    .Component            = 'Yes'
    .VersionLocalFilename = 'DataExplorerVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .AvailableVersion     = 'Data Explorer 3 - 3.03 - Sept. 9, 2012 - 20120909'
    .SourceFileUrl        = 'https://github.com/rschummer/DataExplorer/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/rschummer/DataExplorer'
    .LinkPrompt           = 'Data Explorer Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
The Data Explorer lets you examine data and components in Visual FoxPro databases, SQL Server databases, 
VFP free tables, or any other ODBC or OLE DB compliant database via an ADO connection. It can run as a 
task pane or as a standalone tool. Those familiar with SQL Server's Management Studio or Visual Studio's 
Server Explorer immediately notice some similarities, but this tool works with all kinds of data, is 
completely integrated in the Visual FoxPro IDE, and is extensible in true VFP tradition. 

Version 3 extends on the functionality provided by the Data Explorer released with Sedna. Specifically:
    Export/Import of Data Explorer features to share with others
    BROWSE for SQL Server with data update capability
    Toggling the Dock State of the Data Explorer form when standalone
    New LIST STRU off the shortcut menu
    New connection type for Directory shows list of all DBFs in a folder
    Corrected bug in Display Show Plan option added to Sedna version of Data Explorer
    VFPX Repository
    EndText
    Return lcNotes
EndProc
