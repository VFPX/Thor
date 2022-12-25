Lparameters toUpdateInfo

Local lcNotes, lcRegisterWithThor

* Code to be executed when the this project is installed by Thor
Text to lcRegisterWithThor NoShow TextMerge
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"ExcelXML installed", 5000)
EndText

* Notes to appear in Check For Updates (at the bottom) 
Text to lcNotes NoShow
The ExcelXML project is designed to bring to the Visual FoxPro the possibility to generate a Excel file converting 99% of all visual caracteristics from a Grid. However, there is the possibility to generate a file without a Grid.

GOALS
Excel files with over 65,535 rows.
No limit size. (it depents on the Operational System)
Convert a Grid Control into a Excel XML file considering 99% of the visual characteristics.
It is possible to use Grid Dynamics properties.
Based in all Grid visual properties.
It is possible to convert a table without a Grid Control as well.
Easy to implement and it is not necessary to change your code.
Compatible with Microsoft Excel 2003 or higher.
The files can be opened by OpenOffice reducing conversion errors.
Open the file by Excel and save in other formats to reduce the size without loose the information.
It is not necessary to have the Microsoft Excel installed.
Project Manager: Rodrigo Bruscain

EndText

With toUpdateInfo

	* The name of the application (and also the folder it is stored in)
    .ApplicationName      = 'ExcelXML'

    * Is this application a Component (if not, then a tool used in IDE)
    .Component            = 'Yes'

    .VersionNumber = 'Beta 1.08' && this must be character!

    .VersionDate   = Date(2014, 2, 21) && this avoids date formatting issues

	* The name of the text file containing the version currently installed.
    .VersionLocalFilename = 'ExcelXMLVersionFile.txt'

	* URL for the ZIP file 
    .SourceFileUrl        = 'https://github.com/VFPX/ExcelXML/archive/refs/heads/master.zip'
    
    * URL for the home page for the project
    .Link                 = 'https://github.com/VFPX/ExcelXML'
    
    * Prompt to be used in the Check for Updates screen to access the home paeg
    .LinkPrompt           = 'ExcelXML Home Page'

    * The code to be executed when the this project is installed by Thor
    .RegisterWithThor     = lcRegisterWithThor

	* Notes to appear in Check For Updates (at the bottom) 
    .Notes                = lcNotes
EndWith

Execscript (_Screen.cThorDispatcher, 'Result=', toUpdateInfo)
Return toUpdateInfo