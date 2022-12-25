Lparameters lcFromPRG, lcToPRG

Local lcNewText, lcSourceCode, lcText

lcSourceCode = Filetostr (Forceext (lcFromPRG, 'PRG'))
Do While .T.
	lcText = Strextract (lcSourceCode, '<<<<', '>>>>', 1, 4)
	If Empty (lcText)
		Exit 
	Endif
	lcNewText	 = Evaluate (Substr (lcText, 5, Len (lcText) - 8))
	lcSourceCode = Stuff (lcSourceCode, At (lcText, lcSourceCode), Len (lcText), lcNewText)
Enddo && while .T.

lcSourceCode = Strtran (lcSourceCode, 'Procs_For_Thor', 'Procs')
StrTofile (lcSourceCode, Forceext (lcToPRG, 'PRG')) 


