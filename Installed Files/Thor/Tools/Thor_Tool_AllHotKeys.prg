Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1								;
		And 'O' = Vartype (m.lxParam1)		;
		And 'thorinfo' == Lower (m.lxParam1.Class)

	With m.lxParam1

		* Required
		.Prompt		   = 'Browse Hot Keys'
		.AppID 		   = 'Thor'

		* Optional
		Text To .Description Noshow && a description for the tool
Toggles display of tabs in the currently selected pageframe.
		Endtext
		.StatusBarText	 = ''
		.CanRunAtStartUp = .F.

		* These are used to group and sort tools when they are displayed in menus or the Thor form
		.Category = 'Thor' && creates categorization of tools; defaults to .Source if empty
		.Sort	  = 0 && the sort order for all items from the same Category

		* For public tools, such as PEM Editor, etc.
		.Author        = 'Jim Nelson'

	Endwith

	Return m.lxParam1
Endif

If Pcount() = 0
	Do ToolCode
Else
	Do ToolCode With m.lxParam1
Endif

Return


****************************************************************
****************************************************************
* Normal processing for this tool begins here.                  
* Normal processing for this tool begins here.                  
Procedure ToolCode
	Lparameters lxParam1

	Local lcAlias, lcFieldName, lcFields, lcSourceAlias, lnShifts, loBrowse

	lcAlias		  = 'AllThorSystemHotKeys'

	lcSourceAlias = 'AllThorSystemHotKeys_Source'
	Execscript(_Screen.cThorDispatcher, 'Thor_Proc_GetHotKeyDefs', m.lcSourceAlias)

	Replace All HotKey With Chrtran(HotKey, '+', '-') In (m.lcSourceAlias)
	Select  Distinct NShifts,																	;
			Padr(Iif('-' $ HotKey, Left(HotKey, Rat('-', HotKey) - 1), 'Unshifted'), 10) As cShift ;
		From (m.lcSourceAlias)                                As  Source						;
		Where nKeyCode > 0																		;
		Into Cursor Shifts

	lcFields = ''
	Scan
		lnShifts	= Shifts.NShifts
		lcFieldName	= Chrtran(cShift, '-', '_')
		lcFields	= m.lcFields + Textmerge([, Padr(Max(Iif(NShifts = <<lnShifts>>, Descript, '')), 100) as <<lcFieldName>>])
	Endscan

	Select  nKeyCode,																;
			Padr(Getwordnum(HotKey, Getwordcount(HotKey, '-'), '-'), 4) As Key		;
			&lcFields																;
		From (m.lcSourceAlias)                                As  Source			;
		Where nKeyCode > 0															;
		Group By 1, 2																;
		Into Cursor (m.lcAlias) Readwrite

	Use In (m.lcSourceAlias)
	Use In Shifts

	Select (m.lcAlias)
	Browse Nowait Name m.loBrowse
	m.loBrowse.AutoFit()
	loBrowse = Null

Endproc

