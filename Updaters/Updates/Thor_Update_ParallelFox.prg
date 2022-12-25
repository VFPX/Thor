Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Messagebox('From the Thor menu, see "More -> Open Folder -> Components"', 0 ,"ParallelFox installed", 5000)

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'ParallelFox'
    .Component            = 'Yes'
    .VersionLocalFilename = 'ParallelFoxVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .AvailableVersion     = 'ParallelFox - 1.2 - Jan. 12, 2012 - 20120112'
    .SourceFileUrl        = 'https://github.com/VFPX/ParallelFox/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/ParallelFox'
    .LinkPrompt           = 'ParallelFox Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
Parallel Processing Library for Visual FoxPro

Project Manager: Joel Leach

ParallelFox is a parallel processing library for Visual FoxPro 9.0.

Although parallel processing and multi-threading have been possible in VFP for quite some time 
(particularly in web servers), the goal of this project is the same as parallel processing 
libraries that have been popping up for other development platforms. That is, to make parallel 
processing easier and more approachable, without all of the headaches typically associated 
with multi-threaded programming. This has become more important as multi-core desktop and 
server machines have become widespread.
    EndText
    Return lcNotes
EndProc
