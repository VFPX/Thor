Lparameters loUpdateObject



With loUpdateObject

    .AppName          = 'GoFish5.APP'

    .ApplicationName  = 'GoFishClassic'

    .ToolName         = 'Thor_Tool_GoFishClassic'

    .SourceFileUrl        = 'https://raw.githubusercontent.com/VFPX/GoFishClassic/master/InstalledFiles.zip'

    .Component            = 'No'

    .VersionLocalFilename   = 'GoFishClassicVersionFile.txt'

    .RegisterWithThor     = 'Do "##InstallFolder##GoFishClassic.APP" with "Thor", .T.'

    .Link               = 'https://github.com/VFPX/GoFishClassic'

	.VersionFileURL		  = 'https://raw.githubusercontent.com/VFPX/GoFishClassic/master/_GoFishClassicVersionFile.txt'
	
	.ProjectCreationDate  = Date(2023, 1, 31)



Endwith

Return loUpdateObject



