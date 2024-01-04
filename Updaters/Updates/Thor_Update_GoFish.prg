Lparameters loUpdateObject

With m.loUpdateObject
	.AppName			  = 'GoFish.APP'
	.ApplicationName	  = 'GoFish'
	.ToolName			  = 'Thor_Tool_GoFish'
	.SourceFileURL		  = 'https://raw.githubusercontent.com/VFPX/GoFish/master/Source/Source.zip'
	.Component			  = 'No'
	.VersionLocalFilename = 'GoFishVersionFile.txt'
	.Link				  = 'https://github.com/VFPX/GoFish'
	.VersionFileURL		  = 'https://raw.githubusercontent.com/VFPX/GoFish/master/_GoFishVersionFile.txt'
	.ProjectCreationDate  = Date(2023, 10, 9)

	.RegisterWithThor = GetRegisterWithThor()

Endwith

Return m.loUpdateObject

* ================================================================================
* ================================================================================
* ================================================================================

Procedure GetRegisterWithThor()

Local lcAppName, lcClassDefinitions, lcToolCode, lcDefineStatements, lcDescription, lcRegisterWithThor 

* Following indirect sequence is used so that blocks of text (code) can be pasted in from working code.

* The code in Proc ToolCode
lcToolCode 		   = GetToolCode()

* somewhat of a misnomer; all procedure and class definitions that follow Proc ToolCode
lcClassDefinitions = GetClassDefinitions()

text to lcRegisterWithThor noshow textmerge
	MessageBox('GoFish installed', 0, 'GoFish Installed')

* Create the tool under Thor's Tool folder

	loThorInfo = Execscript (_Screen.cThorDispatcher, 'Thor Register=')
	with loThorInfo

* Required properties.

		.PrgName	= 'Thor_Tool_GoFish'
		.Prompt 	= 'GoFish'
		.Description    = 'Advanced Code Search Tool'
		.FolderName = '##InstallFolder##'

		*!* ******** JRN Removed 2023-12-23 ********
		*!* << 'Text to .Description NoShow' >>
*!* <<lcDescription>>
		*!* << 'EndText' >>

		.CanRunAtStartUp = .F.

*!* ********  Removed 2023-12-28 ********
*!* * And the actual code for the tool
*!* 		<< 'Text To .DefineStatements Noshow '>>
*!* <<lcDefineStatements>>
*!* 		<< 'Endtext' >>

		<< 'Text To .Code Noshow '>>
<<lcToolCode>>
		<< 'Endtext' >>

		<< 'Text To .ClassDefinitions Noshow '>>
<<lcClassDefinitions>>
		<< 'Endtext' >>
		

		* Optional
		.StatusBarText      = 'GoFish'
		.Summary            = 'Code Search Tool' && if empty, first line of .Description is used
		.AppName            = 'GoFish.app' && no path, but include the extension; thus GoFish4.App
		.FullAppName        = _Screen.cThorFolder + 'TOOLS\APPS\GOFISH\GOFISH.APP' && full path to APP 
		.FolderName         = _Screen.cThorFolder + 'TOOLS\APPS\GOFISH' && folder name for APP
		.Classes            = 'loGoFish = gofishsearchengine of lib\gofishsearchengine.vcx' && separated by commas.  e.g.,  'thorinfo of thor_utils'  
		.PlugInClasses      = 'clsGoFishFormatGrid'  

		* For public tools, such as PEM Editor, etc.
		.Category           = 'Applications|GoFish'
		.Source             = 'GoFish' && Deprecated; use .Category instead
		.Author             = 'Matt Slay' 
		.Sort               = 1 && the sort order for all items from the same .Source
		.Link               = ccLink
		.PlugInClasses      = 'clsGoFishFormatGrid'
		.PlugIns            = 'GoFish Results Grid'
		
* Register the tool with Thor.
		llRegister = .Register()
		
		if llRegister
			lnSelect = select()
			try
				ExecScript(_Screen.cThorDispatcher, 'Thor_Proc_UnInstallGoFish5')
			catch
			endtry
			select (lnSelect)
		endif llRegister
		
	endwith
endtext

Return m.lcRegisterWithThor 
EndProc


* ================================================================================
* ================================================================================
Procedure GetToolCode
	Local lcCode

	Text To m.lcCode Noshow
	Do _Screen.cThorFolder + 'TOOLS\APPS\GOFISH\GOFISH.APP'
	EndText
	Return Evl(m.lcCode, '')
