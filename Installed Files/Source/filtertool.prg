Lparameters tcFilter, toTool

Local laLines[1], lcText, lnI

If Empty(tcFilter)
	Return .T.
Endif

lcText = toTool.Prompt	+ ' ' +			;
	toTool.Summary		+ ' ' +			;
	toTool.Description  + ' ' +			;
	toTool.Category		+ ' ' +			;
	toTool.Source       + ' ' +			;
	toTool.Author

For lnI = 1 To Alines(laLines, tcFilter, 5, ' ')
	If 0 = Atc(laLines[lnI], lcText)
		Return .F.
	Endif
Endfor
Return .T.

