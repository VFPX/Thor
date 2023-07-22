lparameters toUpdateObject
local lcRepositoryURL, ;
	lcDownloadsURL, ;
	lcVersionFileURL, ;
	lcZIPFileURL, ;
	lcRegisterWithThor

* Get the URL for the version and ZIP files.

lcRepositoryURL  = 'https://github.com/VFPX/GoToDefinition'
	&& the URL for the project's repository
lcDownloadsURL   = strtran(lcRepositoryURL, 'github.com', ;
	'raw.githubusercontent.com') + '/master/ThorUpdater/'
lcVersionFileURL = lcDownloadsURL + 'GoToDefinitionVersion.txt'
	&& the URL for the file containing code to get the available version number
lcZIPFileURL     = lcDownloadsURL + 'GoToDefinition.zip'
	&& the URL for the zip file containing the project

* Set the properties of the passed updater object.

with toUpdateObject
	.ApplicationName      = 'GoToDefinition'
	.VersionLocalFilename = 'GoToDefinitionVersionFile.txt'
	.VersionFileURL       = lcVersionFileURL
	.SourceFileUrl        = lcZIPFileURL
	.Link                 = lcRepositoryURL
	.LinkPrompt           = 'GoToDefinition Home Page'
	.ProjectCreationDate  = date(2023, 1, 27)
	.InstallInTools	      = .T.
	.Dependencies		  = 'IntellisenseX'
endwith
return toUpdateObject
