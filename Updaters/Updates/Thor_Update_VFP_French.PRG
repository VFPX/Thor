Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"VFP 9.0 Localization in French installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'VFP 9.0 Localization in French'
    .Component            = 'Yes'
    .VersionLocalFilename = 'VFP9FrenchVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .AvailableVersion     = 'VFP 9.0 Localization in French - 1.02 - Mar. 29, 2010 - 20100329'
    .SourceFileUrl        = 'https://github.com/VFPX/FrenchLocalization/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/FrenchLocalization'
    .LinkPrompt           = 'VFP 9.0 Localization in French Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
La localisation de L'IDE est produite conjointement avec l'équipe de M Rainer Becker : le "Deutschsprachige FoxPro User Group" http://portal.dfpug.de
(The localization of the VFP9 IDE has been done with the team of M Rainer Becker of the dfpug)

Comment installer ? (How to Install?)
L'installation se fait par la copie de la DLL VFP9FRA.DLL dans votre dossier Visual Foxpro 9 
(the installation is done with the copy of the vfp9fra.dll in the vfp9 folder)

Comment Désinstaller ? (How to uninstall ?)
La désinstallation se fait par la suppression de la DLL : VFP9FRA.DLL de votre dossier Visual Foxpro 9 
(to uninstall, just remove the dll VFP9FRA.DLL)
    EndText
    Return lcNotes
EndProc