EndProc


* ================================================================================
* ================================================================================
Procedure GetClassDefinitions
	Local lcClassDefinitions

	Text To m.lcClassDefinitions Noshow

    Define Class clsGoFishFormatGrid As Custom

    	Source				= 'GoFish'
    	PlugIn				= 'GoFish Results Grid'
    	Description			= 'Provides access to GoFish results grid to set colors and other dynamic properties.'
    	Tools				= 'GoFish'
    	FileNames			= 'Thor_Proc_GoFish_FormatGrid.PRG'
    	DefaultFileName		= '*Thor_Proc_GoFish_FormatGrid.PRG'
    	DefaultFileContents	= ''

    	Procedure Init
    		****************************************************************
    		****************************************************************
    		#@@@#Text To This.DefaultFileContents Noshow
Lparameters toGrid, tcResultsCursor

*-- Sample 1: Dynamic row coloring as used by GF
Local lcFileNameColor, lcPRG, lcPRGColor, lcSCX, lcSCXColor, lcVCX, lcVCXColor

lcSCX	   = 'Upper(' + tcResultsCursor + '.filetype) = "SCX"'
lcSCXColor = 'RGB(0,0,128)'

lcVCX	   = 'Upper(' + tcResultsCursor + '.filetype) = "VCX"'
lcVCXColor = 'RGB(0,128,0)'

lcPRG	   = 'Upper(' + tcResultsCursor + '.filetype) $ "PRG TXT H INI XML HTM HTML ASP ASPX"'
lcPRGColor = 'RGB(255,0,0)'

toGrid.SetAll('DynamicForeColor', 'Iif(' + m.lcSCX + ', ' + m.lcSCXColor + ', ' +		;
	  'Iif(' + m.lcVCX + ', ' + m.lcVCXColor + ', ' +									;
	  'Iif(' + m.lcPRG + ',' + m.lcPRGColor + ', RGB(0,0,0))' +							;
	  ')' +																				;
	  ')', 'COLUMN')
Return

*-- Sample 2: Alternative provided by Jim R. Nelson
*-- Assigns row colors based on field MatchType
#Define ccBolds "<Method>", "<Procedure>", "<Function>", "<Constant>", "<<Class Def>>", "<<Method Def>>", "<<Property Def>>"
#Define ccPropertyName "<Property Name>"
#Define ccPropertyValue "<Property Value>"

Local lcBolds, lcCode, lcCodeColor, lcComments, lcCommentsColor, lcFileName, lcOthersColor
Local lcPropNameColor, lcPropertyName, llRegister

lcPropertyName = [0 # Atc("<Property", ] + m.tcResultsCursor + [.MatchType)]
lcComments	   = [0 # Atc("<Comment", ] + m.tcResultsCursor + [.MatchType)]
lcFileName	   = [0 # Atc("<File", ] + m.tcResultsCursor + [.MatchType)]
lcCode		   = 'Left(' + m.tcResultsCursor + '.MatchType, 1) # "<"'

* ForeColor
lcPropNameColor	= 'RGB(0,128,0)'
lcCommentsColor	= 'RGB(0,0,0)'
lcCodeColor		= 'RGB(0,0,0)'
lcOthersColor	= 'RGB(0,0,255)'

m.toGrid.SetAll ('DynamicForeColor', 'ICase(' +					;
	  m.lcPropertyName + ', ' + m.lcPropNameColor + ', ' +		;
	  m.lcComments + ', ' + m.lcCommentsColor + ', ' +			;
	  m.lcCode + ', ' + m.lcCodeColor + ', ' +					;
	  m.lcOthersColor + ')')

* BackColor
lcCommentsColor	= 'RGB(192,192,192)'
lcFileNameColor	= 'Rgb(176, 224, 230)'
m.toGrid.SetAll ('DynamicBackColor', 'ICase(' +				;
	  m.lcComments + ', ' + m.lcCommentsColor + ', ' +		;
	  m.lcFileName + ', ' + m.lcFileNameColor + ', ' +		;
	  ' Rgb(255,255,255))')

* Bold
lcBolds		 = [Inlist(] + m.tcResultsCursor + [.MatchType, ccBolds)]
m.toGrid.SetAll ('DynamicFontBold', m.lcBolds)
		End#@@@#Text
    		****************************************************************
    		****************************************************************
		
	    Return 
	    EndProc
	
	EndDefine 

	Endtext

	Return Evl(m.lcClassDefinitions, '') 
Endproc


