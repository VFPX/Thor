Lparameters loUpdateObject

With loUpdateObject
    .AppName              = 'Thor.App'
    .ApplicationName      = 'Thor'
    .ToolName             = 'Thor_Tool_ThorInternalEdit'
    .VersionFileURL       = 'https://raw.githubusercontent.com/VFPX/Thor/master/ThorUpdater/_ThorVersionFile.txt'
    .VersionLocalFilename = 'Thor\ThorVersion.txt'
    .RegisterWithThor     = 'Do "##InstallFolder##Thor.APP" with "Install"'
    .SourceFileURL        = 'Thor_Source.Zip = https://raw.githubusercontent.com/VFPX/Thor/master/ThorUpdater/Thor.zip'
    .Link                 = 'https://github.com/VFPX/Thor'
    .LinkPrompt           = 'Thor Home Page'
Endwith

AddProperty(loUpdateObject, 'UnzipAfterDownload', 'Yes')    

Return loUpdateObject
