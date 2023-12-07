lparameters;
	toUpdateObject
local;
	lcRepositoryURL    as string, ;
	lcDownloadsBranch  as string, ;
	lcDownloadsURL     as string, ;
	lcVersionFileURL   as string, ;
	lcZIPFileURL       as string, ;
	lcRegisterWithThor as string

* Get the URL for the version and ZIP files.

lcRepositoryURL   = 'https://github.com/lscheffler/bin2text'
	&& the URL for the project's repository
* Note: If you use a more recent version of git, your default branch may not be "master".
lcDownloadsBranch = 'main'
lcDownloadsURL    = strtran(m.lcRepositoryURL, 'github.com', ;
	'raw.githubusercontent.com') + '/' + m.lcDownloadsBranch + '/ThorUpdater/'
lcVersionFileURL  = m.lcDownloadsURL + 'Version.txt' &&'Bin2TextVersion.txt'
	&& the URL for the file containing code to get the available version number
lcZIPFileURL      = m.lcDownloadsURL + 'Bin2Text.zip'
	&& the URL for the zip file containing the project


text to lcRegisterWithThor noshow textmerge
	messagebox('From the Thor menu, choose "More -> Open Folder -> Components" to see the folder where Bin2Text was installed', 0, 'Bin2Text Installed', 5000)
endtext

* Set the properties of the passed updater object.

with m.toUpdateObject
	.ApplicationName      = 'Bin2Text'
	.VersionLocalFilename = 'Bin2TextVersionFile.txt'
	.VersionFileURL       = m.lcVersionFileURL
	.SourceFileUrl        = m.lcZIPFileURL
	.Component            = 'Yes'
	.Link                 = m.lcRepositoryURL
	.LinkPrompt           = 'Bin2Text Home Page'
	.ProjectCreationDate  = date(2023, 5, 20)
	.RegisterWithThor     = m.lcRegisterWithThor
endwith

return m.toUpdateObject

*created by VFPX Deployment, 20.05.2023 16:58:25