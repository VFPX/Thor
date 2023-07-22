#Define CR Chr[13]
#Define LF Chr(10)
#Define cnIndent Space(30)

Lparameters lcText, llDivider, lnOffset

Local laStax[1], lcLine, lcLogtext, lcPRG, lcPrefix, lcProcedure, lcSuffix, lnLine, lnRow, lnStax
lnStax = Astackinfo (laStax)

If Evl (lcText, '' ) == 'Begin CFU' Or Not Pemstatus (_Screen, 'cThorLogForCFU', 5)
	_Screen.AddProperty ('cThorLogForCFU', Addbs (Sys(2023)) + 'Thor_CFU_Log_' + Ttoc(Datetime(),1) + '.txt')
Endif

Do Case
	Case llDivider
		lcLine = '*===== ' + lcText + '  '
		Strtofile (CR + LF + Padr (lcLine, 150, '=') + CR + LF, _Screen.cThorLogForCFU, 1)

	Case lnStax > (3 + Evl(lnOffset, 0))
		lnRow = lnStax - (3 + Evl(lnOffset, 0))

		*!* * Removed 6/5/2012 / JRN
		*!* lcProcedure	= laStax[lnRow, 3]
		*!* lcPRG		= laStax[lnRow, 4]
		*!* lnLine		= laStax[lnRow, 5]
		*!* lcPrefix	= Time()
		*!* lcSuffix    = Iif (										;
		*!* 	  lcProcedure # Juststem (Justfname (lcPRG)),		;
		*!* 	  ' ' + lcProcedure + ' in',						;
		*!* 	  '')												;
		*!* 	+ ' ' + Justfname (lcPRG)							;
		*!* 	+ ', line ' + Transform (lnLine)

		lcPRG		= laStax[lnRow, 4]
		lnLine		= laStax[lnRow, 5]
		lcPrefix	= Time()
		lcSuffix    = ' ' + Justfname (lcPRG) + ', line ' + Transform (lnLine)

		If Empty (lcText)
			lcLogtext = lcPrefix + '  ' + lcSuffix
		Else
			lcLogtext = lcPrefix + '  ' + lcText + CR + LF + cnIndent + lcSuffix
		Endif

		Strtofile (lcLogtext + CR + LF, _Screen.cThorLogForCFU, 1)
Endcase
