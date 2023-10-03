Lparameters loUpdateObject

Local loException

With m.loUpdateObject

	.AppName			  = 'GoFish.APP'
	.ApplicationName	  = 'GoFish'
	.ToolName			  = 'Thor_Tool_GoFish5'
	.SourceFileURL		  = 'https://raw.githubusercontent.com/VFPX/GoFish/master/Source/Source.zip'
	.Component			  = 'No'
	.VersionLocalFilename = 'GoFishVersionFile.txt'
	.RegisterWithThor	  = 'Do "##InstallFolder##GoFish.APP" with "Thor", .T.'
	.Link				  = 'https://github.com/VFPX/GoFish'
	.VersionFileURL		  = 'https://raw.githubusercontent.com/VFPX/GoFish/master/_GoFishVersionFile.txt'

Endwith

Try
	GetVersionFileFromOldFolder()
Catch To m.loException

Endtry


Return m.loUpdateObject



Procedure GetVersionFileFromOldFolder

	* one time event, copying version file from old GoFish5 folder to new GoFish folder
	* so that CFU will recognize it

	Local lcAPPFolder, lcNewFolder, lcOldFolder, lcVersionFile

	lcAPPFolder	  = _Screen.cThorFolder + 'Tools\Apps\'
	lcOldFolder	  = m.lcAPPFolder + 'GoFish5\'
	lcNewFolder	  = m.lcAPPFolder + 'GoFish\'
	lcVersionFile = 'GoFishVersionFile.txt'

	If File(m.lcNewFolder + m.lcVersionFile)
		Return
	Endif

	If Not File(m.lcOldFolder + m.lcVersionFile)
		Return
	Endif

	If Not Directory(m.lcNewFolder)
		Mkdir (m.lcNewFolder)
	Endif

	Copy File (m.lcOldFolder + m.lcVersionFile) To (m.lcNewFolder + m.lcVersionFile)

Endproc
