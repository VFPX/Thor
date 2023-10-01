Lparameters loUpdateObject



With loUpdateObject

    .AppName          = 'GoFish.APP'

    .ApplicationName  = 'GoFish'

    .ToolName         = 'Thor_Tool_GoFish'

    .SourceFileUrl        = 'https://raw.githubusercontent.com/VFPX/GoFish/master/Source/Source.zip'

    .Component            = 'No'

    .VersionLocalFilename   = 'GoFishVersionFile.txt'

    .RegisterWithThor     = 'Do "##InstallFolder##GoFish.APP" with "Thor", .T.'

    .Link               = 'https://github.com/VFPX/GoFish'

	.VersionFileURL		  = 'https://raw.githubusercontent.com/VFPX/GoFish/master/_GoFishVersionFile.txt'



Endwith



Return loUpdateObject



