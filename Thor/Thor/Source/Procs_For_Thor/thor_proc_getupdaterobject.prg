Local loUpdaterObject As 'clsUpdaterObject'
loUpdaterObject = Createobject ('clsUpdaterObject')
Execscript (_Screen.cThorDispatcher, 'Result=', loUpdaterObject)
Return

Define Class clsUpdaterObject As Custom

	* Properties to be defined in Updater PRGs
	APPName				 = '' && Name of the APP file
	ApplicationName		 = '' && Name of the application
	ToolName			 = '' && Name of the tool used to determine where the APP is stored
	Component            = 'No'
	FindInstalledVersion = 'No'
	VersionFileURL		 = '' && URL of the version file in the cloud
	VersionLocalFilename = '' && Name of the local version file
	RegisterWithThor	 = '' && To be executed to register this APP with Thor
	ShowErrorMessage	 = 'Yes'
	UnzipAfterDownload	 = 'Yes'
	SourceZipURL		 = '' && URL for the zip of source files
	LocalSourceZip       = ''
	NeverUpdateFile		 = ''
	UpdateNowIfNotInstalled = 'No'	
	ProjectCreationDate  = Date(2001,1,1)

	* Properties used along the way by the updater process
	File			   = ''
	InstallationFolder = ''
	LocalVersionFile   = ''

	CurrentVersion	 = ''
	ErrorMessage	 = ''
	ErrorCode		 = 0
	NeverUpdate		 = 'No'
	AlreadyInstalled = 'No'
	FromMyUpdates    = 'Yes'

	* Properties set by the cloud version file
	AvailableVersion	   = ''
	VersionNumber		   = ''
	VersionDate			   = {//}
	AvailableVersionDate   = ''
	AvailableVersionNumber = ''
	SourceFileURL		   = ''
	Notes				   = ''
	Link				   = ''
	LinkPrompt			   = ''

Enddefine

