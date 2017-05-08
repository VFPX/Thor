#Define CR Chr(13)

Lparameters lcText

If 250 < Len(lcText)
	lcText = QuotesAroundLongText(Left(lcText, 250)) + ';' + Chr(13) + Space(8) + '+' + QuotesAroundLongText(substr(lcText, 251)) 
	Return lcText
EndIf

lcText = Strtran(lcText, ['], [' + "'" + '])
lcText = Strtran(lcText, CR, [' + Chr(13) + '])
Return ['] + lcText + [']



	