lparameters;
	toUpdateObject
local;
	lcRepositoryURL    as string, ;
	lcDownloadsURL     as string, ;
	lcVersionFileURL   as string, ;
	lcZIPFileURL       as string, ;
	lcRegisterWithThor as string

* Get the URL for the version and ZIP files.
*SET STEP ON 
lcRepositoryURL  = 'https://github.com/lscheffler/sf_regexp'
	&& the URL for the project's repository
lcDownloadsURL   = strtran(m.lcRepositoryURL, 'github.com', ;
	'raw.githubusercontent.com') + '/main/ThorUpdater/'
lcVersionFileURL = m.lcDownloadsURL + 'SFRegExpVersion.txt'
	&& the URL for the file containing code to get the available version number
lcZIPFileURL     = m.lcDownloadsURL + 'SFRegExp.zip'
	&& the URL for the zip file containing the project

* Set the properties of the passed updater object.

with m.toUpdateObject
	.ApplicationName      = 'SF RegExp'
	.VersionLocalFilename = 'SFRegExpVersionFile.txt'
	.VersionFileURL       = m.lcVersionFileURL
	.SourceFileUrl        = m.lcZIPFileURL
	.Component            = 'Yes'
	.Link                 = m.lcRepositoryURL
	.LinkPrompt           = 'SF RegExp Home Page'
	.ProjectCreationDate  = date(2023, 5, 18)
endwith

return m.toUpdateObject
