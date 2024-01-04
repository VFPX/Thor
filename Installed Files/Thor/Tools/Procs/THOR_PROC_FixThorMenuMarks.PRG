#Define CRLF Chr[13] + Chr[10]

Local lcEX, lcExecMenuMarks, lcMark, lnI

If Pemstatus(_Screen, 'aThorMenuMarks', 5) = .F.
	Return
Endif


For lnI = 1 To Alen(_Screen.aThorMenuMarks)
	lcMark = _Screen.aThorMenuMarks[m.lnI]
	If Not Empty(m.lcMark)
		Try
			Execscript(m.lcMark)
		Catch
		Endtry
	Endif
Endfor
