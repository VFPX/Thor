*File to control Thor CFU for application VFPEncryptionFLL
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

lcRepositoryURL   = 'https://github.com/VFPX/VFPEncryptionFLL'
	&& the URL for the project's repository
lcDownloadsBranch = 'main'
lcDownloadsURL    = strtran(m.lcRepositoryURL, 'github.com', ;
	'raw.githubusercontent.com') + '/' + m.lcDownloadsBranch + '/ThorUpdater/'
lcVersionFileURL  = m.lcDownloadsURL + 'VFPEncryptionFLLVersion.txt' &&'VFPEncryptionFLLVersion.txt'
	&& the URL for the file containing code to get the available version number
lcZIPFileURL      = m.lcDownloadsURL + 'VFPEncryptionFLL.zip'
	&& the URL for the zip file containing the project


text to lcRegisterWithThor noshow textmerge
	messagebox('From the Thor menu, choose "More -> Open Folder -> Components" to see the folder where VFPEncryptionFLL was installed', 0, 'VFPEncryptionFLL Installed', 5000)
endtext

* Set the properties of the passed updater object.

with m.toUpdateObject
	.ApplicationName      = 'VFPEncryptionFLL'
	.VersionLocalFilename = 'VFPEncryptionFLLVersionFile.txt'
	.VersionFileURL       = m.lcVersionFileURL
	.SourceFileUrl        = m.lcZIPFileURL
	.Component            = 'Yes'
	.Link                 = m.lcRepositoryURL
	.LinkPrompt           = 'VFPEncryptionFLL Home Page'
	.ProjectCreationDate  = date(2026, 10, 30)
	.Dependencies         = ''	&& a comma or space delimited list of other Thor applications (ApplicationName) that this project depends on
	.RegisterWithThor     = m.lcRegisterWithThor

endwith

return m.toUpdateObject

*created by VFPX Deployment, 10/30/2026 12:11:50 PM