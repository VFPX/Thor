#Define	ccThorToolName 'Thor_Tool_FoxTabs'

lparameters toUpdateObject
local lcAppName, ;
	lcAppID, ;
	lcRepositoryURL, ;
	lcDownloadsURL, ;
	lcVersionFileURL, ;
	lcZIPFileURL, ;
	lcRegisterWithThor

* Set the project settings; edit these for your specific project.

lcAppName       = 'FoxTabs'
	&& the name of the project
lcAppID         = 'FoxTabs'
	&& similar to lcAppName but must be URL-friendly (no spaces or other
	&& illegal URL characters)
lcRepositoryURL = 'https://github.com/VFPX/FoxTabs'
	&& the URL for the project's repository

* If the version file and zip file are in the ThorUpdater folder of the
* master branch of a GitHub repository, these don't need to be edited.
* Otherwise, set lcVersionFileURL and lcZIPFileURL to the correct URLs.

lcDownloadsURL   = strtran(lcRepositoryURL, 'github.com', ;
	'raw.githubusercontent.com') + '/master/ThorUpdater/'
lcVersionFileURL = lcDownloadsURL + lcAppID + 'Version.txt'
	&& the URL for the file containing code to get the available version number
lcZIPFileURL     = lcDownloadsURL + lcAppID + '.zip'
	&& the URL for the zip file containing the project

* This is code to execute after the project has been installed by Thor for the
* first time. Edit this if you want do something different (such as running
* the installed code) or display a different message. You can use code like
* this if you want to execute the installed code; Thor replaces
* ##InstallFolder## with the installation path for the project:
*
* 'do "##InstallFolder##MyProject.prg"'

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('Thor tool "FoxTabs" created', 0 ,"FoxTabs downloaded", 3000)

    * Create tool under VFPx
    loThorInfo = Execscript (_Screen.cThorDispatcher, 'Thor Register=')

    With loThorInfo
        * Required
        .PRGName       = ccThorToolName
        .FolderName    = '##InstallFolder##'
        .Prompt        = 'FoxTabs'
        
        * Optional
        .Description   = 'FoxTabs'

        * These are used to group and sort tools when they are displayed in menus or the Thor form
        .Category      = 'Applications'
		.CanRunAtStartUp = .T.
        
        @@@Text To .Code Noshow Textmerge
Do ('##InstallFolder##FoxTabs.APP')
        @@@Endtext

        llRegister = .Register()

    Endwith
    
EndText
lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

* Set the properties of the passed updater object. You likely won't need to edit this code.

with toUpdateObject
	.ApplicationName      = lcAppName
	.Component            = 'No'
	.VersionLocalFilename = lcAppID + 'VersionFile.txt'
	.RegisterWithThor     = lcRegisterWithThor
	.VersionFileURL       = lcVersionFileURL
	.SourceFileUrl        = lcZIPFileURL
	.Link                 = lcRepositoryURL
	.LinkPrompt           = lcAppName + ' Home Page'
	.Notes                = GetNotes()
endwith
return toUpdateObject

* Get the notes for the project. Edit this code as necessary.

Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
FoxTabs is a handy little utility for adding a tabbed window interface to the VFP IDE. It is written in VFP and uses 
BindEvents heavily. With the limited space available in the VFP IDE, it can be time consuming to find and switch 
among open windows. FoxTabs makes it easier to find the correct editor or designer you have open.

FoxTabs is a project originally started in Australia by Scott Scovell and Craig Bailey. Their generosity made the 
move to VFPX simple and allows the development to progress. Thanks to both!
    EndText   
    Return lcNotes
EndProc
