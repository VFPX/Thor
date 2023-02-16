Lparameters loUpdateObject

With loUpdateObject
    .AppName              = 'PEMEditor.APP'
    .ApplicationName      = 'PEM Editor'
    .ToolName             = 'Thor_Tool_PEME_GoToDefinition'
    .VersionFileURL       = 'https://raw.githubusercontent.com/VFPX/PEMEditor/master/ThorUpdater/PEMEditorVersion.txt'
    .VersionLocalFilename = 'PEM Editor Version.txt'
    .RegisterWithThor     = 'Do "##InstallFolder##PEMEditor.APP" with "Thor"'
    .ShowErrorMessage     = 'No'
    .SourceFileURL        = 'https://raw.githubusercontent.com/VFPX/PEMEditor/master/ThorUpdater/PEMEditor.zip'
    .Link                 = 'https://github.com/VFPX/PEMEditor'
    .LinkPrompt           = 'PEM Editor Home Page'
Endwith

AddProperty(loUpdateObject, 'UpdateNowIfNotInstalled', 'Yes')    

Return loUpdateObject

