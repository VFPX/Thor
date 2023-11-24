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

lcRepositoryURL   = 'https://github.com/tbleken/Pandora'
	&& the URL for the project's repository
* Note: If you use a more recent version of git, your default branch may not be "master".
lcDownloadsBranch = 'master'
lcDownloadsURL    = strtran(m.lcRepositoryURL, 'github.com', ;
	'raw.githubusercontent.com') + '/' + m.lcDownloadsBranch + '/ThorUpdater/'
lcVersionFileURL  = m.lcDownloadsURL + 'PandoraVersion.txt' &&'PandoraVersion.txt'
	&& the URL for the file containing code to get the available version number
lcZIPFileURL      = m.lcDownloadsURL + 'Pandora.zip'
	&& the URL for the zip file containing the project

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('Pandora installed', 0 ,"Pandora installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

* Set the properties of the passed updater object.

with m.toUpdateObject
	.ApplicationName      = 'Pandora'
	.VersionLocalFilename = 'PandoraVersionFile.txt'
	.VersionFileURL       = m.lcVersionFileURL
	.SourceFileUrl        = m.lcZIPFileURL
	.Component            = 'No'
	.Link                 = m.lcRepositoryURL
	.LinkPrompt           = 'Pandora Home Page'
	.ProjectCreationDate  = date(2023, 9, 20)
	.RegisterWithThor     = m.lcRegisterWithThor
	.InstallInTools	      = .T.
	.Dependencies		  = ''
endwith

return m.toUpdateObject

*created by VFPX Deployment, 9/20/2023 4:51:50 PM