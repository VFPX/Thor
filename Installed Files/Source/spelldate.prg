Lparameters tdDate, tlAbbreviate

Local lcMonth, ldDate
ldDate	= Evl (tdDate, Date())
lcMonth	= Cmonth (ldDate)
If tlAbbreviate And Len (lcMonth) > 4
	lcMonth = Left (lcMonth, 3) + '.'
Endif

Return lcMonth + ' ' + Transform (Day (ldDate)) + ', ' + Transform (Year (ldDate))
