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
		.Description = 'Framework of tools to assist in creating tools'
		.Source		 = 'Thor'
		.Version	 = 'Thor - 1.21.02.11 - May 28, 2012'
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

	lcDisplay = '* ' + [<<lcVersion>>] + ccCRLF + ccCRLF		;
		+  '*   Thor Framework home page =  http://vfpx.codeplex.com/wikipage?title=Thor%20Tools%20Making%20Tools'

	If Not Empty (loFramework.External)
		lnCount	  = Alines ( laLines, loFramework.External, 5)
		lcDisplay = lcDisplay + ccCRLF + ccCRLF +  + Replicate ('*', 40) + ' External APPs ' + Replicate ('*', 40)
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
				lcDisplay = lcDisplay + ccCRLF													;
					+ ccCRLF + lcIndent + '* ' + Getwordnum (lcThisLine, 2) + ' home page = ' + lcHomePage ;
					+ CreateLocalIntellisense (lcVariable, lcThisLine)							;
					+ ccCRLF + lcIndent + lcVariable + 'ExecScript(_Screen.cThorDispatcher, "' + lcThisLine;
    				 + IIF(0 = (Occurs(["], lcThisLine) % 2), '"', '') + ')'
			Else
				lcDisplay = lcDisplay + ccCRLF								;
					+ CreateLocalIntellisense (lcVariable, lcThisLine)		;
					+ ccCRLF + lcIndent + lcVariable + 'ExecScript(_Screen.cThorDispatcher, "' + lcLine;
    				 + IIF(0 = (Occurs(["], lcLine) % 2), '"', '') + ')'
			Endif
		Endfor
	Endif

	lcDisplay = lcDisplay + ccCRLF + ccCRLF + Replicate ('*', 40) + '* Internal *' + Replicate ('*', 40)
	lnCount	  = Alines ( laLines, loFramework.Internal, 5)

	For lnI = 1 To lnCount
		lcLine = laLines[lnI]
		Do Case
			Case lcLine = [Empty]
				lcDisplay = lcDisplay + ccCRLF
			Case lcLine = '*' or lcLine = 'Local'
				lcDisplay = lcDisplay + ccCRLF + lcIndent + lcLine
			Otherwise
				If '|' $ lcLine
					lnPos = At ('|', lcLine)
					lcDisplay = lcDisplay + ccCRLF + lcIndent		;
						+ Left (lcLine, lnPos - 1) + ' = ExecScript(_Screen.cThorDispatcher, "' + Substr (lcLine, lnPos + 1) ;
						+ IIF(0 = (Occurs(["], lcLine) % 2), '"', '') + ')'
				Else
					lcDisplay = lcDisplay + ccCRLF + lcIndent		;
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

	loObject = Execscript (_Screen.cThorDispatcher, lcThisLine)
	If 'O' # Vartype (loObject)
		Return ''
	Endif

	lcClass		   = loObject.Class
	lcClassLibrary = loObject.ClassLibrary
	If File (lcClassLibrary)
		lcQuote	 = Iif (' ' $ lcClassLibrary, '"', '')
		lcResult = ccCRLF + 'Local ' + Alltrim (lcVariable, 1, ' ', '=' ) + ' as ' + lcClass + ' of ' + lcQuote + lcClassLibrary + lcQuote
		Return lcResult
	Else
		Return ''
	Endif

Endproc
