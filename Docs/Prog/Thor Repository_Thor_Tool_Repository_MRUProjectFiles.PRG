Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

Local lcFile, lcFileName, lcHomeFolder, lcThisFolder, loContextMenu, loFile, loPEME_Tools
If Pcount() = 1						  ;
		And 'O' = Vartype (lxParam1)  ;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1

		* Required
		.Prompt		 = 'MRU files in this project' && used when tool appears in a menu
		.Description = 'Popup menu of MRU lists for files in this project' && may be lengthy, including CRs, etc

		* For public tools, such as PEM Editor, etc.
		.Source	  = 'Thor Repository' && e.g., 'PEM Editor'
		.Category = 'Misc.'
		.Author	  = 'Jim Nelson'
	Endwith

	Return lxParam1
Endif

****************************************************************
****************************************************************
* Normal processing for this tool begins here.    

lcThisFolder = Addbs (Justpath (Sys(16)))

#Define cnMaxItemsInList 20

If 0 = _vfp.Projects.Count
	Return
Endif

* see	http://vfpx.codeplex.com/wikipage?title=PEM%20Editor%20Tools%20Object
loPEME_Tools = Execscript (_Screen.cThorDispatcher, 'class= tools from pemeditor')

Use In (Select ('GF_GetMaxTimeStamp')) && Close GF_GetMaxTimeStamp
Use In (Select ('MRU_ProjectFiles')) && Close MRU_ProjectFiles
Create Cursor MRU_ProjectFiles (FileName C(240), RelativeFileName C(240), Ext C(3), Timestamp T)
lcHomeFolder = Addbs (_vfp.ActiveProject.HomeDir)

For Each loFile In _vfp.ActiveProject.Files FoxObject
	lcFile = loFile.Name
	Insert Into MRU_ProjectFiles Values (lcFile, loPEME_Tools.GetRelativePath (lcFile, lcHomeFolder), Upper (Justext (lcFile)), GetFileDateTime (lcFile))
Endfor

loContextMenu = Execscript (_Screen.cThorDispatcher, 'class= contextmenu')

AddMRUType (loContextMenu, 'Ext = "VCX"', 'ClassLibs')
AddMRUType (loContextMenu, 'Ext = "SCX"', 'Forms')
AddMRUType (loContextMenu, 'Ext = "PRG"', 'PRGs')
AddMRUType (loContextMenu, 'Ext = "FRX"', 'Reports')
AddMRUType (loContextMenu, 'Ext = "MNX"', 'Menus')
AddMRUType (loContextMenu, 'Not InList(Ext, "VCX", "SCX", "PRG", "FRX", "MNX")', 'Others')

Use in MRU_ProjectFiles 

If loContextMenu.Activate()
	lcFileName = loContextMenu.KeyWord
	loPEME_Tools.EditSourceX (lcFileName)
Endif



Procedure AddMRUType (toContextMenu, tcSelectionPhrase, tcPrompt)
	Local laFiles[1], lnI
	Select  Top cnMaxItemsInList  *	 ;
		From MRU_ProjectFiles		 ;
		Where &tcSelectionPhrase	 ;
		Order By Timestamp Desc		 ;
		Into Array laFiles

	If _Tally = 0
		Return
	Endif

	toContextMenu.AddSubMenu (tcPrompt)
	For lnI = 1 To Alen (laFiles, 1)
		toContextMenu.AddMenuItem (Trim (laFiles (lnI, 2)), , , , Trim (laFiles (lnI, 1)))
	Endfor
	toContextMenu.EndSubMenu()

	Return

Endproc



