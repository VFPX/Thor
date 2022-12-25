#Define VersionFileName 'IntellisenseXVersionFile.txt'
Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    Erase (_screen.Cthorfolder + '\Tools\Procs\beautify.h')
    Erase (_screen.Cthorfolder + '\Tools\Procs\beautifyx.h')
    Erase (_screen.Cthorfolder + '\Tools\Procs\THOR_PROC_ISX.h')
EndText

With loUpdateObject
    .ApplicationName      = 'IntellisenseX'
    .ToolName             = 'Thor_Tool_ThorInternalRepository'
    .VersionNumber        = '1.22'
    .VersionDate          = Date(2022, 06, 04)
    .SourceFileUrl        = 'https://raw.githubusercontent.com/VFPX/IntelliSenseX/master/Source.zip'
    .VersionLocalFilename = VersionFileName
    .RegisterWithThor     = lcRegisterWithThor
    .Notes                = GetNotes()
    .Link                 = 'https://github.com/VFPX/IntelliSenseX'
    .LinkPrompt           = 'IntellisenseX Home Page'
Endwith

AddProperty(loUpdateObject, 'UpdateNowIfNotInstalled', 'Yes')    

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow

    EndText
    Return lcNotes
EndProc
