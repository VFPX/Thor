#Define CR Chr[13]
#Define LF Chr(10)
#Define Tab Chr(9)
#Define ccIndent Space(25)

Lparameters lcText, llDivider, lnOffSet

Local laStax[1], lcLine, lcLogtext, lcMore, lcPRG, lcPrefix, lcStem, lcSuffix, lnLine, lnRow, lnStax

lnStax = Astackinfo (laStax)

If Evl(m.lcText, '' ) = 'Begin CFU' Or Not Pemstatus (_Screen, 'cThorLogForCFU', 5)
	If PemStatus(_Screen, 'cThorCFUFolder', 5) = .F.
		_Screen.AddProperty('cThorCFUFolder', Addbs(Sys(2023)))
	EndIf 
	_Screen.AddProperty('cThorLogForCFU', _Screen.cThorCFUFolder + 'EventLog.txt')
Endif

Do Case
	Case m.llDivider
		lcLine = '*===== ' + m.lcText + '  '
		Strtofile (CR + LF + Padr (m.lcLine, 100, '=') + CR + LF, _Screen.cThorLogForCFU, 1)

	Case .T. && m.lnStax > (3 + Evl(m.lnOffSet, 0))
		lnRow = m.lnStax - (3 + Evl(m.lnOffSet, 0))

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

		lcMore = ''
		For lnRow = m.lnStax - 1  To 1 Step - 1
			lcPRG	 = m.laStax[m.lnRow, 4]

			Do Case
				Case 'thor_proc_check_for_updates.prg' $ m.lcPRG
					Exit

				Case '.tmp' = Right(m.lcPRG, 4)

				Otherwise

					lnLine	 = m.laStax[m.lnRow, 5]
					lcSuffix = ' ' + Justfname (m.lcPRG) + ', line ' + Transform (m.lnLine)
					lcMore	 = m.lcMore + ccIndent + m.lcSuffix + CR + LF
			Endcase
		Endfor


					lcPrefix = Time()
		If Empty (m.lcText)
			lcLogtext = m.lcPrefix + '  ' + m.lcMore
		Else
			lcLogtext = m.lcPrefix + '  ' + m.lcText + CR + LF + m.lcMore
		Endif

		Strtofile (m.lcLogtext + CR + LF, _Screen.cThorLogForCFU, 1)
Endcase
