Lparameters toUpdateInfo

Local lcNotes, lcRegisterWithThor

* Code to be executed when the this project is installed by Thor
Text to lcRegisterWithThor NoShow TextMerge
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"FoxcodePlus installed", 5000)
EndText

* Notes to appear in Check For Updates (at the bottom) 
Text to lcNotes NoShow
The FoxcodePlus project is designed to bring new IntelliSense features found in Visual Studio to the Visual FoxPro IDE through code written in Visual FoxPro to the Windows API and a FLL. The list of features is quite extensive:
    Incremental IntelliSense for functions, commands and so on.
    Variables in write-time.
    Accessing the list of variables in write-time.
    Constants in write-time.
    Tables in write-time and run-time.
    Fields in write-time and run-time.
    Selecting a table with the command "Select" or all commands with the clause "IN".
    Windows APIs in write-time and run-time.
    Functions and Procedures in write-time.
    Classes in write-time.
    Properties in write-time.
    Methods and Events in write-time.
    Summary Tooltip for functions, procedures, methods and events.
    Classes objects in write-time.
    WITH...ENDWITH with nesting infinity for any class or instantiated object in write-time and run-time.
    Objects instantiated in memory.
    Incremental Shortcut to controls on the form or class designer.
    New IntelliSense for some commands.
    Code snippets.
    Intellisense in write-time for the objects created with the functions CreateObject(),CreateObjectEx() and NewObject() using PRG or VCX file.
    Help pressing F1 when intellisense is opend.
    Documenting properties in PRG files with custom tooltip like summary.
EndText

With toUpdateInfo

	* The name of the application (and also the folder it is stored in)
    .ApplicationName      = 'FoxcodePlus'

    * Is this application a Component (if not, then a tool used in IDE)
    .Component            = 'Yes'

    .VersionNumber = 'Beta 3.13.01' && this must be character!
    .VersionDate   = Date(2013,5,9) && this avoids date formatting issues

	* The name of the text file containing the version currently installed.
    .VersionLocalFilename = 'FoxcodePlusVersionFile.txt'

	* URL for the ZIP file 
    .SourceFileUrl        = 'https://github.com/VFPX/FoxcodePlus/archive/refs/heads/master.zip'
    
    * URL for the home page for the project
    .Link                 = 'https://github.com/VFPX/FoxcodePlus'
    
    * Prompt to be used in the Check for Updates screen to access the home paeg
    .LinkPrompt           = 'FoxCodePlus Home Page'

    * The code to be executed when the this project is installed by Thor
    .RegisterWithThor     = lcRegisterWithThor

	* Notes to appear in Check For Updates (at the bottom) 
    .Notes                = lcNotes
EndWith

Execscript (_Screen.cThorDispatcher, 'Result=', toUpdateInfo)
Return toUpdateInfo