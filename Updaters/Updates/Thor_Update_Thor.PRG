#Define     ccThor_URL               'lscheffler/Thor'
#Define     ccThor_Branch            '/dev'
*!*	#Define     ccThor_URL               'VFPX/Thor'
*!*	#Define     ccThor_Branch            '/master'

Lparameters loUpdateObject

With loUpdateObject
    .AppName              = 'Thor.App'
    .ApplicationName      = 'Thor'
    .ToolName             = 'Thor_Tool_ThorInternalEdit'
*SF 20231130 Change fixed URL to #DEFINE
*    .VersionFileURL       = 'https://raw.githubusercontent.com/VFPX/Thor/master/ThorUpdater/_ThorVersionFile.txt'
    .VersionFileURL       = 'https://raw.githubusercontent.com/'+ccThor_URL+ccThor_Branch+'/ThorUpdater/_ThorVersionFile.txt'
*/SF 20231130 Change fixed URL to #DEFINE
    .VersionLocalFilename = 'Thor\ThorVersion.txt'
    .RegisterWithThor     = 'Do "##InstallFolder##Thor.APP" with "Install"'
*SF 20231130 Change fixed URL to #DEFINE
*    .SourceFileURL        = 'Thor_Source.Zip = https://raw.githubusercontent.com/VFPX/Thor/master/ThorUpdater/Thor.zip'
*    .Link                 = 'https://github.com/VFPX/Thor'
    .SourceFileURL        = 'Thor_Source.Zip = https://raw.githubusercontent.com/'+ccThor_URL+ccThor_Branch+'/ThorUpdater/Thor.zip'
    .Link                 = 'https://github.com/'+ccThor_URL
*/SF 20231130 Change fixed URL to #DEFINE
    .LinkPrompt           = 'Thor Home Page'
Endwith

AddProperty(loUpdateObject, 'UnzipAfterDownload', 'Yes')    

Return loUpdateObject
