#Define	ccThorToolName 'Thor_Tool_ZProc'
#Define	CR Chr[13]

Lparameters loUpdateObject

Text to lcRegisterWithThor NoShow TextMerge
    
    * Create tool under VFPx
    loThorInfo = Execscript (_Screen.cThorDispatcher, 'Thor Register=')

    With loThorInfo
        * Required
        .PRGName       = ccThorToolName
        .FolderName    = '##InstallFolder##'
        .Prompt        = 'zProc, zVFP, and zCOM IntelliSense Scripts'
        
        * Optional
        .Description   = 'zProc, zVFP, and zCOM IntelliSense Scripts'

        * These are used to group and sort tools when they are displayed in menus or the Thor form
        .Category      = 'Code|Misc.'
		.CanRunAtStartUp = .F.
        
        @@@Text To .Code Noshow Textmerge
Do ('##InstallFolder##Install_ZProc.PRG')
        @@@Endtext

        llRegister = .Register()

    Endwith

    lnResponse = Messagebox('Thor tool "zProc, zVFP, and zCOM IntelliSense Scripts" created' + CR + CR + 'Install now?', 3 ,"ZProc downloaded", 60000)
    
    If lnResponse = 6
    	Do ('##InstallFolder##Install_ZProc.PRG')
    EndIf 

EndText

lcRegisterWithThor = Strtran(lcRegisterWithThor, '@@@')

With loUpdateObject
    .ApplicationName      = 'ZProc'
    .VersionLocalFilename = 'ZProcVersionFile.txt'
    .RegisterWithThor     = lcRegisterWithThor
    
    .AvailableVersion     = 'ZProc 1.00 - 1.00 - July 6, 2010 - 20100706'
    .SourceFileUrl        = 'https://github.com/VFPX/zProc-zVFP-zCOM-IntelliSenseScripts/archive/refs/heads/master.zip'
    .Link                 = 'https://github.com/VFPX/zProc-zVFP-zCOM-IntelliSenseScripts'
    .LinkPrompt           = 'ZProc Home Page'
    .Notes                = GetNotes()
Endwith

Return loUpdateObject


Procedure GetNotes

    Local lcNotes
    Text to lcNotes NoShow
These IntelliSense scripts provide additional abilities:
    zProc: displays a list of user-defined and declared DLL functions with parameter information as a tooltip.
    zVFP: displays a list of native VFP function with parameter information as a tooltip.
    zCOM: displays a list of all registered COM objects.

The download ZIP file contains the following:
    Install_zproc.prg	Program to install/uninstall script to foxcode table
    zproc.Dbf/zproc.fpt	Table containing information for zproc/zvfp scripts
    zproc_method.bmp, VfpNativeFuncs.bmp,ComClasses.bmp	Graphic files used in IntelliSense list
    EndText   
    Return lcNotes
EndProc
