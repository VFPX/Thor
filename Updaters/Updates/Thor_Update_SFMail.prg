lparameters toUpdateObject
local lcRepositoryURL, ;
	lcDownloadsURL, ;
	lcVersionFileURL, ;
	lcZIPFileURL, ;
	lcRegisterWithThor

* Get the URL for the version and ZIP files.

lcRepositoryURL  = 'https://github.com/DougHennig/SFMail'
	&& the URL for the project's repository
lcDownloadsURL   = strtran(lcRepositoryURL, 'github.com', ;
	'raw.githubusercontent.com') + '/master/ThorUpdater/'
lcVersionFileURL = lcDownloadsURL + 'SFMailVersion.txt'
	&& the URL for the file containing code to get the available version number
lcZIPFileURL     = lcDownloadsURL + 'SFMail.zip'
	&& the URL for the zip file containing the project

* Set the properties of the passed updater object.

with toUpdateObject
	.ApplicationName      = 'SFMail'
	.VersionLocalFilename = 'SFMailVersionFile.txt'
	.VersionFileURL       = lcVersionFileURL
	.SourceFileUrl        = lcZIPFileURL
	.Component            = 'Yes'
	.Link                 = lcRepositoryURL
	.LinkPrompt           = 'SFMail Home Page'
	.ProjectCreationDate  = date(2021, 2, 4)
endwith
return toUpdateObject
