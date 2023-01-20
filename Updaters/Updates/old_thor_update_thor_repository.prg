#Define VersionFileName 'ThorRepositoryVersionFile.txt'
Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    *Remove some old, no longer suppported tools
    Local loThor

    * Main Thor Engine
    Try
        loThor        = Execscript (_Screen.cThorDispatcher, 'Thor Engine=')
        loThor.RemoveTool ('Thor_Tool_Repository_SetRevisionDate')
        loThor.RemoveTool ('Thor_Tool_Repository_Sample_ModifySelectedText')
        loThor.RemoveTool ('Thor_Tool_PEME_OpenProject')
    Catch
    EndTry

    Erase (_screen.Cthorfolder + '\Tools\Procs\beautify.h')
    Erase (_screen.Cthorfolder + '\Tools\Procs\beautifyx.h')
    Erase (_screen.Cthorfolder + '\Tools\Procs\THOR_PROC_ISX.h')

EndText

With loUpdateObject
    .ApplicationName      = 'ThorRepository'
    .ToolName             = 'Thor_Tool_ThorInternalRepository'
    .VersionLocalFilename = VersionFileName
    .RegisterWithThor     = lcRegisterWithThor
    .Notes                = GetNotes()
    .Link                 = 'https://github.com/VFPX/ThorRepository'
    .LinkPrompt           = 'Thor Repository Home Page'

    .VersionNumber        = '62.06'
    .VersionDate          = Date(2022, 04, 01)
    .SourceFileUrl        = 'https://raw.githubusercontent.com/VFPX/ThorRepository/master/Source/Thor_Repository.zip'
Endwith

AddProperty(loUpdateObject, 'UpdateNowIfNotInstalled', 'Yes')    

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
The Thor Repository is a collection of IDE tools, accessible thru Thor, 
that have been written by members of the FoxPro community.

You are encouraged to modify and enhance these tools and also to create
your own tools using these tools as samples.  

To edit an existing tool, find it in Thor’s configuration form and click 
‘Edit Tool’.  This will create a copy of the tool for you in your ‘My Tools’ 
folder.  Thereafter, it will be accessible to you thru the MRU list for PRGs.

If you have created a new tool that you think would be of interest to the
FoxPro community, or have made enhancements or corrections to existing tools,
please submit them to be shared with the rest of the VFP community.

Tools can be submitted to this address (the community form for Thor
and the Thor Repository): FoxProThor@googlegroups.com 

Tools will be accepted into the Repository if they meet some minimum 
standards, which include:

    They must act as designed and described.
    They must have no undesirable side effects.
    They must not make assumptions about file locations (such as folder names, 
        other than system folders)
    They must follow the standard Thor-Tool format for a PRG, and their 
        description must be as complete as possible.


EndText
    Return lcNotes
EndProc
