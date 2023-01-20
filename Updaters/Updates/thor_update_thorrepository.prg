lparameters toUpdateObject
local lcRepositoryURL, ;
	lcDownloadsURL, ;
	lcVersionFileURL, ;
	lcZIPFileURL, ;
	lcRegisterWithThor

* Get the URL for the version and ZIP files.

lcRepositoryURL  = 'https://github.com/VFPX/ThorRepository'
	&& the URL for the project's repository
lcDownloadsURL   = strtran(lcRepositoryURL, 'github.com', ;
	'raw.githubusercontent.com') + '/master/ThorUpdater/'
lcVersionFileURL = lcDownloadsURL + 'ThorRepositoryVersion.txt'
	&& the URL for the file containing code to get the available version number
lcZIPFileURL     = lcDownloadsURL + 'ThorRepository.zip'
	&& the URL for the zip file containing the project

* Set the properties of the passed updater object.

with toUpdateObject
	.ApplicationName      = 'Thor Repository'
	.VersionLocalFilename = 'ThorRepositoryVersionFile.txt'
	.VersionFileURL       = lcVersionFileURL
	.SourceFileUrl        = lcZIPFileURL
	.Link                 = lcRepositoryURL
	.LinkPrompt           = 'Thor Repository Home Page'
	.InstallInTools	      = .T.	
endwith
return toUpdateObject
