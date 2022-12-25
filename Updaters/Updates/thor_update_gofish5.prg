Lparameters loUpdateObject

With loUpdateObject
    .AppName          = 'GoFish5.APP'
    .ApplicationName  = 'GoFish5'
    .ToolName         = 'Thor_Tool_GoFish5'
    .SourceFileUrl        = 'https://raw.githubusercontent.com/VFPX/GoFish/master/Source/Source.zip'
    .Component            = 'No'
    .VersionLocalFilename   = 'GoFishVersionFile.txt'
    .RegisterWithThor     = 'Do "##InstallFolder##GoFish5.APP" with "Thor", .T.'
    .Link               = 'https://github.com/VFPX/GoFish'
	.VersionFileURL		  = 'https://raw.githubusercontent.com/VFPX/GoFish/master/_GoFishVersionFile.txt'

Endwith

Return loUpdateObject

