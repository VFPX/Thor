Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"TabbingNavigation installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'TabbingNavigation'
    .Component            = 'Yes'
    .VersionLocalFilename = 'TabbingNavigationVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .AvailableVersion     = 'TabbingNavigation - Alpha2 - May 18, 2009 - 20090518'
    .SourceFileUrl        = 'https://github.com/VFPX/TabbingNavigation/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/TabbingNavigation'
    .LinkPrompt           = 'TabbingNavigation Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
A suite of controls created to improve the UI of your Visual FoxPro applications.

Project Manager: Emerson Santon Reed emerson_reed@hotmail.com

OutlookNavBar, formerly known as the Outlook2003Bar, is a very cool component 
included in this suite. It resembles the Outlook panel interface, making it 
perfect for grouping similar items in an application's UI. You’ll find working 
with the OutlookNavBar similar to working with a pageframe. It’s incredibly 
easy to use, and I think you'll agree that the results are amazing.
    EndText
    Return lcNotes
EndProc
