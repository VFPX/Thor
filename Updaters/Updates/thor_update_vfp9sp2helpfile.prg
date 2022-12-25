Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    Run /N "##InstallFolder##dv_foxhelp_vfp9sp2_v1.08.exe"

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'VFP9SP2HelpFile'
    .Component            = 'Yes'
    .VersionLocalFilename = 'VFP9SP2HelpFileVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .AvailableVersion     = 'VFP9SP2HelpFile - 1.08 - August 22, 2017 - 20170822'
    .SourceFileUrl        = 'https://github.com/VFPX/HelpFile/raw/master/setup/dv_foxhelp_vfp9sp2_v1.08.exe_signed.zip'
    .Link                 = 'https://github.com/VFPX/HelpFile'
    .LinkPrompt           = 'VFP9 SP2 Help File Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
The Visual FoxPro 9 SP2 Help file corrected, supported, and enhanced.
Project Manager: Francis Faure

Ownership transfer of the VFP 9 SP2 Help file source code and rights to change from Microsoft to VFP Community 
via Creative Commons licensing.

What are the goals of this project?
1) Provide corrected VFP 9 SP2 Help file to the VFP Community. Corrections to the Help file include corrected 
index, corrected hyperlinks, and corrected stylesheet.

2) Allow the VFP Community to further enhance the Help file moving forward, adding missing content for VFP 9 SP2 
and Sedna, making necessary corrections to existing examples, and repairing additional things missing in the index (like the SYS() functions).

    EndText
    Return lcNotes
EndProc