Procedure GetFileDateTime
	Lparameters tcFile

	Local laFileInfo[1], laMaxDateTime[1], lcExt, ldFileDate

	If Not File (tcFile)
		Return {// ::}
	Endif

	lcExt = Upper (Justext (tcFile))

	If Inlist (lcExt, 'SCX', 'VCX', 'FRX')
		Use (tcFile) Again In 0 Alias GF_GetMaxTimeStamp
		Select Max (Timestamp) From GF_GetMaxTimeStamp Into Array laMaxDateTime
		ldFileDate = Ctot (TimeStampToDate (laMaxDateTime))
		Use In GF_GetMaxTimeStamp
	Else
		Adir (laFileInfo, tcFile)
		ldFileDate = Ctot (Dtoc (laFileInfo[3]) + ' ' + laFileInfo[4])
	Endif

	Return ldFileDate


Procedure TimeStampToDate
	*  METHOD: TimeStamp2Date()
	*
	*  AUTHOR: Richard A. Schummer            September 1994
	*
	*  COPYRIGHT (c) 1994-2001    Richard A. Schummer
	*     42759 Flis Dr  
	*     Sterling Heights, MI  48314-2850
	*     RSchummer@CompuServe.com
	*
	*  METHOD DESCRIPTION: 
	*     This procedure handles the conversion of the FoxPro TIMESTAMP field to 
	*     a readable (and understandable) date and time.  The procedure will return
	*     the date/time in three formats based on the cStyle parameter.  Timestamp 
	*     field is a 32-bit (numeric compressed) system that the FoxPro development
	*     team created to save on file space in the projects, screens, reports, and
	*     label databases.  This field is used to determine if objects need to be 
	*     recompiled (project manager), or syncronized across platforms (screens,
	*     reports, and labels).
	* 
	*  CALLING SYNTAX: 
	*     <variable> = ctrMetaDecode.TimeStamp2Date(<nTimeStamp>,<cStyle>)
	*
	*     Sample:
	*     ltDateTime = ctrMetaDecode.TimeStamp2Date(TimeStamp,"DATETIME")
	* 
	*  INPUT PARAMETERS: 
	*     nTimeStamp = Required field, must be numeric, no check to verify the
	*                  data passed is valid FoxPro Timestamp, just be sure it is
	*     cStyle     = Not required (defaults to "DATETIME"), must be character, 
	*                  and must be one of the following:
	*                   "DATETIME" will return the date/time in MM/DD/YY HH:MM:SS
	*                   "DATE"     will return the date in MM/DD/YY format
	*                   "TIME"     will return the time in HH:MM:SS format
	*
	*  OUTPUT PARAMETERS:
	*     lcRetval    = The date/time (in requested format) is returned in 
	*                   character type.  Must be converted and parsed to be
	*                   used as date type.
	*


	*=============================================================
	* Tried to use this FFC class, but it sometimes gave an error:
	* This.oFrxCursor.GetTimeStampString(timestamp)
	*=============================================================


	Lparameter tnTimeStamp, tcStyle

	Local lcRetVal, lnDay, lnHour, lnMinute, lnMonth, lnSecond, lnYear

	If Type ('tnTimeStamp') # 'N'          &&  Timestamp must be numeric
		Wait Window 'Time stamp passed is not numeric'
		Return ''
	Endif

	If tnTimeStamp = 0                     &&  Timestamp is zero until built in project
		Return 'Not built into App'
	Endif

	If Type ('tcStyle') # 'C'              &&  Default return style to both date and time
		tcStyle = 'DATETIME'
	Endif

	If Not Inlist (Upper (tcStyle), 'DATE', 'TIME', 'DATETIME')
		Wait Window 'Style parameter must be DATE, TIME, or DATETIME'
		Return ''
	Endif

	lnYear	= ((tnTimeStamp / (2 ** 25) + 1980))
	lnMonth	= ((lnYear - Int (lnYear)    ) * (2 ** 25)) / (2 ** 21)
	lnDay	= ((lnMonth - Int (lnMonth)  ) * (2 ** 21)) / (2 ** 16)

	lnHour	 = ((lnDay - Int (lnDay)      ) * (2 ** 16)) / (2 ** 11)
	lnMinute = ((lnHour - Int (lnHour)    ) * (2 ** 11)) / (2 ** 05)
	lnSecond = ((lnMinute - Int (lnMinute)) * (2 ** 05)) * 2       &&  Multiply by two to correct
	&&  truncation problem built in
	&&  to the creation algorithm
	&&  (Source: Microsoft Tech Support)

	lcRetVal = ''

	If 'DATE' $ Upper (tcStyle)
		*< 4-Feb-2001 Fixed to display date in machine designated format (Regional Settings)
		*< lcRetVal = lcRetVal + RIGHT("0"+ALLTRIM(STR(INT(lnMonth))),2) + "/" +  ;
		*<                       RIGHT("0"+ALLTRIM(STR(INT(lnDay))),2)   + "/" +  ;
		*<                       RIGHT("0"+ALLTRIM(STR(INT(lnYear))), IIF(SET("CENTURY") = "ON", 4, 2))

		*< RAS 23-Nov-2004, change to work around behavior change in VFP 9.
		*< lcRetVal = lcRetVal + DTOC(DATE(lnYear, lnMonth, lnDay))
		lcRetVal = lcRetVal + Dtoc (Date (Int (lnYear), Int (lnMonth), Int (lnDay)))
	Endif

	If 'TIME' $ Upper (tcStyle)
		lcRetVal = lcRetVal + IIf ('DATE' $ Upper (tcStyle), ' ', '')
		lcRetVal = lcRetVal + Right ('0' + Alltrim (Str (Int (lnHour))), 2)   + ':' +  ;
			Right ('0' + Alltrim (Str (Int (lnMinute))), 2) + ':' +					   ;
			Right ('0' + Alltrim (Str (Int (lnSecond))), 2)
	Endif

	Return lcRetVal

Endproc

