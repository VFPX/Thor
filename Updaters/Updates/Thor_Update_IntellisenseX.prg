lparameters toUpdateObject
local lcRepositoryURL, ;
	lcDownloadsURL, ;
	lcVersionFileURL, ;
	lcZIPFileURL, ;
	lcRegisterWithThor

* Get the URL for the version and ZIP files.

lcRepositoryURL  = 'https://github.com/VFPX/IntellisenseX'
	&& the URL for the project's repository
lcDownloadsURL   = strtran(lcRepositoryURL, 'github.com', ;
	'raw.githubusercontent.com') + '/master/ThorUpdater/'
lcVersionFileURL = lcDownloadsURL + 'IntellisenseXVersion.txt'
	&& the URL for the file containing code to get the available version number
lcZIPFileURL     = lcDownloadsURL + 'IntellisenseX.zip'
	&& the URL for the zip file containing the project

* Set the properties of the passed updater object.

with toUpdateObject
	.ApplicationName      = 'IntellisenseX'
	.VersionLocalFilename = 'IntellisenseXVersionFile.txt'
	.VersionFileURL       = lcVersionFileURL
	.SourceFileUrl        = lcZIPFileURL
	.Link                 = lcRepositoryURL
	.LinkPrompt           = 'IntellisenseX Home Page'
	.InstallInTools	      = .T.
	.Dependencies		  = 'GoToDefinition'
endwith
return toUpdateObject
