*File to control Thor CFU for application pdfium-vfp
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

lcRepositoryURL   = 'https://github.com/dmitriychunikhin/pdfium-vfp'
	&& the URL for the project's repository
* Note: If you use a more recent version of git, your default branch may not be "master".
lcDownloadsBranch = 'main'
lcDownloadsURL    = strtran(m.lcRepositoryURL, 'github.com', ;
	'raw.githubusercontent.com') + '/' + m.lcDownloadsBranch + '/ThorUpdater/'
lcVersionFileURL  = m.lcDownloadsURL + 'pdfium-vfpVersion.txt' &&'pdfium-vfpVersion.txt'
	&& the URL for the file containing code to get the available version number
lcZIPFileURL      = m.lcDownloadsURL + 'pdfium-vfp.zip'
	&& the URL for the zip file containing the project


text to lcRegisterWithThor noshow textmerge
	messagebox('From the Thor menu, choose "More -> Open Folder -> Components" to see the folder where pdfium-vfp was installed', 0, 'pdfium-vfp Installed', 5000)
endtext

* Set the properties of the passed updater object.

with m.toUpdateObject
	.ApplicationName      = 'pdfium-vfp'
	.VersionLocalFilename = 'pdfium-vfpVersionFile.txt'
	.VersionFileURL       = m.lcVersionFileURL
	.SourceFileUrl        = m.lcZIPFileURL
	.Component            = 'Yes'
	.Link                 = m.lcRepositoryURL
	.LinkPrompt           = 'pdfium-vfp github'
	.ProjectCreationDate  = date(2024, 7, 20)
	.Dependencies         = ''	&& a comma or space delimited list of other Thor applications (ApplicationName) that this project depends on
	.RegisterWithThor     = m.lcRegisterWithThor

endwith

return m.toUpdateObject

*created by VFPX Deployment, 20.07.24 02:11:37