#Define ccLF 	Chr(10)
#Define ccCR 	Chr(13)
#Define ccTab  	Chr(9)
#Define ccCRLF 	ccCR + ccLF

Lparameters lxParam1

****************************************************************
****************************************************************
* Standard prefix for all tools for Thor, allowing this tool to
*   tell Thor about itself.

If Pcount() = 1								;
		And 'O' = Vartype (lxParam1)		;
		And 'thorinfo' = Lower (lxParam1.Class)

	With lxParam1
		.Prompt		 = 'Framework'
		.AppID 		 = 'Thor'
		.Description = 'Framework of tools to assist in creating tools'
		.Source		 = 'Thor'
		.Version     = 'Thor - 1.45.26 - June 21, 2023'
		.Sort		 = 30
	Endwith

	Return lxParam1

Endif

Do ToolCode

Return

****************************************************************
****************************************************************
* Normal processing for this tool begins here.

Procedure ToolCode
	Local loFramework As Object
	Local laLines[1], lcDisplay, lcFileName, lcHomePage, lcIndent, lcLine, lcThisLine, lcVariable
	Local lnCount, lnI, lnPos

	lcIndent	= '' && Chr(9)
	loFramework	= Execscript (_Screen.cThorDispatcher, '?')

*** DH 2018-04-10: new URL
	lcDisplay = '* ' + [Thor - 1.45.26 - June 21, 2023] + chr(13) + chr(10) + chr(13) + chr(10)		;
		+  '*   Thor Framework home page =  https://github.com/VFPX/Thor/blob/master/Docs/Thor_tools_making_tools.md'

	If Not Empty (loFramework.External)
		lnCount	  = Alines ( laLines, loFramework.External, 5)
		lcDisplay = lcDisplay + chr(13) + chr(10) + chr(13) + chr(10) +  + Replicate ('*', 40) + ' External APPs ' + Replicate ('*', 40)
		For lnI = 1 To lnCount
			lcLine = laLines[lnI]
			If '||' $ lcLine
				lnPos	   = At ('||', lcLine)
				lcVariable = Left (lcLine, lnPos - 1) + ' = '
				lcLine	   = Substr (lcLine, lnPos + 2)
			Else
				lcVariable = ''
			Endif

			If '|' $ lcLine
				lnPos	   = At ('|', lcLine)
				lcHomePage = Substr (lcLine, lnPos + 1)
				lcThisLine = Left (lcLine, lnPos - 1)
				lcDisplay = lcDisplay + chr(13) + chr(10)													;
					+ chr(13) + chr(10) + lcIndent + '* ' + Getwordnum (lcThisLine, 2) + ' home page = ' + lcHomePage ;
					+ CreateLocalIntellisense (lcVariable, lcThisLine)							;
					+ chr(13) + chr(10) + lcIndent + lcVariable + 'ExecScript(_Screen.cThorDispatcher, "' + lcThisLine;
    				 + IIF(0 = (Occurs(["], lcThisLine) % 2), '"', '') + ')'
			Else
				lcDisplay = lcDisplay + chr(13) + chr(10)								;
					+ CreateLocalIntellisense (lcVariable, lcThisLine)		;
					+ chr(13) + chr(10) + lcIndent + lcVariable + 'ExecScript(_Screen.cThorDispatcher, "' + lcLine;
    				 + IIF(0 = (Occurs(["], lcLine) % 2), '"', '') + ')'
			Endif
		Endfor
	Endif

	lcDisplay = lcDisplay + chr(13) + chr(10) + chr(13) + chr(10) + Replicate ('*', 40) + '* Internal *' + Replicate ('*', 40)
	lnCount	  = Alines ( laLines, loFramework.Internal, 5)

	For lnI = 1 To lnCount
		lcLine = laLines[lnI]
		Do Case
			Case lcLine = [Empty]
				lcDisplay = lcDisplay + chr(13) + chr(10)
			Case lcLine = '*' or lcLine = 'Local'
				lcDisplay = lcDisplay + chr(13) + chr(10) + lcIndent + lcLine
			Otherwise
				If '|' $ lcLine
					lnPos = At ('|', lcLine)
					lcDisplay = lcDisplay + chr(13) + chr(10) + lcIndent		;
						+ Left (lcLine, lnPos - 1) + ' = ExecScript(_Screen.cThorDispatcher, "' + Substr (lcLine, lnPos + 1) ;
						+ IIF(0 = (Occurs(["], lcLine) % 2), '"', '') + ')'
				Else
					lcDisplay = lcDisplay + chr(13) + chr(10) + lcIndent		;
						+ 'ExecScript(_Screen.cThorDispatcher, "' + lcLine ;
						+ IIF(0 = (Occurs(["], lcLine) % 2), '"', '') + ')'
				Endif
		Endcase
	Endfor

	lcFileName = Forceext (Addbs (Sys(2023)) + 'ThorFramework', 'prg')
	Try
		Erase (lcFileName)
		Strtofile (lcDisplay, lcFileName, .F.)
	Catch

	Endtry
	Modify Command (lcFileName) Nowait

Endproc


Procedure CreateLocalIntellisense (lcVariable, lcThisLine)
	Local lcClass, lcClassLibrary, lcQuote, lcResult, loObject

 	Try 
 		loObject = Execscript (_Screen.cThorDispatcher, lcThisLine)
 	Catch to loException
 		loObject = .F.
 	EndTry
	If 'O' # Vartype (loObject)
		Return ''
	Endif

	lcClass		   = loObject.Class
	lcClassLibrary = loObject.ClassLibrary
	If File (lcClassLibrary)
		lcQuote	 = Iif (' ' $ lcClassLibrary, '"', '')
		lcResult = chr(13) + chr(10) + 'Local ' + Alltrim (lcVariable, 1, ' ', '=' ) + ' as ' + lcClass + ' of ' + lcQuote + lcClassLibrary + lcQuote
		Return lcResult
	Else
		Return ''
	Endif

Endproc
