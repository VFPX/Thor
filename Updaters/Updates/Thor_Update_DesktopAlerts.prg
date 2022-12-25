Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"DesktopAlerts installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'DesktopAlerts'
    .Component            = 'Yes'
    .VersionLocalFilename = 'DesktopAlertsVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .AvailableVersion     = 'DesktopAlerts - 1.0.2 - Sept. 15, 2012 - 20120915'
    .SourceFileUrl        = 'https://github.com/VFPX/DesktopAlerts/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/DesktopAlerts'
    .LinkPrompt           = 'DesktopAlerts Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
Outlook-style Desktop Alerts for VFP applications.

The Desktop Alerts project, managed by Kevin Ragsdale, provides VFP developers with a reliable mechanism to 
add Outlook-style Desktop Alerts to VFP applications.

If you are interested in helping Kevin on this project, please contact him at kevinragsdale@charter.net.
    EndText
    Return lcNotes
EndProc
