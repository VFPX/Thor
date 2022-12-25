Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"SCCTextX installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'SCCTextX'
    .Component            = 'Yes'
    .VersionLocalFilename = 'SCCTextXVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .AvailableVersion     = 'SCCTextX - 1 - Nov. 12, 2008 - 20081112'
    .SourceFileUrl        = 'https://github.com/VFPX/AlternateSCCText/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/AlternateSCCText'
    .LinkPrompt           = 'SCCTextX Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
A new and improved version of the source code control to text program included with Visual Foxpro.

Why to use: Consistent and case insensitive sorting of methods, objects, and properties, resulting in much less comparison errors when doing a Diff. Bugfixes and speed improvements, several language localisations.
How to use: Just copy this prg into your HOME() folder and change the entry "Text Generation" under SysMenu/Tools/Options/Projects to point to that new file.

We decided to change the name from the old PL_SCCTEXT to SccTextX, so that it follows the standard FoxPro naming conventions ;) for enhanced versions. (In case you wonder where that PL stems from: It was our internal version here at my company ProLib). 

This version is already the result of several helpful community members who over the years helped to enhance that first Microsoft release to the current level:
    Mark Wilden
    Markus Winhard
    Frank Camp
    Beth Massi
    Francis Faure
    Fernando D. Bozzo
There are several improvements coming:

Incorporate more languages (German, Spanish, French and English are already included)
Clean up the code to use modern builtin functions instead longwinded helper procedures
therefor VFP9.x only supported
Cleaner and faster GUI

So, if you have other language translations ready, or have some more ideas for this routine, please send them to juergen(at)wondzinski.de !

wOOdy
    EndText
    Return lcNotes
EndProc
