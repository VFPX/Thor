Local loUpdaterObject As 'clsUpdaterObject'
loUpdaterObject = Createobject ('clsUpdaterObject')
Execscript (_Screen.cThorDispatcher, 'Result=', loUpdaterObject)
Return

Define Class clsUpdaterObject As Custom

	* If no VersionFileURL, then all properties in sets [1] - [3] 
	*	are to be defined in the Updater
	
	* If there is a VersionFileURL 
	*	set [1] must be in the updater
	*	set [2] normally appears in the updater
	*	set [3] normally appears in the version file
	
	* Any properties set in the updater can be over-ridden in the version file
	
	* [1] Properties that must be defined in updater
	ApplicationName		 = '' && Name of the application
	VersionFileURL		 = '' && URL of the version file in the cloud

	* [2] Properties that normally appear in the updater
	AppID			   	 = ''
	APPName				 = '' && Name of the APP file
	ToolName			 = '' && Name of the tool used to determine where the APP is stored
	Component            = 'No'
	FindInstalledVersion = 'No'
	VersionLocalFilename = '' && Name of the local version file
	RegisterWithThor	 = '' && To be executed to register this APP with Thor
	ShowErrorMessage	 = 'Yes'
	UnzipAfterDownload	 = 'Yes'
	SourceZipURL		 = '' && URL for the zip of source files
	LocalSourceZip       = ''
	NeverUpdateFile		 = ''
	UpdateNowIfNotInstalled = 'No'	
	ProjectCreationDate  = Date(2001,1,1)
	InstallInTools		 = .F.
	Link				 = ''
	LinkPrompt			 = ''
	Dependencies		 = ''

	* [3] Properties that normally appear in the version file
	AvailableVersion	   = ''
	VersionNumber		   = ''
	VersionDate			   = {//}
	AvailableVersionDate   = ''
	AvailableVersionNumber = ''
	SourceFileURL		   = ''
	Notes				   = ''

	* [4] Properties used along the way by the updater process
	File			   = ''
	InstallationFolder = ''
	LocalVersionFile   = ''

	CurrentVersion	 = ''
	ErrorMessage	 = ''
	ErrorCode		 = 0
	NeverUpdate		 = 'No'
	AlreadyInstalled = 'No'
	FromMyUpdates    = 'Yes'

Enddefine

